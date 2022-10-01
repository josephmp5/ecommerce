import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ikinciel/screens/account_cars.dart';
import 'package:ikinciel/screens/account_screen.dart';
import 'package:ikinciel/screens/add_car_screen.dart';
import 'package:ikinciel/screens/car_detail_screen.dart';
import 'package:ikinciel/screens/messages_screen.dart';
import 'package:ikinciel/utils/single_product.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("IKINCIEL"),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AccountCars()));
            },
            icon: Icon(
              Icons.account_box_rounded,
            )),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MessagesScreen()));
              },
              icon: Icon(
                Icons.message_rounded,
              ))
        ],
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection("cars").snapshots(),
              builder: ((context, snapshot) {
                if (snapshot.hasData) {
                  return GridView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: snapshot.data!.docs.length,
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2),
                      itemBuilder: (context, index) {
                        final carData = snapshot.data!.docs[index];
                        return Column(
                          children: [
                            SizedBox(
                              height: 140,
                              child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                carDetailScreen(
                                                    carmodel:
                                                        carData["carmodel"],
                                                    carname: carData["carname"],
                                                    category:
                                                        carData["category"],
                                                    images: carData["images"],
                                                    kilometer:
                                                        carData["kilometer"],
                                                    price: carData["price"],
                                                    year: carData["year"],
                                                    color: carData["color"],
                                                    description:
                                                        carData["description"],
                                                    salerid:
                                                        carData["salerid"])));
                                  },
                                  child:
                                      SingleProduct(image: carData['images'])),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  child: Center(
                                    child: Text(
                                      carData['carname'],
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 17),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      });
                }
                return Center(
                  child: Text("no data"),
                );
              })),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => AddProductScreen()));
        },
        tooltip: 'Add a Product',
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
