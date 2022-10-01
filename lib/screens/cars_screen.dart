import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:ikinciel/screens/car_detail_screen.dart';
import 'package:ikinciel/utils/single_product.dart';

class CarsScreen extends StatefulWidget {
  CarsScreen({super.key, required this.title});

  String title;

  @override
  State<CarsScreen> createState() => _CarsScreenState();
}

class _CarsScreenState extends State<CarsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text("Car List"),
        centerTitle: true,
        leading: BackButton(),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            SingleChildScrollView(
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("cars")
                      .where('category', isEqualTo: widget.title)
                      .snapshots(),
                  builder: (context, snapshot) {
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
                                                      carname:
                                                          carData["carname"],
                                                      category:
                                                          carData["category"],
                                                      images: carData["images"],
                                                      kilometer:
                                                          carData["kilometer"],
                                                      price: carData["price"],
                                                      year: carData["year"],
                                                      color: carData["color"],
                                                      description: carData[
                                                          "description"],
                                                      salerid:
                                                          carData["salerid"],
                                                    )));
                                      },
                                      child: SingleProduct(
                                          image: carData['images'])),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Expanded(
                                      child: Center(
                                        child: Text(
                                          carData['carname'],
                                          style: TextStyle(
                                              fontSize: 17,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        '${carData["price"].toString()} TL',
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          });
                    }
                    return Center(
                      child: Text("veri gelmiyor"),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
