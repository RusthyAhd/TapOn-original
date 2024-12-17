import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tap_on/Service_Provider/SP_Dashboard.dart';
import 'package:tap_on/Service_Provider/SP_Login.dart';
import 'package:tap_on/Tool_Provider/TP_Dashboard.dart';
import 'package:tap_on/Tool_Provider/TP_Login.dart';
import 'package:tap_on/User_Home/Chatbot.dart';
import 'package:tap_on/User_Home/EnterNumber.dart';
import 'package:tap_on/User_Home/UH_Notification.dart';
import 'package:tap_on/User_Home/UH_Profile.dart';
import 'package:tap_on/User_Service/US_Location.dart';
import 'package:tap_on/User_Tools/UT_Location.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TapOn', style: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 22,
    ),),
        backgroundColor: Colors.amber[700],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const EnterNumber()));
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const UH_Notification()));
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
                    ListTile(
            leading: IconButton(
              icon: const CircleAvatar(
                child: Icon(Icons.person,size: 30),
                  backgroundColor: Color.fromARGB(255, 243, 177, 33),
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => UH_Profile()));
              },
            ),
            title: const Text(
              "Profile",
              style: TextStyle(
                fontSize: 14.0, // Adjust font size to your preference
                fontWeight: FontWeight
                    .bold, // Change to FontWeight.normal for regular weight
                color: Color.fromARGB(255, 3, 23, 39), // Set the text color to match your theme
                letterSpacing: 1.2,
              ),
              textAlign:TextAlign.left
            ),
            trailing: IconButton(
              icon: const Icon(Icons.support_agent),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Chatbot()),
                );
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            child: Text(
              'Choose Your Service',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 245, 236, 137), // Starting color
                    Color.fromARGB(255, 230, 170, 42), // Ending color (adjust as needed)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: GridView.count(
                crossAxisCount: 3,
                padding: const EdgeInsets.all(10.0),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  ServiceCard(
                    label: 'Plumber',
                    imagePath: 'assets/images/Plumber.jpg',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                US_Location(category: 'Plumber')),
                      );
                    },
                  ),
                  ServiceCard(
                    label: 'Electrician',
                    imagePath: 'assets/images/electrician.jpeg',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                US_Location(category: 'Electrician')),
                      );
                    },
                  ),
                  ServiceCard(
                    label: 'Carpenter',
                    imagePath: 'assets/images/carpenter.jpg',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                US_Location(category: 'Carpenter')),
                      );
                    },
                  ),
                  ServiceCard(
                    label: 'Painter',
                    imagePath: 'assets/images/painter.jpg',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                US_Location(category: 'Painter')),
                      );
                    },
                  ),
                  ServiceCard(
                    label: 'Gardener',
                    imagePath: 'assets/images/gardener.jpg',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                US_Location(category: 'Gardener')),
                      );
                    },
                  ),
                  ServiceCard(
                    label: 'Fridge Repair',
                    imagePath: 'assets/images/repairer.jpg',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                US_Location(category: 'Fridge Repair')),
                      );
                    },
                  ),
                  ServiceCard(
                    label: 'Beauty Professional',
                    imagePath: 'assets/images/beautician.jpg',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                US_Location(category: 'Beauty Professional')),
                      );
                    },
                  ),
                  ServiceCard(
                    label: 'Phone Repair',
                    imagePath: 'assets/images/repairer.jpg',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                US_Location(category: 'Phone Repair')),
                      );
                    },
                  ),
                  ServiceCard(
                    label: 'Other',
                    imagePath: 'assets/images/other.jpg',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                US_Location(category: 'Other')),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            child: Text(
              'Rent Tools',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 230, 170, 42), // Starting color
                     Color.fromARGB(255, 231, 196, 121), // Ending color (adjust as needed)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: GridView.count(
                crossAxisCount: 3,
                padding: const EdgeInsets.all(10.0),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  ServiceCard(
                    label: 'Plumbing Tools',
                    imagePath: 'assets/images/plumbingt.jpg',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                UT_Location(tool: 'Plumbing Tools')),
                      );
                    },
                  ),
                  ServiceCard(
                    label: 'Electrical Tools',
                    imagePath: 'assets/images/electrotool.png',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                UT_Location(tool: 'Electrical Tools')),
                      );
                    },
                  ),
                  ServiceCard(
                    label: 'Carpenting Tools',
                    imagePath: 'assets/images/carpenter.png',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                UT_Location(tool: 'Carpenting Tools')),
                      );
                    },
                  ),
                  ServiceCard(
                    label: 'Painting Tools',
                    imagePath: 'assets/images/painttool.jpg',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                UT_Location(tool: 'Painting Tools')),
                      );
                    },
                  ),
                  ServiceCard(
                    label: 'Gardening Tools',
                    imagePath: 'assets/images/gardeningt.jpg',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                UT_Location(tool: 'Gardening Tools')),
                      );
                    },
                  ),
                  ServiceCard(
                    label: 'Repairing Tools',
                    imagePath: 'assets/images/repairt.jpg',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                UT_Location(tool: 'Repairing Tools')),
                      );
                    },
                  ),
                  ServiceCard(
                    label: 'Building Tools',
                    imagePath: 'assets/images/othertool.webp',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                UT_Location(tool: 'Building Tools')),
                      );
                    },
                  ),
                  ServiceCard(
                    label: 'Phone Accessories',
                    imagePath: 'assets/images/phonet.jpg',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                UT_Location(tool: 'Phone Accessories')),
                      );
                    },
                  ),
                  ServiceCard(
                    label: 'Other',
                    imagePath: 'assets/images/beautyt.jpg',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UT_Location(tool: 'Other')),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton(
              onPressed: () {
                // Handle User button press
              },
              child: const Row(
                children: [
                  Icon(Icons.person),
                  SizedBox(width: 8),
                  Text('User'),
                ],
              ),
            ),
            TextButton(
              onPressed: () async {
                // Handle Shop Owner button press
                SharedPreferences prefs = await SharedPreferences.getInstance();
                final providerId = prefs.getString('toolProviderId');
                if (providerId == null || providerId == '') {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => TP_Login()));
                } else if (providerId != null || providerId != '') {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => TP_Dashboard()));
                }
              },
              child: const Row(
                children: [
                  Icon(Icons.store),
                  SizedBox(width: 8),
                  Text('Tool Provider'),
                ],
              ),
            ),
            TextButton(
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                final providerId = prefs.getString('serviceProviderId');
                if (providerId == null || providerId == '') {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SP_Login()));
                } else if (providerId != null || providerId != '') {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SP_Dashboard()));
                }

                // Handle Shop Owner button press
              },

              // Handle Provider button press

              child: const Row(
                children: [
                  Icon(Icons.engineering),
                  SizedBox(width: 8),
                  Text('Provider'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ServiceCard extends StatelessWidget {
  final String label;
  final String? imagePath;
  final String? imageUrl;
  final VoidCallback onTap;

  const ServiceCard({
    required this.label,
    required this.onTap,
    this.imagePath,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedScale(
        scale: 0.95, // Reduce scale on tap for a "click" effect
        duration: const Duration(milliseconds: 200),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: onTap,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: imagePath != null
                      ? AssetImage(imagePath!) as ImageProvider
                      : NetworkImage(imageUrl!),
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    stops: [0.1, 0.9],
                    colors: [
                      Colors.black.withOpacity(0.6),
                      Colors.transparent,
                    ],
                  ),
                ),
                alignment: Alignment.bottomCenter,
                padding: const EdgeInsets.all(10),
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
