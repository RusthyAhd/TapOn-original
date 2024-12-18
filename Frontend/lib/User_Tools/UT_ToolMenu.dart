import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tap_on/User_Tools/UT_ToolDetails.dart';
import 'package:http/http.dart' as http;

class UT_ToolMenu extends StatefulWidget {
  final String shopName; // Shop name to display relevant tools
  final String shopId;
  final String shopEmail;
  final String shopPhone;

  const UT_ToolMenu({
    super.key,
    required this.shopName,
    required this.shopId,
    required this.shopEmail,
    required this.shopPhone,
  });

  @override
  State<UT_ToolMenu> createState() => _UT_ToolMenuState();
}

class _UT_ToolMenuState extends State<UT_ToolMenu> {
  final List<Map<String, dynamic>> products = [];

  @override
  void initState() {
    super.initState();
    _initAsync();
  }

  void _initAsync() async {
    await getAllTools();
  }

  Future<void> getAllTools() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final baseURL = dotenv.env['BASE_URL'];
      final token = prefs.getString('token');

      if (baseURL == null || token == null) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Configuration Error',
          text: 'Please check your configuration and try again.',
        );
        return;
      }

      final response = await http.get(
        Uri.parse('$baseURL/tool/get/all/${widget.shopId}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token,
        },
      );

      final data = jsonDecode(response.body);

      if (data['status'] == 200) {
        final tools = data['data'];
        setState(() {
          products.clear();
          for (var tool in tools) {
            products.add({
              'id': tool['tool_id'] ?? 'N/A',
              'title': tool['title'] ?? 'Service Name',
              'price': tool['item_price'].toString() ?? 'N/A',
              'quantity': tool['qty'].toString(),
              'image': tool['pic'] ?? '',
              'description': tool['description'] ?? tool['title'],
              "availability": tool['availability'] ?? 'N/A',
              "available_days": tool['available_days'] ?? [],
              "available_hours": tool['available_hours'] ?? 'N/A',
            });
          }
        });
      } else {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Error',
          text: 'Failed to load tools. Please try again.',
        );
      }
    } catch (e) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Oops...',
        text: 'An error occurred. Please try again.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.shopName} Products',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24),
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
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                'assets/images/banner.avif', // Replace with your image path
                fit: BoxFit.cover,
                width: double.infinity,
                height: 180,
              ),
            ),
            const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return productTile(
                      context,
                      product['title']!,
                      product['price']!,
                      product['image']!,
                      product['description']!,
                      widget.shopEmail,
                      product,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget productTile(
      BuildContext context,
      String title,
      String price,
      String image,
      String description,
      String shopEmail,
      Map<String, dynamic> product) {
    // Ensure the base64 string length is a multiple of 4
    String formattedImage = image;
    if (formattedImage.length % 4 != 0) {
      formattedImage += '=' * (4 - (formattedImage.length % 4));
    }

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 5,
      margin: EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        contentPadding: EdgeInsets.all(12),
        leading: Hero(
          tag: title,
          child: Image(
            image: MemoryImage(
              base64Decode(formattedImage),
            ),
            height: 60,
            width: 60,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        subtitle: Text(
          price,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.green,
          ),
        ),
        trailing: Icon(Icons.arrow_forward_ios, color: Colors.black),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ToolDetails(
                title: title,
                price: price,
                image: image,
                description: description,
                shopEmail: shopEmail,
                product: product,
                shopPhone: widget.shopPhone,
              ),
            ),
          );
        },
      ),
    );
  }
}