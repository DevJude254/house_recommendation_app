import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:unistay/pages/recommendation_page.dart';

import '../model/recommendation_model.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController rentController = TextEditingController();
  final TextEditingController distanceController = TextEditingController();
  String? selectedRoomType;
  final List<String> roomTypes = ['bedsitter', 'single'];
  final RecommendationModel recommendationModel = RecommendationModel();

  void _handleRecommendation() async {
    // Validate inputs
    if (rentController.text.isEmpty || distanceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter both rent budget and distance',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.black,
        ),
      );
      return;
    }

    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      // Get recommendations
      final recommendations = await recommendationModel.getRecommendations(
        maxRent: rentController.text,
        maxDistance: distanceController.text,
        roomType: selectedRoomType,
      );

      // Close loading indicator
      Navigator.of(context).pop();

      // Navigate to results page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RecommendationPage(
            recommendations: recommendations,
          ),
        ),
      );
    } catch (e) {
      // Close loading indicator if still open
      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}',style: TextStyle(color: Colors.white),),
          backgroundColor: Colors.black,
        ),
      );
    }
  }

  // Greeting function
  String _getGreeting() {
    int hour = DateTime.now().hour;

    if(hour<12){
      return 'Hola! Good Morning 🌄';
    } else if(hour<17){
      return 'Hola! Good Afternoon 🕑';
    } else{
      return 'Hola! Good Evening 🌆';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          "Find Student Housing",
          style: TextStyle(color: Colors.blue),
        ),
      ),
      drawer: Drawer(
        backgroundColor: Colors.black26,
        child: Column(
          children: [
            DrawerHeader(child: Icon(Icons.house,size: 100,color: Colors.grey.shade500)),
            ListTile(
              leading: Icon(Icons.home,color: Colors.grey.shade300,),
              title: Text("H O M E", style: TextStyle(color: Colors.grey[500]),),
              onTap: ()=>Navigator.pop(context),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(40, 1.9 * kToolbarHeight, 40, 20),
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

            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Welcome text
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getGreeting(),
                        style: TextStyle(
                            color: Colors.grey[400],
                            fontWeight: FontWeight.w400,
                            fontSize: 20),
                      ),

                    ],
                  ),

                  const SizedBox(height: 50,),
                  // Rent Budget Input
                  Text(
                    "Rent Budget (KSH)",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  SizedBox(height: 8), // Space between label and TextField
                  TextField(
                    controller: rentController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Enter amount",
                      labelStyle: TextStyle(color: Colors.grey.shade300),
                      filled: true,
                      fillColor: Colors.white10,
                      // Light background for contrast
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.blue, width: 1.5),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(color: Colors.blue, width: 2.0),
                      ),
                    ),
                    style: TextStyle(color: Colors.white),
                  ),

                  SizedBox(height: 20), // Space between fields

                  // Max Distance Input
                  Text(
                    "Max Distance (KM)",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  TextField(
                    controller: distanceController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Enter distance",
                      labelStyle: TextStyle(color: Colors.grey.shade300),
                      filled: true,
                      fillColor: Colors.white10,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.blue, width: 1.5),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(color: Colors.blue, width: 2.0),
                      ),
                    ),
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 20), // Space between fields

                  // Max Distance Input
                  Text(
                    "Room Type",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  SizedBox(height: 8),

                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Room Type',
                      labelStyle: TextStyle(color: Colors.grey.shade300),
                      filled: true,
                      fillColor: Colors.white10,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.blue, width: 1.5),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(color: Colors.blue, width: 2.0),
                      ),
                    ),
                    value: selectedRoomType,
                    dropdownColor: Colors.black,
                    // Match background color
                    style: TextStyle(color: Colors.white),
                    // Match text color
                    items: roomTypes.map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(type,
                            style: TextStyle(
                                color: Colors.white)), // Match text style
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedRoomType = value;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 80,
                  ),
                  Center(
                    child: GestureDetector(
                      onTap: _handleRecommendation,
                      child: Container(
                        height: 70,
                        width: MediaQuery.of(context).size.width / 2,
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(14)),
                        child: Center(
                          child: Text(
                            "Recommend",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
