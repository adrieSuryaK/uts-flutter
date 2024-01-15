import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShoppingCartPage extends StatelessWidget {
  final List<DocumentSnapshot> selectedMenus;
  final int itemCount;

  const ShoppingCartPage({
    required this.selectedMenus,
    required this.itemCount,
  });

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
      body: FutureBuilder<SharedPreferences>(
        future: SharedPreferences.getInstance(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final SharedPreferences prefs = snapshot.data!;

            // Calculate total cost
            double totalCost = 0.0;

            return Container(
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
                      'Selected Menus:',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: selectedMenus.length,
                      itemBuilder: (context, index) {
                        final documentSnapshot = selectedMenus[index];
                        final String menuId = documentSnapshot.id;

                        // Get menu count from SharedPreferences
                        List<Map<String, dynamic>> menuData =
                            List<Map<String, dynamic>>.from(
                          prefs
                                  .getStringList('selectedMenus')
                                  ?.map((e) => json.decode(e)) ??
                              [],
                        );

                        int menuCount = menuData.firstWhere(
                          (menu) => menu['id'] == menuId,
                          orElse: () => {'itemCount': 0},
                        )['itemCount'];

                        // Calculate total cost for each menu
                        num menuTotalCost =
                            menuCount * documentSnapshot['cost'];

                        // Add menu total cost to overall total cost
                        totalCost += menuTotalCost;

                        // Wrap the ListTile
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white38,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          padding: EdgeInsets.all(8.0),
                          margin: EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16.0),
                          child: ListTile(
                            title: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.network(
                                    documentSnapshot['image'],
                                    width: 50.0,
                                    height: 50.0,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(width: 10.0),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(documentSnapshot['name']),
                                    Text(
                                      'Rp. ${documentSnapshot['cost'].toString()}',
                                    ),
                                    Text(
                                      'Quantity: $menuCount',
                                    ),
                                    Text(
                                      'Total: Rp. ${menuTotalCost.toString()}',
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
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
                        Text(
                          'Total Items: $itemCount',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 16.0),
                        Text(
                          'Total Cost: Rp. ${totalCost.toString()}',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 16.0),
                        ElevatedButton(
                          onPressed: () {
                            // Handle checkout action
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
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 40),
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
                              EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 40),
                            ),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
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
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
