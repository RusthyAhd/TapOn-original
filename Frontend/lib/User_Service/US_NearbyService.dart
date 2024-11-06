import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tap_on/User_Service/US_Location.dart';
import 'package:tap_on/User_Service/US_ProviderDetails.dart';
import 'package:http/http.dart' as http;
import 'package:tap_on/services/geo_services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class US_NearbyService extends StatefulWidget {
  final String userLocation;
  final String category;
  const US_NearbyService({super.key, required this.userLocation, required this.category});

  @override
  State<US_NearbyService> createState() => _US_NearbyServiceState();
}

class _US_NearbyServiceState extends State<US_NearbyService> {
  double _latitude = 6.9271;
  double _longitude = 79.8612;
  late GoogleMapController mapController;
  final Set<Marker> _markers = {};
  final List<Map<String, dynamic>> serviceProviders = [];

  @override
  void initState() {
    super.initState();
    _initAsync();
  }

  void _initAsync() async {
    await getAllService();
  }

  Future<void> getAllService() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final baseURL = dotenv.env['BASE_URL'];
      final token = prefs.getString('token');

      final coordinates = await getCoordinatesFromCity(widget.userLocation);

      setState(() {
        _latitude = coordinates['latitude'] ?? 6.9271;
        _longitude = coordinates['longitude'] ?? 79.8612;
      });

      final response = await http.post(
        Uri.parse('$baseURL/service/get/all/cl'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': '$token',
        },
        body: jsonEncode({
          "location_long": coordinates['longitude'],
          "location_lat": coordinates['latitude'],
          'service_category': widget.category,
        }),
      );

      final data = jsonDecode(response.body);
      
      if (data['status'] == 200) {
        final services = data['data'];
        if (services.length > 0) {
          List<Map<String, dynamic>> newProviders = [];
          Set<Marker> providerMarkers = {};

          for (var service in services) {
            final lat = service['location_lat'];
            final long = service['location_long'];
            final serviceCity = await getCityFromCoordinates(lat, long);

            newProviders.add({
              'name': service['name'] ?? 'N/A',
              'district': serviceCity,
              'distance': 'N/A',
              'rating': service['rating'] ?? 0,
              'service': service['service'] ?? 'N/A',
              'consultantFee': service['price'] ?? 'N/A',
              'amountPerDay': service['price'] ?? 'N/A',
              'image': service['pic'] ?? 'N/A',
              "service_category": service['service_category'] ?? 'N/A',
              "availability": service['availability'] ?? 'N/A',
              "available_days": service['available_days'] ?? 'N/A',
              "available_hours": service['available_hours'] ?? 'N/A',
              "service_id": service['service_id'] ?? 'N/A',
              "description": service['description'] ?? 'N/A',
            });

            if (lat != null && long != null) {
              providerMarkers.add(
                Marker(
                  markerId: MarkerId(service['shop_name'] ?? 'N/A'),
                  position: LatLng(lat, long),
                  infoWindow: InfoWindow(title: service['shop_name'] ?? 'N/A'),
                ),
              );
            }
          }

          setState(() {
            serviceProviders.clear();
            serviceProviders.addAll(newProviders);
            _markers.clear();
            _markers.addAll(providerMarkers);
          });
        }
      }
    } catch (e) {
      print(e);
      QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      title: 'Location Error',
      text: 'Unable to fetch location. Using default coordinates.',
      backgroundColor: Colors.black,
      titleColor: Colors.white,
      textColor: Colors.white,
      );
    }
  }

  Widget _buildProviderInfo(String label, String value) {
    return RichText(
      text: TextSpan(
        text: '$label: ',
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: Colors.black,
        ),
        children: [
          TextSpan(
            text: value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: Color.fromARGB(255, 3, 112, 207),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.yellow[700],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => US_Location(category: widget.category)),
          ),
        ),
        title: const Text('Nearby Service Providers', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Container(
            height: 250,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                )
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(_latitude, _longitude),
                  zoom: 13,
                ),
                onMapCreated: (GoogleMapController controller) {
                  mapController = controller;
                },
                markers: _markers,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: serviceProviders.length,
              itemBuilder: (context, index) {
                final provider = serviceProviders[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: provider['image'] != 'N/A' 
                          ? MemoryImage(base64Decode(provider['image']))
                          : null,
                      child: provider['image'] == 'N/A' 
                          ? const Icon(Icons.person)
                          : null,
                    ),
                    title: Text(
                      provider['name'],
                      style: const TextStyle(fontWeight: FontWeight.bold)
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildProviderInfo('District', provider['district'] ?? 'N/A'),
                        _buildProviderInfo('Consultant Fee', provider['consultantFee'].toString()),
                        _buildProviderInfo('Amount Per Day', provider['amountPerDay'].toString()),
                        Text(
                          'Rating: ${provider['rating'].toString()}',
                          style: const TextStyle(fontWeight: FontWeight.bold)
                        ),
                      ],
                    ),
                    trailing: ElevatedButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => US_ProviderDetails(provider: provider)
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.yellow,
                      ),
                      child: const Text('Choose'),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}