//showprovider.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tap_on/User_Service/US_Location.dart';
import 'package:tap_on/User_Service/US_ProviderDetails.dart';
import 'package:http/http.dart' as http;
import 'package:tap_on/services/geo_services.dart';
import 'package:latlong2/latlong.dart' as latlong;
import 'package:flutter_map/flutter_map.dart' as flutter_map_lib;
import 'package:google_maps_flutter/google_maps_flutter.dart' as google_maps;
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
  final Set<google_maps.Marker> _markers = {};
  final List<Map<String, dynamic>> serviceProviders = [];
  bool _isLoading = true;
  bool _noProviders = false;

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

      final bodyData = {
        "location_long": coordinates['longitude'],
        "location_lat": coordinates['latitude'],
        'service_category': widget.category,
      };

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
        body: jsonEncode(bodyData),
      );

      final data = jsonDecode(response.body);
      final status = data['status'];

      if (status == 200) {
        final services = data['data'];
        if (services.length > 0) {
          List<Map<String, dynamic>> newProviders = [];
          Set<google_maps.Marker> providerMarkers = {};
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
            if (service['location_lat'] == null ||
                service['location_long'] == null) {
              continue;
            }
            providerMarkers.add(
              google_maps.Marker(
                markerId: google_maps.MarkerId(service['shop_name'] ?? 'N/A'),
                position: google_maps.LatLng(
                    service['location_lat'], service['location_long']),
                infoWindow: google_maps.InfoWindow(
                    title: service['shop_name'] ?? 'N/A'),
              ),
            );
          }
          setState(() {
            serviceProviders.clear();
            serviceProviders.addAll(newProviders);
            _markers.clear();
            _markers.addAll(providerMarkers);
            _isLoading = false;
            _noProviders = false;
          });
        } else {
          setState(() {
            _isLoading = false;
            _noProviders = true;
          });
        }
      }
    } catch (e) {
      print(e);
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Oops...',
        text: 'An error occurred. Please try again.',
        backgroundColor: Colors.black,
        titleColor: Colors.white,
        textColor: Colors.white,
      );
      setState(() {
        _isLoading = false;
        _noProviders = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.yellow[700],
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => US_Location(category: widget.category)),
            );
          },
        ),
        title: Text('Nearby Service Providers',
            style: TextStyle(color: Colors.black)),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Container(
            height: 250,
            margin: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                )
              ],
              border:
                  Border.all(color: Colors.white.withOpacity(0.4), width: 1),
            ),
            child: Expanded(
              child: Stack(
                children: [
                  GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(_latitude, _longitude),
                      zoom: 13,
                    ),
                    onMapCreated: (GoogleMapController controller) {
                      mapController = controller;
                    },
                    markers: _markers,
                  ),
                ],
              ),
            ),
          ),
          _isLoading
              ? Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Spacer(),
                      Center(child: CircularProgressIndicator()),
                      Spacer(flex: 2),
                    ],
                  ),
                )
              : _noProviders
                  ? Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Spacer(),
                          Center(
                            child: Text(
                              'No Exist Providers in Here',
                              style: TextStyle(fontSize: 16, color: Colors.red),
                            ),
                          ),
                          Spacer(flex: 2),
                        ],
                      ),
                    )
                  : Expanded(
                      child: ListView.builder(
                        itemCount: serviceProviders.length,
                        itemBuilder: (context, index) {
                          final provider = serviceProviders[index];
                          return Card(
                            margin: EdgeInsets.all(10),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage: MemoryImage(
                                  base64Decode(provider['image']),
                                ),
                              ),
                              title: Text(provider['name'],
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      text: 'District: ',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: provider['district'] ?? 'N/A',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.normal,
                                            color: const Color.fromARGB(
                                                255, 3, 112, 207),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      text: 'Consultant Fee: ',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: provider['consultantFee']
                                                  .toString() ??
                                              'N/A',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.normal,
                                            color: const Color.fromARGB(
                                                255, 3, 112, 207),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      text: 'Amount Per Day: ',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: provider['amountPerDay']
                                                  .toString() ??
                                              'N/A',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.normal,
                                            color: const Color.fromARGB(
                                                255, 3, 112, 207),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                      'Rating: ${provider['rating'].toString()}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                              trailing: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            US_ProviderDetails(
                                                provider: provider)),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  foregroundColor: Colors.yellow,
                                ),
                                child: Text('Choose'),
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
