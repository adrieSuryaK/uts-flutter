import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uts_flutter/widgets/loading_animation.dart';

class DetailMenuAdminPage extends StatelessWidget {
  final DocumentSnapshot documentSnapshot;

  DetailMenuAdminPage({required this.documentSnapshot});

  // text field controller
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _costController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  final CollectionReference _menus =
      FirebaseFirestore.instance.collection('menus');

  String imageUrl = '';

  // for Update operation
  Future<void> _update(BuildContext context,
      [DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      _nameController.text = documentSnapshot['name'];
      _descController.text = documentSnapshot['description'];
      _costController.text = documentSnapshot['cost'].toString();
    }

    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext ctx) {
        return Padding(
          padding: EdgeInsets.only(
            top: 20,
            right: 20,
            left: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  "UPDATE MENU",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(248, 212, 81, 0)),
                ),
              ),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  hintText: 'eg.Elon',
                ),
              ),
              TextField(
                keyboardType: TextInputType.number,
                controller: _descController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'Note',
                ),
              ),
              TextField(
                keyboardType: TextInputType.number,
                controller: _costController,
                decoration: const InputDecoration(
                  labelText: 'Cost',
                  hintText: 'eg.1000',
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      final String name = _nameController.text;
                      final String desc = _descController.text;
                      final int? cost = int.tryParse(_costController.text);

                      if (imageUrl.isEmpty) {
                        imageUrl = documentSnapshot?['image'];
                      }

                      if (cost != null) {
                        await _menus.doc(documentSnapshot!.id).update({
                          "name": name,
                          "cost": cost,
                          "description": desc,
                          "image": imageUrl,
                        });
                        _nameController.text = '';
                        _descController.text = '';
                        _costController.text = '';
                        imageUrl = '';

                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return LoadingAnimation();
                          },
                        );

                        await Future.delayed(Duration(seconds: 2));
                        Navigator.of(context).pop();
                        Navigator.pushReplacementNamed(context, 'Home');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(248, 212, 81, 0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                    ),
                    child: const Text("Update"),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () async {
                          final file = await ImagePicker().pickImage(
                            source: ImageSource.gallery,
                          );
                          print('Selected File: $file');
                          if (file != null) {
                            String fileName = DateTime.now()
                                .microsecondsSinceEpoch
                                .toString();
                            Reference referenceRoot =
                                FirebaseStorage.instance.ref();
                            Reference referenceDireImages =
                                referenceRoot.child('image_menus');
                            Reference referenceImageaToUpload =
                                referenceDireImages.child(fileName);
                            try {
                              await referenceImageaToUpload
                                  .putFile(File(file.path));
                              imageUrl = await referenceImageaToUpload
                                  .getDownloadURL();
                              print('Image URL: $imageUrl');
                            } catch (error) {
                              print('Error uploading image: $error');
                            }
                          }
                        },
                        icon: const Icon(
                          Icons.folder_rounded,
                          size: 30,
                          color: Color.fromARGB(248, 212, 81, 0),
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          final file = await ImagePicker().pickImage(
                            source: ImageSource.camera,
                          );
                          print('Selected File: $file');
                          if (file != null) {
                            String fileName = DateTime.now()
                                .microsecondsSinceEpoch
                                .toString();
                            Reference referenceRoot =
                                FirebaseStorage.instance.ref();
                            Reference referenceDireImages =
                                referenceRoot.child('image_menus');
                            Reference referenceImageaToUpload =
                                referenceDireImages.child(fileName);
                            try {
                              await referenceImageaToUpload
                                  .putFile(File(file.path));
                              imageUrl = await referenceImageaToUpload
                                  .getDownloadURL();
                              print('Image URL: $imageUrl');
                            } catch (error) {
                              print('Error uploading image: $error');
                            }
                          }
                        },
                        icon: const Icon(
                          Icons.camera_alt_rounded,
                          size: 30,
                          color: Color.fromARGB(248, 212, 81, 0),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // for delete operation
  Future<void> _delete(
      BuildContext context, String productID, documentSnapshot) async {
    // Get Url image
    final documentSnapshot = await _menus.doc(productID).get();
    final imageUrlToDelete = documentSnapshot['image'];

    await _menus.doc(productID).delete();

    // Del image
    if (imageUrlToDelete != null && imageUrlToDelete.isNotEmpty) {
      try {
        Reference referenceToDelete =
            FirebaseStorage.instance.refFromURL(imageUrlToDelete);
        await referenceToDelete.delete();
        print('Image deleted from Firebase Storage');
      } catch (error) {
        print('Error deleting image from Firebase Storage: $error');
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return LoadingAnimation();
      },
    );

    await Future.delayed(Duration(seconds: 2));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("You have successfully deleted a menu"),
        backgroundColor: Color.fromARGB(248, 218, 149, 30),
      ),
    );
    Navigator.pushReplacementNamed(context, 'Home');
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            'Detail Menu',
            style: TextStyle(
              color: Color.fromARGB(248, 212, 81, 0),
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          toolbarHeight: 70,
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: <Color>[
                      Color.fromARGB(248, 138, 73, 3),
                      Color.fromARGB(248, 201, 146, 87),
                      Color.fromARGB(249, 255, 234, 127),
                      Color.fromARGB(248, 138, 73, 3),
                    ],
                    tileMode: TileMode.mirror,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(
                      documentSnapshot['image'],
                      width: double.infinity,
                      height: 400.0,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(height: 16.0),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        documentSnapshot['name'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 23.0,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Container(
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: Colors.white38,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Text(
                          'Rp. ${documentSnapshot['cost'].toString()}',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(248, 212, 81, 0),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        documentSnapshot['description'],
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 20.0,
              right: 20.0,
              child: Row(
                children: [
                  Container(
                    width: 40.0,
                    height: 40.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromARGB(248, 212, 81, 0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 5.0,
                          spreadRadius: 2.0,
                        ),
                      ],
                    ),
                    child: IconButton(
                      color: Colors.white,
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        _update(context, documentSnapshot);
                      },
                    ),
                  ),
                  SizedBox(width: 16.0),
                  Container(
                    width: 40.0,
                    height: 40.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromARGB(248, 212, 81, 0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 5.0,
                          spreadRadius: 2.0,
                        ),
                      ],
                    ),
                    child: IconButton(
                      color: Colors.white,
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _delete(context, documentSnapshot.id, documentSnapshot);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
