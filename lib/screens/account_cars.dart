import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:ikinciel/screens/car_detail_screen.dart';
import 'package:ikinciel/utils/single_product.dart';

class AccountCars extends StatefulWidget {
  const AccountCars({super.key});

  @override
  State<AccountCars> createState() => _AccountCarsState();
}

class _AccountCarsState extends State<AccountCars> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text("Account"),
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
                      .where('salerid', isEqualTo: user)
                      .snapshots(),
                  builder: ((context, snapshot) {
                    if (snapshot.hasData) {
                      return GridView.builder(
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
                                                        images:
                                                            carData["images"],
                                                        kilometer: carData[
                                                            "kilometer"],
                                                        price: carData["price"],
                                                        year: carData["year"],
                                                        color: carData["color"],
                                                        description: carData[
                                                            "description"],
                                                        salerid: carData[
                                                            "salerid"])));
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
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          carData.reference.delete();
                                        },
                                        icon: Icon(Icons.delete)),
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
          ],
        ),
      ),
    );
  }
}
