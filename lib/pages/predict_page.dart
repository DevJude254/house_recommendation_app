import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:unistay/model/prediction_model.dart';
import 'package:unistay/pages/predictions_page.dart';
import 'package:unistay/services/api_service.dart';


class PredictPage extends StatefulWidget {
  const PredictPage({super.key});

  @override
  State<PredictPage> createState() => _PredictPage();
}

class _PredictPage extends State<PredictPage> {
  final TextEditingController distanceController = TextEditingController();
  String? selectedRoomType;
  int? selectedSecurityScore;
  int? selectedInfrastructureScore;
  int? selectedWaterScore;
  int? selectedInternetAvailability;
  final List<String> roomTypes = ['bedsitter', 'single'];
  final List<int> securityScore = [1,2,3,4,5,6,7,8,9,10];
  final List<int> infrastructureScore = [1,2,3,4,5,6,7,8,9,10];
  final List<int> waterScore = [1,2,3,4,5];
  final List<int> internetScore = [1,2,3,4,5];
  bool isLoading = false;

  void _handlePredictions() async {
    // Validate inputs
    if (selectedRoomType == null ||
        distanceController.text.isEmpty ||
        selectedSecurityScore == null ||
        selectedInfrastructureScore == null ||
        selectedWaterScore == null ||
        selectedInternetAvailability == null) {
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
      RentPredictionRequest request = RentPredictionRequest(
        roomType: selectedRoomType!,
        distanceFromCampusKm: double.parse(distanceController.text),
        securityScore: selectedSecurityScore!,
        infrastructureScore: selectedInfrastructureScore!,
        waterElectricityReliability: selectedWaterScore!,
        internetAvailability: selectedInternetAvailability!,
      );


      // Get recommendations
      final result = await ApiService.predictRentAndRecommend(request);

      // Parse response
      final predictedRent = result['predicted_rent_price'];
      final recommendationsRaw = result['top_5_locations'] as List;

      // Map and enrich with rent prediction (optional)
      final recommendations = recommendationsRaw.map<Map<String, dynamic>>((rec) {
        return {
          'location': rec['location'],
          'rent_price': rec['rent_price'],
          'distance_from_campus_km': rec['distance_from_campus_km'],
        };
      }).toList();

      // Close loading indicator
      Navigator.of(context).pop();

      // Navigate to results page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PredictionsPage(
            predictedRentPrice: predictedRent,
            topLocations: recommendations
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

    if (hour < 12) {
      return 'Hola! Good Morning 🌄';
    } else if (hour < 17) {
      return 'Hola! Good Afternoon 🕑';
    } else {
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
          "Rent Price Prediction",
          style: TextStyle(color: Colors.blue),
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

                  const SizedBox(
                    height: 50,
                  ),
                  // Rent Budget Input
                  Text(
                    "Room Type",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  SizedBox(height: 8), // Space between label and TextField
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

                  Text(
                    "Security Score",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  SizedBox(height: 8,),
                  DropdownButtonFormField<int>(
                      decoration: InputDecoration(
                        labelText: 'Security Score',
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
                    value: selectedSecurityScore,
                    dropdownColor: Colors.black,
                    // Match background color
                    style: TextStyle(color: Colors.white),
                    // Match text color
                    items: securityScore.map((int type) {
                      return DropdownMenuItem<int>(
                        value: type,
                        child: Text(
                          type.toString(),
                          style: TextStyle(color: Colors.white),
                        )// Match text style
                      );
                    }).toList(),
                    onChanged: (int? value) {
                      setState(() {
                        selectedSecurityScore = value;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Infrastructure Score",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  SizedBox(height: 8,),
                  DropdownButtonFormField<int>(
                    decoration: InputDecoration(
                      labelText: 'Infrastructure Score',
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
                    value: selectedInfrastructureScore,
                    dropdownColor: Colors.black,
                    // Match background color
                    style: TextStyle(color: Colors.white),
                    // Match text color
                    items: infrastructureScore.map((int type) {
                      return DropdownMenuItem<int>(
                          value: type,
                          child: Text(
                            type.toString(),
                            style: TextStyle(color: Colors.white),
                          )// Match text style
                      );
                    }).toList(),
                    onChanged: (int? value) {
                      setState(() {
                        selectedInfrastructureScore = value;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Water/Electricity reliability",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  SizedBox(height: 8,),
                  DropdownButtonFormField<int>(
                    decoration: InputDecoration(
                      labelText: "Score",
                      labelStyle: TextStyle(color: Colors.grey.shade500),
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
                    value: selectedWaterScore,
                    dropdownColor: Colors.black,
                    // Match background color
                    style: TextStyle(color: Colors.white),
                    // Match text color
                    items: waterScore.map((int type) {
                      return DropdownMenuItem<int>(
                          value: type,
                          child: Text(
                            type.toString(),
                            style: TextStyle(color: Colors.white),
                          )// Match text style
                      );
                    }).toList(),
                    onChanged: (int? value) {
                      setState(() {
                        selectedWaterScore = value;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Internet Availability",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  SizedBox(height: 8,),
                  DropdownButtonFormField<int>(
                    decoration: InputDecoration(
                      labelText: "Score",
                      labelStyle: TextStyle(color: Colors.grey.shade500),
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
                    value: selectedInternetAvailability,
                    dropdownColor: Colors.black,
                    // Match background color
                    style: TextStyle(color: Colors.white),
                    // Match text color
                    items: internetScore.map((int type) {
                      return DropdownMenuItem<int>(
                          value: type,
                          child: Text(
                            type.toString(),
                            style: TextStyle(color: Colors.white),
                          )// Match text style
                      );
                    }).toList(),
                    onChanged: (int? value) {
                      setState(() {
                        selectedInternetAvailability = value;
                      });
                    },
                  ),


                  const SizedBox(
                    height: 80,
                  ),
                  Center(
                    child: GestureDetector(
                      onTap: _handlePredictions,
                      child: Container(
                        height: 70,
                        width: MediaQuery.of(context).size.width / 2,
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(14)),
                        child: Center(
                          child: Text(
                            "Predict",
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
