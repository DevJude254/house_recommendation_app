import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:unistay/pages/home.dart';

class RecommendationPage extends StatelessWidget {
  final List<Map<String, dynamic>> recommendations;

  const RecommendationPage({super.key, required this.recommendations});

  @override
  Widget build(BuildContext context) {
    final topRecommendations = recommendations.take(5).toList();

    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          "Recommended Houses",
          style: TextStyle(color: Colors.white),
        ),
        leading: GestureDetector(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> Home()));
          },
            child: Icon(Icons.arrow_back_ios)),
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
            Container(
              child: recommendations.isEmpty
                  ? const Center(
                      child: Text(
                          "No matching housing found.Try adjusting your criteria",
                          style: TextStyle(color: Colors.white, fontSize: 18)),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(10),
                      itemCount: topRecommendations.length,
                      itemBuilder: (context, index) {
                        final property = recommendations[index];
                        return Card(
                          color: Colors.grey[900],
                          margin: const EdgeInsets.only(bottom: 16),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  property['location'] ?? 'Unknown Location',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      _buildInfoChip(
                                        Icons.attach_money,
                                        '${property['rent_price']?.toStringAsFixed(0) ?? 'N/A'} KSH',
                                      ),
                                      const SizedBox(width: 8),
                                      _buildInfoChip(
                                        Icons.directions_walk,
                                        '${property['distance_from_campus_km']?.toStringAsFixed(1) ?? 'N/A'} km',
                                      ),
                                      const SizedBox(width: 8),
                                      _buildInfoChip(
                                        Icons.star,
                                        '${property['predicted_score']?.toStringAsFixed(2) ?? 'N/A'}',
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 12),
                                if (property['description'] != null)
                                  Text(
                                    property['description'],
                                    style: TextStyle(color: Colors.grey[400]),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            )
          ],
        ),
      ),
    );
  }
}

Widget _buildInfoChip(IconData icon, String text) {
  return Chip(
    backgroundColor: Colors.blue[300],
    label: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: Colors.blue),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(color: Colors.white)),
      ],
    ),
  );
}
