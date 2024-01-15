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
import 'package:uts_flutter/pages/detail_menu.dart';
import 'package:uts_flutter/widgets/loading_animation.dart';
import 'package:uts_flutter/widgets/kategori_widget.dart';
import 'package:uts_flutter/pages/shoping_cart_page.dart';
import 'package:collection/collection.dart';

class SelectedMenuItem {
  final DocumentSnapshot documentSnapshot;
  int itemCount;

  SelectedMenuItem({required this.documentSnapshot, this.itemCount = 0});
}

class HomePage extends StatefulWidget {
  final int initialIndex;
  HomePage({this.initialIndex = 0});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, dynamic> userData = {};
  List<DocumentSnapshot> selectedMenus = [];
  List<Map<String, dynamic>> menuData = [];

  @override
  void initState() {
    super.initState();
    fetchUserData();
    initializeMenuData();
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

  void initializeMenuData() {
    // get firestore data
    _menus.get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((DocumentSnapshot documentSnapshot) {
        // Initial data menu with itemCount = 0 & isLoved = false
        Map<String, dynamic> menu = {
          'id': documentSnapshot.id,
          'itemCount': 0,
          'isLoved': false,
        };
        menuData.add(menu);
      });
    });
  }

  Future<void> _updateMenuCount(
      DocumentSnapshot documentSnapshot, int delta) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String menuId = documentSnapshot.id;

    List<Map<String, dynamic>> menuData = List<Map<String, dynamic>>.from(
        prefs.getStringList('selectedMenus')?.map((e) => json.decode(e)) ?? []);

    int index = menuData.indexWhere((menu) => menu['id'] == menuId);

    if (index != -1) {
      menuData[index]['itemCount'] += delta;
    } else {
      menuData.add({
        'id': menuId,
        'itemCount': delta,
      });
    }

    await prefs.setStringList(
        'selectedMenus', menuData.map((e) => json.encode(e)).toList());
  }

  // text field controller
  final TextEditingController _searchController = TextEditingController();

  final CollectionReference _menus =
      FirebaseFirestore.instance.collection('menus');

  String searchText = '';
  String imageUrl = '';

  void _onSearchChanged(String value) {
    setState(() {
      searchText = value;
    });
  }

  bool isSearchClicked = false;
  bool showCarousel = true;

  int itemCount = 0;
  bool isLoved = false;

  // int calculateTotalItemCount() {
  //   int totalItemCount = 0;
  //   for (var menu in selectedMenus) {
  //     var currentMenu = menuData.firstWhereOrNull(
  //       (menuData) => menuData['id'] == menu.id,
  //     );
  //     if (currentMenu != null) {
  //       totalItemCount += (currentMenu['itemCount'] as int);
  //     }
  //   }
  //   return totalItemCount;
  // }

  int calculateTotalItemCount() {
    int totalItemCount = 0;

    // count total menuData
    for (var menu in menuData) {
      totalItemCount += (menu['itemCount'] as int);
    }

    // count selectedMenus
    for (var menu in selectedMenus) {
      totalItemCount += (menu['itemCount'] as int);
    }

    return totalItemCount;
  }

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
          Align(
            alignment: Alignment.center,
            child: Stack(
              children: [
                IconButton(
                  color: Color.fromARGB(248, 212, 81, 0),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ShoppingCartPage(
                          selectedMenus: selectedMenus,
                          itemCount: calculateTotalItemCount(),
                        ),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.shopping_cart,
                    size: 30,
                  ),
                ),
                Positioned(
                  left: 10.0,
                  top: 10.0,
                  child: Container(
                    padding: EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red,
                    ),
                    child: Text(
                      calculateTotalItemCount().toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
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
            ),
          ),
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
    Map<String, dynamic>? currentMenu = menuData.firstWhereOrNull(
      (menu) => menu['id'] == documentSnapshot.id,
    );
    if (currentMenu == null) {
      currentMenu = {
        'id': documentSnapshot.id,
        'itemCount': 0,
        'isLoved': false
      };
      menuData.add(currentMenu);
    }

    final dynamic data = documentSnapshot.data();
    if (data is Map<String, dynamic> && data.containsKey('itemCount')) {
    } else {
      FirebaseFirestore.instance
          .collection('menus')
          .doc(documentSnapshot.id)
          .update({'itemCount': 0});
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailMenuPage(
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
            Stack(
              alignment: Alignment.topRight,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.0),
                    topRight: Radius.circular(12.0),
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    height: 120.0,
                    child: Image.network(
                      documentSnapshot['image'],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Stack(
                  alignment: Alignment.topRight,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12.0),
                        topRight: Radius.circular(12.0),
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        height: 120.0,
                        child: Image.network(
                          documentSnapshot['image'],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(8.0),
                      padding: EdgeInsets.all(0.0),
                      width: 30.0,
                      height: 30.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white60,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 2,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              if (currentMenu != null) {
                                currentMenu['isLoved'] =
                                    !(currentMenu['isLoved'] as bool? ?? false);
                              }
                            });
                          },
                          icon: Icon(
                            Icons.favorite,
                            size: 15,
                            color: currentMenu['isLoved']
                                ? Colors.red
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
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
                  onPressed: () async {
                    await _updateMenuCount(documentSnapshot, -1);

                    bool isAlreadySelected = selectedMenus
                        .any((menu) => menu.id == documentSnapshot.id);

                    setState(() {
                      if (isAlreadySelected) {
                        // If available, remove from the list
                        selectedMenus.removeWhere(
                            (menu) => menu.id == documentSnapshot.id);
                      } else {
                        // If not available, add to the list
                        selectedMenus.add(documentSnapshot);
                      }

                      // Update the item count
                      if (currentMenu != null) {
                        currentMenu['itemCount'] =
                            (currentMenu['itemCount'] as int) - 1;
                        if (currentMenu['itemCount'] < 0) {
                          currentMenu['itemCount'] = 0;
                        }
                      }

                      // Calculate total item count after updating individual item count
                      int totalItemCount = calculateTotalItemCount();

                      // Update the state with the new total item count
                      itemCount = totalItemCount;
                    });
                  },
                  icon: Icon(Icons.remove),
                  color: Color.fromARGB(248, 212, 81, 0),
                ),
                currentMenu != null && currentMenu['itemCount'] > 0
                    ? Text(
                        currentMenu['itemCount'].toString(),
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(248, 212, 81, 0),
                        ),
                      )
                    : Container(),
                IconButton(
                  onPressed: () async {
                    await _updateMenuCount(documentSnapshot, 1);
                    bool isAlreadySelected = selectedMenus
                        .any((menu) => menu.id == documentSnapshot.id);

                    setState(() {
                      if (isAlreadySelected) {
                        // If available, remove from the list
                        //STILL ERROR HERE!
                        selectedMenus.removeWhere(
                            (menu) => menu.id == documentSnapshot.id);
                      } else {
                        // If not available, add to the list
                        selectedMenus.add(documentSnapshot);
                      }

                      // Update the item count
                      if (currentMenu != null) {
                        currentMenu['itemCount'] =
                            (currentMenu['itemCount'] as int) + 1;
                      }

                      // Calculate total item count after updating individual item count
                      int totalItemCount = calculateTotalItemCount();

                      // Update the state with the new total item count
                      itemCount = totalItemCount;
                    });
                  },
                  icon: Icon(Icons.add),
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
