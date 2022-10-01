import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:ikinciel/utils/custom_button.dart';
import 'package:ikinciel/utils/custom_textfield.dart';
import 'package:ikinciel/utils/utils.dart';
import 'package:image_picker/image_picker.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({Key? key}) : super(key: key);

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final TextEditingController carModelController = TextEditingController();
  final TextEditingController carNameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController yearController = TextEditingController();
  final TextEditingController kmController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController colorController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  static const appBarGradient = LinearGradient(
    colors: [
      Color.fromARGB(255, 29, 201, 192),
      Color.fromARGB(255, 125, 221, 216),
    ],
    stops: [0.5, 1.0],
  );

  final _addProductFormKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    carModelController.dispose();
    carNameController.dispose();
    priceController.dispose();
    categoryController.dispose();
    kmController.dispose();
    yearController.dispose();
    contactController.dispose();
    colorController.dispose();
  }

  showColorDialog(textcontroller) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: StreamBuilder(
                stream:
                    FirebaseFirestore.instance.collection("color").snapshots(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (context, index) {
                          var snap = snapshot.data!.docs[index];
                          return ListTile(
                            onTap: () {
                              setState(() {
                                textcontroller.text = snap['title'];
                              });
                              Navigator.pop(context);
                            },
                            title: Text(snap['title']),
                          );
                        });
                  }
                  return const Center(
                    child: Text("hata burada"),
                  );
                }),
          );
        });
  }

  showFormDialog(textcontroller) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("category")
                    .snapshots(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (context, index) {
                          var snap = snapshot.data!.docs[index];
                          return ListTile(
                            onTap: () {
                              setState(() {
                                textcontroller.text = snap['title'];
                              });
                              Navigator.pop(context);
                            },
                            title: Text(snap['title']),
                          );
                        });
                  }
                  return const Center(
                    child: Text("hata burada"),
                  );
                }),
          );
        });
  }

  File? image;

  final imagePicker = ImagePicker();

  Future imagePickerMethod() async {
    final pick = await imagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pick != null) {
        image = File(pick.path);
      } else {
        Center(
          child: Text("hata top"),
        );
      }
    });
  }

  Future uploadImage() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final postID = DateTime.now().millisecondsSinceEpoch.toString();

    Reference ref =
        FirebaseStorage.instance.ref().child("cars").child(uid).child(postID);
    await ref.putFile(image!);
    final downloadURL = await ref.getDownloadURL();
    return downloadURL;
  }

  void sellProduct() async {
    if (_addProductFormKey.currentState!.validate()) {
      final user = await FirebaseAuth.instance.currentUser!.uid;

      final imageUpload = await uploadImage();

      await FirebaseFirestore.instance.collection("cars").add({
        'salerid': user,
        'carmodel': carModelController.text.trim(),
        'carname': carNameController.text.trim(),
        'price': double.parse(priceController.text.trim()),
        'year': double.parse(yearController.text.trim()),
        'kilometer': double.parse(kmController.text.trim()),
        'contact': double.parse(contactController.text.trim()),
        'category': categoryController.text.trim(),
        'description': descriptionController.text.trim(),
        'images': imageUpload,
        'color': colorController.text.trim(),
      });
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  /* void selectImages() async {
    var res = await pickImages();
    setState(() {
      images = res;
    });
  } */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Form(
            key: _addProductFormKey,
            child: Column(
              children: [
                GestureDetector(
                  onTap: imagePickerMethod,
                  child: DottedBorder(
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(10),
                    dashPattern: const [10, 4],
                    strokeCap: StrokeCap.round,
                    child: Container(
                      width: double.infinity,
                      height: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.folder_open,
                            size: 40,
                          ),
                          const SizedBox(height: 15),
                          Text(
                            'Select Product Images',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey.shade400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                CustomTextField(
                  controller: carModelController,
                  hintText: 'Product Name',
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: carNameController,
                  hintText: 'Car name',
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  maxLines: 7,
                  controller: descriptionController,
                  hintText: 'Car name',
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: priceController,
                  hintText: 'Price',
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: kmController,
                  hintText: 'Kilometer',
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: yearController,
                  hintText: 'Year',
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: contactController,
                  hintText: 'Contact Number',
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          showFormDialog(categoryController);
                        },
                        child: TextFormField(
                          controller: categoryController,
                          enabled: false,
                          decoration: InputDecoration(
                            labelText: 'Category',
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          showColorDialog(colorController);
                        },
                        child: TextFormField(
                          controller: colorController,
                          enabled: false,
                          decoration: InputDecoration(
                            labelText: 'Color',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                CustomButton(
                  text: 'Sell',
                  onTap: sellProduct,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      leading: BackButton(),
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 0,
      title: const Text(
        "Add Car",
        style: TextStyle(fontSize: 18, color: Colors.black),
      ),
      centerTitle: true,
    );
  }
}
