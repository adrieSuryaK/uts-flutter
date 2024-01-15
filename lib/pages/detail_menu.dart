import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uts_flutter/widgets/loading_animation.dart';

class DetailMenuPage extends StatelessWidget {
  final DocumentSnapshot documentSnapshot;

  DetailMenuPage({required this.documentSnapshot});

  // text field controller
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _costController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  final CollectionReference _menus =
      FirebaseFirestore.instance.collection('menus');

  String imageUrl = '';

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
          ],
        ),
      ),
    );
  }
}
