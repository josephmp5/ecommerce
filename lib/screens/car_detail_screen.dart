import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ikinciel/screens/chat_screen.dart';

class carDetailScreen extends StatefulWidget {
  carDetailScreen({
    super.key,
    required this.carmodel,
    required this.carname,
    required this.category,
    required this.images,
    required this.kilometer,
    required this.price,
    required this.year,
    required this.color,
    required this.description,
    required this.salerid,
  });

  String images;
  String carname;
  String carmodel;
  double price;
  double kilometer;
  String category;
  double year;
  String color;
  String description;
  String salerid;

  @override
  State<carDetailScreen> createState() => _carDetailScreenState();
}

class _carDetailScreenState extends State<carDetailScreen> {
  final auth = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(widget.carname),
        centerTitle: true,
        leading: BackButton(),
        backgroundColor: Colors.black.withOpacity(.5),
        elevation: 0,
      ),
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * .6,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(widget.images),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * .43,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.2),
                    offset: Offset(0, -4),
                    blurRadius: 0,
                  ),
                ],
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                physics: BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 20,
                        left: 24,
                        right: 20,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Center(
                              child: Text(
                                widget.carname,
                                style: GoogleFonts.ptSans(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                          if (auth != widget.salerid)
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ChatScreen(
                                              userId: widget.salerid,
                                              name: widget.carname,
                                            )));
                              },
                              child: Icon(Icons.message_outlined),
                            ),
                          // buradan satıcıya mesja atmaya gidilecek message screen e
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 20,
                        left: 30,
                        right: 30,
                      ),
                      child: Row(
                        children: [
                          Text(
                            " Category: ",
                            style: GoogleFonts.ptSans(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            widget.category,
                            style: GoogleFonts.ptSans(
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 20,
                        left: 30,
                        right: 30,
                      ),
                      child: Row(
                        children: [
                          Text(
                            " Car Model: ",
                            style: GoogleFonts.ptSans(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            widget.carmodel,
                            style: GoogleFonts.ptSans(
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 20,
                        left: 30,
                        right: 30,
                      ),
                      child: Row(
                        children: [
                          Text(
                            " Kilometer: ",
                            style: GoogleFonts.ptSans(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            widget.kilometer.toString(),
                            style: GoogleFonts.ptSans(
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 20,
                        left: 30,
                        right: 30,
                      ),
                      child: Row(
                        children: [
                          Text(
                            " Price: ",
                            style: GoogleFonts.ptSans(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "${widget.price.toString()} TL",
                            style: GoogleFonts.ptSans(
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 20,
                        left: 30,
                        right: 30,
                      ),
                      child: Row(
                        children: [
                          Text(
                            " Year: ",
                            style: GoogleFonts.ptSans(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            widget.year.toString(),
                            style: GoogleFonts.ptSans(
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 20,
                        left: 30,
                        right: 30,
                      ),
                      child: Row(
                        children: [
                          Text(
                            " Color: ",
                            style: GoogleFonts.ptSans(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            widget.color,
                            style: GoogleFonts.ptSans(
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 20,
                        left: 30,
                        right: 30,
                      ),
                      child: Row(
                        children: [
                          Text(
                            " Description: ",
                            style: GoogleFonts.ptSans(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Text(
                                widget.description,
                                style: GoogleFonts.ptSans(
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
