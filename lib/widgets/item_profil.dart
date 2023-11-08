import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:async'; //delayed

class ItemProfil extends StatefulWidget {
  @override
  _ItemProfilState createState() => _ItemProfilState();
}

class _ItemProfilState extends State<ItemProfil> {
  final TextEditingController nameControl = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController handphoneController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Map<String, dynamic> userData = {};
  bool isLoading = true;
  bool isImageChanged = false;
  String originalPhotoURL = '';

  @override
  void initState() {
    super.initState();
    fetchUserData();
    originalPhotoURL = 'http://192.168.1.5:3000/images/${userData['photo']}';
  }

  Future<void> fetchUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username') ?? "";

    try {
      final response = await http.get(
        Uri.parse('http://192.168.1.5:3000/users/$username'),
      );

      if (response.statusCode == 200) {
        final userDataJson = json.decode(response.body);
        setState(() {
          userData = userDataJson["data"];
          isLoading = false;
          nameControl.text = userData['name'] ?? '';
          emailController.text = userData['email'] ?? '';
          handphoneController.text = userData['handphone'] ?? '';
          usernameController.text = userData['username'] ?? '';
          passwordController.text = userData['password'] ?? '';
          String? userId;
          userId = userData['id'].toString();
          print('userId');
          print(userId);
        });
      } else {
        isLoading = false;
      }
    } catch (e) {
      isLoading = false;
      print('Error: $e');
    }
  }

  Future<void> _pickImageFromGallery() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        userData['photo'] = pickedFile.path;
        isImageChanged = true;
        originalPhotoURL = userData['photo'];
      });
    }
  }

  Future<void> _updateUserData() async {
    String userId = userData['id'].toString();
    String serverUrl = 'http://192.168.1.5:3000/users/$userId';

    var request = http.MultipartRequest('PUT', Uri.parse(serverUrl));
    request.fields['name'] = nameControl.text;
    request.fields['email'] = emailController.text;
    request.fields['handphone'] = handphoneController.text;
    request.fields['username'] = usernameController.text;
    request.fields['password'] = passwordController.text;

    if (isImageChanged) {
      request.files
          .add(await http.MultipartFile.fromPath('photo', userData['photo']));
    } else {
      // use image before
      request.fields['photo'] = originalPhotoURL;
    }

    var response = await request.send();

    if (response.statusCode == 200) {
      // print('Data updated successfully');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Data upload successfully.'),
          backgroundColor: Color.fromARGB(248, 218, 149, 30),
        ),
      );
      await Future.delayed(Duration(seconds: 2));
      Navigator.pop(context);
    } else {
      // print('Data update failed');
      SnackBar(
        content: Text('Data update failed.'),
        backgroundColor: Color.fromARGB(248, 218, 149, 30),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20),
        Stack(
          children: [
            isLoading
                ? CircularProgressIndicator()
                : CircleAvatar(
                    radius: 50,
                    backgroundImage: isImageChanged
                        ? FileImage(File(userData['photo']))
                        : NetworkImage(
                            'http://192.168.1.5:3000/images/${userData['photo']}',
                          ) as ImageProvider,
                  ),
            Positioned(
              bottom: -5,
              right: -5,
              child: IconButton(
                icon: Icon(Icons.camera_alt_rounded),
                color: Colors.white,
                onPressed: _pickImageFromGallery,
              ),
            ),
          ],
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 10),
        ),
        buildCard("Name", Icons.person_rounded, nameControl),
        buildCard("Username", Icons.verified_rounded, usernameController),
        buildCard("Password", Icons.lock_rounded, passwordController),
        buildCard("Email", Icons.email_rounded, emailController),
        buildCard("Handphone", Icons.phone_rounded, handphoneController),
        SizedBox(height: 20),
        ElevatedButton.icon(
          onPressed: _updateUserData,
          icon: Icon(Icons.save_as_rounded),
          label: Text(
            "Save",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
              Color.fromARGB(248, 212, 81, 0),
            ),
            padding: MaterialStateProperty.all(
              EdgeInsets.symmetric(vertical: 10, horizontal: 40),
            ),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildCard(
      String label, IconData icon, TextEditingController controller) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      color: Colors.white30,
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            ListTile(
              leading: Icon(icon),
              iconColor: Colors.white,
              title: Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 18,
                  shadows: <Shadow>[
                    Shadow(
                      offset: Offset(0, 1),
                      blurRadius: 1,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
            ),
            TextFormField(
              controller: controller,
              style: TextStyle(color: Colors.black, fontSize: 14),
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromARGB(248, 138, 73, 3),
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                labelStyle: TextStyle(
                  color: Colors.white,
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
