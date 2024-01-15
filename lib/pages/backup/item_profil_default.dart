import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

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

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username') ?? "";

    try {
      final response = await http.get(
        Uri.parse('http://192.168.1.7:3005/users/$username'),
      );

      if (response.statusCode == 200) {
        final userDataJson = json.decode(response.body);
        setState(() {
          userData = userDataJson["data"];
          isLoading = false; // get data set to false
          nameControl.text = userData['name'] ?? '';
          emailController.text = userData['email'] ?? '';
          handphoneController.text = userData['handphone'] ?? '';
          usernameController.text = userData['username'] ?? '';
          // passwordController.text = userData['password'] ?? '';
          String? userId;
          userId = userData['id'].toString();
          print('userId');
          print(userId);
        });
      } else {
        isLoading = false;
        //
      }
    } catch (e) {
      isLoading = false;
      print('Error: $e');
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
                ? CircularProgressIndicator() // Loading
                : CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                      'http://192.168.1.7:3005/images/${userData['photo']}',
                    ),
                  ),
            Positioned(
              bottom: -5,
              right: -5,
              child: IconButton(
                icon: Icon(Icons.camera_alt),
                onPressed: () {
                  //
                },
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
              style: TextStyle(color: Colors.white, fontSize: 14),
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromARGB(255, 246, 78, 56),
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
