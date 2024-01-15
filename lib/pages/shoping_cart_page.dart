import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShoppingCartPage extends StatefulWidget {
  final List<DocumentSnapshot> selectedMenus;
  final int itemCount;

  const ShoppingCartPage({
    required this.selectedMenus,
    required this.itemCount,
  });

  @override
  _ShoppingCartPageState createState() => _ShoppingCartPageState();
}

class _ShoppingCartPageState extends State<ShoppingCartPage> {
  late double totalCost;

  @override
  void initState() {
    super.initState();
    calculateTotalCost();
  }

  Future<void> calculateTotalCost() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    double calculatedTotalCost = 0.0;
    for (var documentSnapshot in widget.selectedMenus) {
      final String menuId = documentSnapshot.id;

      List<Map<String, dynamic>> menuData = List<Map<String, dynamic>>.from(
        prefs.getStringList('selectedMenus')?.map((e) => json.decode(e)) ?? [],
      );

      int menuCount = await getMenuCount(menuId);

      double cost = documentSnapshot['cost'].toDouble();
      calculatedTotalCost += menuCount * cost;
    }

    setState(() {
      totalCost = calculatedTotalCost;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cart',
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
            tileMode: TileMode.mirror,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'SELECTED MENUS:',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: widget.selectedMenus.length,
                itemBuilder: (context, index) {
                  final documentSnapshot = widget.selectedMenus[index];
                  final String menuId = documentSnapshot.id;

                  return FutureBuilder<int>(
                    future: getMenuCount(menuId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        // Menampilkan indikator loading jika masih dalam proses fetching data
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        // Menampilkan pesan error jika terdapat kesalahan
                        return Text('Error: ${snapshot.error}');
                      } else {
                        int menuCount = snapshot.data ?? 0;
                        double cost = documentSnapshot['cost'].toDouble();

                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white38,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          padding: EdgeInsets.all(8.0),
                          margin: EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16.0),
                          child: Stack(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Image.network(
                                      documentSnapshot['image'],
                                      width: 60.0,
                                      height: 80.0,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  SizedBox(width: 10.0),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        documentSnapshot['name'],
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        'Rp. ${cost.toString()}',
                                        style: TextStyle(
                                          color:
                                              Color.fromARGB(248, 212, 81, 0),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        'Sub Total: Rp. ${(menuCount * cost).toStringAsFixed(2)}',
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Positioned(
                                top: 20.0,
                                right: 10.0,
                                child: Container(
                                  width: 40.0,
                                  height: 40.0,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color.fromARGB(248, 212, 81, 0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        spreadRadius: 2,
                                        blurRadius: 4,
                                        offset: Offset(2, 2),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Text(
                                      menuCount.toString(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  );
                },
              ),
            ),
            Container(
              color: Colors.white,
              width: double.infinity,
              padding: EdgeInsets.all(10.0),
              child: Column(
                children: [
                  // Text(
                  //   'Total Items: ${widget.itemCount}',
                  //   style: TextStyle(
                  //     fontSize: 18.0,
                  //     fontWeight: FontWeight.bold,
                  //   ),
                  // ),
                  SizedBox(height: 16.0),
                  Text(
                    'Total: Rp. ${(totalCost ?? 0.0).toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(248, 212, 81, 0),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, 'payPage');
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color.fromARGB(248, 137, 87, 33),
                            Color.fromARGB(248, 205, 161, 85),
                            Color.fromARGB(248, 218, 149, 30),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                      child: Text(
                        'Checkout',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all(0.0),
                      backgroundColor:
                          MaterialStateProperty.all(Colors.transparent),
                      overlayColor:
                          MaterialStateProperty.all(Colors.transparent),
                      padding: MaterialStateProperty.all(
                        EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
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

  Future<int> getMenuCount(String menuId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<Map<String, dynamic>> menuData = List<Map<String, dynamic>>.from(
      prefs.getStringList('selectedMenus')?.map((e) => json.decode(e)) ?? [],
    );

    return menuData.firstWhere(
      (menu) => menu['id'] == menuId,
      orElse: () => {'itemCount': 0},
    )['itemCount'];
  }

  Future<void> clearSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
