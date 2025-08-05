import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:unistay/pages/home.dart';

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          "About",
          style: TextStyle(color: Colors.white),
        ),
      ),
      drawer: Drawer(
        backgroundColor: Colors.black26,
        child: Column(
          children: [
            DrawerHeader(child: Image.asset('assets/housing.jpg')),
            const SizedBox(
              height: 50,
            ),
            ListTile(
              leading: Icon(
                Icons.home,
                color: Colors.grey.shade300,
              ),
              title: Text(
                "H O M E",
                style: TextStyle(color: Colors.grey[500]),
              ),
              onTap: () => Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Home())),
            ),
            ListTile(
              leading: Icon(Icons.info, color: Colors.grey.shade500),
              title: Text("A B O U T",
                  style: TextStyle(color: Colors.grey.shade500)),
              onTap: () => Navigator.pop(context),
            )
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(20, 1.2 * kToolbarHeight, 20, 20),
        child: Stack(
          children: [
            // Background Circles
            Align(
              alignment: AlignmentDirectional(3, -0.3),
              child: Container(
                height: 300,
                width: 300,
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: Colors.blue),
              ),
            ),
            Align(
              alignment: AlignmentDirectional(-3, -0.3),
              child: Container(
                height: 300,
                width: 300,
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: Colors.blue),
              ),
            ),
            Align(
              alignment: AlignmentDirectional(0, -1.2),
              child: Container(
                height: 300,
                width: 600,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromARGB(255, 152, 198, 235),
                ),
              ),
            ),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 100.0, sigmaY: 100.0),
              child: Container(
                decoration: BoxDecoration(color: Colors.transparent),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    height: 200,
                    width: 200,
                    child: Image.asset('assets/icon.png')),
                Text(
                  "🏡 Unistay",
                  style: TextStyle(
                      color: Colors.green,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  "Unistay is a smart housing app built to help campus students discover affordable, safe, and convenient off-campus accommodations tailored to their lifestyle. 📲",
                  style: TextStyle(
                      color: Colors.grey.shade300,
                      fontSize: 18,
                      fontWeight: FontWeight.w300),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "🎯 Our mission",
                  style: TextStyle(
                      color: Colors.green,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  "To simplify student housing by combining technology, smart recommendations, and real student needs into one easy-to-use platform.",
                  style: TextStyle(
                      color: Colors.grey.shade300,
                      fontSize: 18,
                      fontWeight: FontWeight.w300),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "⚙ Features:",
                  style: TextStyle(
                      color: Colors.green,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  "~ Rent prediction based on your preference & needs. \n~ Top 5 housing recommendations personalized for you.",
                  style: TextStyle(
                      color: Colors.grey.shade300,
                      fontSize: 18,
                      fontWeight: FontWeight.w300),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
