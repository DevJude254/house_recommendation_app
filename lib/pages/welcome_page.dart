import 'package:flutter/material.dart';
import 'package:unistay/pages/home.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[700],
      body: Column(
        children: [
          // Image
          Container(
            child: Column(
              children: [
                Material(
                  elevation: 1.0,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(30)),
                  child: Image.asset(
                    "assets/welcome.png",
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 1.5,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 30,),
                Text("MUST", style: TextStyle(color:Colors.green, fontSize: 30, fontWeight: FontWeight.bold ),),
                Text(
                  "House Recommendation 🏡",
                  style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 25,
                      fontWeight: FontWeight.w300
                  ),
                ),
                const SizedBox(
                  height: 70,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Home(),
                            fullscreenDialog: true));
                  },
                  child: Container(
                    height: 70,
                    width: 300,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(20)),
                    child: Center(
                      child: Text(
                        "Get Started",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
          // Container for get started
        ],
      ),
    );
  }
}
