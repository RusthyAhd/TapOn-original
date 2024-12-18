import 'package:flutter/material.dart';
import 'package:tap_on/User_Home/EnterNumber.dart';
import 'dart:ui';
import 'package:url_launcher/url_launcher.dart';

class LaunchPage extends StatelessWidget {
  const LaunchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.amber[700],
        body:Stack(
          children: [
            // Background Image
            Positioned.fill(
              child: Image.asset(
                'assets/images/background4.webp', // Background image
                fit: BoxFit.cover, // Ensures the image covers the screen
              ),
            ),
        Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4), // Blur intensity
                child: Container(
                  color: Colors.black.withOpacity(0.2), // Optional: Dark overlay
                ),
              ),
            ),
         Padding(
           padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Circle Avatar with image
                CircleAvatar(
                  radius: 180,
                  backgroundColor: const Color.fromARGB(255, 252, 251, 250),
                  child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  color: const Color.fromARGB(255, 248, 236, 195),
                    boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: Offset(0, 5), // changes position of shadow
                    ),
                    ],
                  ),
                  child: Image.asset(
                    'assets/images/logo.png',
                    fit: BoxFit.contain,
                  ),
                  ),

                ),
                const SizedBox(height: 40),
                const Text(
                  'Discover new interests.',
                   style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                   color: const Color.fromARGB(255, 248, 236, 195),
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                    'Empower your team with our application',
                    style: TextStyle(
                      fontSize: 16,
                      color: const Color.fromARGB(255, 248, 236, 195),
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => EnterNumber()));
                  },
                   style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.yellow, // Button color
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    
                  ),
                  child: const Text(
                    'GET STARTED',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.yellow,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                       launch('https://sites.google.com/view/tapon-privacypolicy/home');
                      },
                      child: const Text(
                        'Terms of Service',
                        style: TextStyle(
                          fontSize: 14,
                          color: const Color.fromARGB(255, 248, 236, 195),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    const Text(
                      '|',
                      style: TextStyle(color: Colors.black54),
                    ),
                    TextButton(
                        onPressed: () {
                        launch('https://sites.google.com/view/tapon-privacypolicy/home');
                        },
                      child: const Text(
                        'Privacy Policy',
                        style: TextStyle(
                          fontSize: 14,
                        color: const Color.fromARGB(255, 248, 236, 195),
                          decoration: TextDecoration.underline,
                        ),
                  
                      ),
                    ),
                  ],
                )
              ],
            ),
          
          ),
        ),
          ],
        ),
      ),
    );
  }
}
