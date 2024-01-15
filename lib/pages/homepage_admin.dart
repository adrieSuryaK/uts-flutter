import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:uts_flutter/pages/timeline_page.dart';
import 'package:uts_flutter/pages/user_page.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:uts_flutter/widgets/help_center_drawer.dart';
import 'package:uts_flutter/pages/detail_menu_admin.dart';
import 'package:uts_flutter/widgets/loading_animation.dart';
import 'package:uts_flutter/widgets/kategori_widget.dart';

class HomePageAdmin extends StatefulWidget {
  final int initialIndex;
  HomePageAdmin({this.initialIndex = 0});

  @override
  _HomePageAdminState createState() => _HomePageAdminState();
}

class _HomePageAdminState extends State<HomePageAdmin> {
  Map<String, dynamic> userData = {};

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
        Uri.parse('http://192.168.1.7:3000/users/$username'),
      );

      if (response.statusCode == 200) {
        final userDataJson = json.decode(response.body);
        setState(() {
          userData = userDataJson["data"];
        });
      } else {
        //
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  // text field controller
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _costController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  final CollectionReference _menus =
      FirebaseFirestore.instance.collection('menus');

  String searchText = '';
  String imageUrl = '';

  // for create operation
  Future<void> _create([DocumentSnapshot? documentSnapshot]) async {
    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                right: 20,
                left: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    "CREATE MENU",
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
                      hintText: 'eg.Sushi',
                      labelStyle: TextStyle(color: Colors.black),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black))),
                ),
                TextField(
                  controller: _descController,
                  decoration: const InputDecoration(
                      labelText: 'Description',
                      hintText: 'eg.Note',
                      labelStyle: TextStyle(color: Colors.black),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black))),
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: _costController,
                  decoration: const InputDecoration(
                      labelText: 'Cost',
                      hintText: 'eg.1000',
                      labelStyle: TextStyle(color: Colors.black),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black))),
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        final String name = _nameController.text;
                        final String desc = _descController.text;
                        final int? cost = int.tryParse(_costController.text);
                        if (cost != null) {
                          await _menus.add({
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
                          Navigator.of(context).pop();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(248, 212, 81, 0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                      ),
                      child: const Text("Create"),
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () async {
                            final file = await ImagePicker()
                                .pickImage(source: ImageSource.gallery);
                            print('Selected File: $file');
                            if (file == null) return;
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
                          },
                          icon: const Icon(
                            Icons.folder_rounded,
                            size: 30,
                            color: Color.fromARGB(248, 212, 81, 0),
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            final file = await ImagePicker()
                                .pickImage(source: ImageSource.camera);
                            print('Selected File: $file');
                            if (file == null) return;
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
                          },
                          icon: const Icon(
                            Icons.camera_alt_rounded,
                            size: 30,
                            color: Color.fromARGB(248, 212, 81, 0),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          );
        });
  }

  // for Update operation
  Future<void> _update([DocumentSnapshot? documentSnapshot]) async {
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
                        Navigator.of(context).pop();
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
  Future<void> _delete(String productID, documentSnapshot) async {
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

    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("You have successfully deleted a menu"),
        backgroundColor: Color.fromARGB(248, 218, 149, 30),
      ),
    );
  }

  void _onSearchChanged(String value) {
    setState(() {
      searchText = value;
    });
  }

  bool isSearchClicked = false;
  bool showCarousel = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: HelpCenterDrawer(),
      backgroundColor: Color.fromARGB(248, 138, 73, 3),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: isSearchClicked
            ? Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Color.fromARGB(248, 138, 73, 3),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                  style: TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(16, 20, 16, 12),
                      hintStyle: TextStyle(color: Colors.white),
                      border: InputBorder.none,
                      hintText: 'Search...'),
                ),
              )
            : const Text(
                'Home',
                style: TextStyle(
                  color: Color.fromARGB(248, 212, 81, 0),
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
        toolbarHeight: 70,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              color: Color.fromARGB(248, 212, 81, 0),
              onPressed: () {
                setState(() {
                  isSearchClicked = !isSearchClicked;
                });
              },
              icon: Icon(
                isSearchClicked ? Icons.close : Icons.search_rounded,
                size: 30,
              ))
        ],
      ),
      body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(0.0, 16.0, 16.0, 0.0),
                          child: Align(
                            alignment: Alignment.topRight,
                            child: Text(
                              'Category',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              SmallCategoryWidget(
                                  icon: Icons.fastfood, label: 'Fast Food'),
                              // SmallCategoryWidget(
                              //     icon: Icons.local_drink, label: 'Drinks'),
                              SmallCategoryWidget(
                                  icon: Icons.cake, label: 'Cakes'),
                              SmallCategoryWidget(
                                  icon: Icons.local_cafe, label: 'Coffee'),
                              SmallCategoryWidget(
                                  icon: Icons.local_dining, label: 'Food'),
                              SmallCategoryWidget(
                                  icon: Icons.icecream, label: 'Ice Cream'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SliverAppBar(
                backgroundColor: Colors.transparent,
                expandedHeight: 240.0,
                floating: true,
                pinned: false,
                automaticallyImplyLeading: false,
                flexibleSpace: FlexibleSpaceBar(
                    background: Visibility(
                  visible: showCarousel,
                  child: CarouselSlider(
                    options: CarouselOptions(
                      height: 240.0,
                      enableInfiniteScroll: true,
                      autoPlay: true,
                      aspectRatio: 16 / 9,
                      autoPlayCurve: Curves.fastOutSlowIn,
                      autoPlayAnimationDuration: Duration(milliseconds: 800),
                      viewportFraction: 1,
                    ),
                    items: [
                      'assets/images/food1.jpg',
                      'assets/images/food2.jpg',
                      'assets/images/drink1.jpg',
                      'assets/images/food3.jpg',
                      'assets/images/food4.jpg',
                    ].map((item) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.symmetric(horizontal: 0.0),
                            decoration: BoxDecoration(
                              // borderRadius: BorderRadius.circular(12.0),
                              image: DecorationImage(
                                image: AssetImage(item),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                )),
                bottom: PreferredSize(
                  child: Container(),
                  preferredSize: Size.fromHeight(0.0),
                ),
              ),
            ];
          },
          body: Container(
            padding: EdgeInsets.only(top: 15),
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
              ),
            ),
            child: StreamBuilder(
              stream: _menus.snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                if (streamSnapshot.hasData) {
                  final List<DocumentSnapshot> items = streamSnapshot.data!.docs
                      .where((doc) => doc['name'].toLowerCase().contains(
                            searchText.toLowerCase(),
                          ))
                      .toList();
                  return ListView.builder(
                    itemCount: (items.length / 2).ceil(),
                    itemBuilder: (context, index) {
                      final int startIndex = index * 2;
                      final int endIndex = startIndex + 1;

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            if (startIndex < items.length)
                              _buildMenuItem(items[startIndex]),
                            if (endIndex < items.length)
                              _buildMenuItem(items[endIndex]),
                          ],
                        ),
                      );
                    },
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _create(),
        backgroundColor: Color.fromARGB(248, 212, 81, 0),
        child: const Icon(Icons.add),
        mini: true,
      ),
      bottomNavigationBar: CurvedNavigationBar(
        onTap: (index) {
          switch (index) {
            case 1:
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) {
                    return TimelinePage();
                  },
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    const begin = Offset(1.0, 0.0);
                    const end = Offset.zero;
                    const curve = Curves.easeInOut;

                    var tween = Tween(begin: begin, end: end)
                        .chain(CurveTween(curve: curve));
                    var offsetAnimation = animation.drive(tween);

                    return SlideTransition(
                      position: offsetAnimation,
                      child: child,
                    );
                  },
                ),
              );
              break;
            case 2:
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) {
                    return UserPage();
                  },
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    const begin = Offset(1.0, 0.0);
                    const end = Offset.zero;
                    const curve = Curves.easeInOut;

                    var tween = Tween(begin: begin, end: end)
                        .chain(CurveTween(curve: curve));
                    var offsetAnimation = animation.drive(tween);

                    return SlideTransition(
                      position: offsetAnimation,
                      child: child,
                    );
                  },
                ),
              );
              break;
          }
        },
        height: 70,
        backgroundColor: Colors.white,
        color: Color.fromARGB(248, 138, 73, 3),
        buttonBackgroundColor: Color.fromARGB(248, 212, 81, 0),
        items: [
          Icon(
            Icons.home_rounded,
            size: 30,
            color: Colors.white,
          ),
          Icon(
            Icons.timeline_rounded,
            size: 30,
            color: Colors.white,
          ),
          Icon(
            Icons.person_rounded,
            size: 30,
            color: Colors.white,
          ),
        ],
        index: widget.initialIndex,
      ),
    );
  }

  Widget _buildMenuItem(DocumentSnapshot documentSnapshot) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailMenuAdminPage(
              documentSnapshot: documentSnapshot,
            ),
          ),
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.40,
        decoration: BoxDecoration(
          color: Colors.white38,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: SizedBox(
                width: double.infinity,
                height: 120.0,
                child: Image.network(
                  documentSnapshot['image'],
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    documentSnapshot['name'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    'Rp. ${documentSnapshot['cost'].toString()}',
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Color.fromARGB(248, 212, 81, 0),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () => _update(documentSnapshot),
                  icon: Icon(Icons.edit),
                  color: Color.fromARGB(248, 212, 81, 0),
                ),
                IconButton(
                  onPressed: () =>
                      _delete(documentSnapshot.id, documentSnapshot['image']),
                  icon: Icon(Icons.delete),
                  color: Color.fromARGB(248, 212, 81, 0),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
