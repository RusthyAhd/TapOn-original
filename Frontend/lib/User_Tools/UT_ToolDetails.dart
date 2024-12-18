import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:tap_on/User_Tools/UT_ToolRequest.dart';
// Replace with actual import for UT_ToolRequest
import 'package:url_launcher/url_launcher.dart';

class ToolDetails extends StatelessWidget {
  final String title;
  final String image;
  final String price;
  final String description;
  final String shopPhone;
  final String shopEmail;
  final dynamic product; // Adjust type if product has a specific class type

  const ToolDetails({super.key, 
    required this.title,
    required this.image,
    required this.price,
    required this.description,
    required this.shopPhone,
    required this.shopEmail,
    required this.product,
  });

  bool isBase64(String str) {
    try {
      base64Decode(str);
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: TextStyle(fontSize: screenWidth * 0.05, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.orangeAccent,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orangeAccent, Colors.yellow[700]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Hero(
                    tag: title,
                    child: Image(
                      image: isBase64(image) ? MemoryImage(base64Decode(image)) : AssetImage('assets/placeholder.png') as ImageProvider,
                      height: screenWidth * 0.6,
                      width: screenWidth * 0.6,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                SizedBox(
                  width: screenWidth,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),                
                  ),
                  
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: screenWidth * 0.06,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          price,
                          style: TextStyle(
                            fontSize: screenWidth * 0.05,
                            color: Colors.green,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          description,
                          style: TextStyle(
                            fontSize: screenWidth * 0.04,
                            color: Colors.black54,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                ),
                SizedBox(height: 16),
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UT_ToolRequest(
                              product: product,
                              shopEmail: shopEmail,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.yellow,
                        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1, vertical: 15),
                        textStyle: TextStyle(fontSize: screenWidth * 0.04, color: Colors.white),
                      ),
                      child: Text('Request'),
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              launchUrl(Uri.parse('tel:$shopPhone'));
                            },
                            icon: Icon(Icons.phone, color: Colors.black),
                            label: Text('Call', style: TextStyle(color: Colors.black)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.amber,
                              side: BorderSide(color: Colors.black),
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              launchUrl(Uri.parse('sms:$shopPhone'));
                            },
                            icon: Icon(Icons.message, color: Colors.black),
                            label: Text('Message', style: TextStyle(color: Colors.black)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.amber,
                              side: BorderSide(color: Colors.black),
                            ),
                          ),
                          
                        ),
                         
                      ],
                    ),
                    SizedBox(height: 300),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}