import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tap_on/User_Tools/UT_ProviderOrderStatus.dart';
import 'package:tap_on/widgets/Loading.dart';
import 'package:http/http.dart' as http;

class UT_ToolRequest extends StatefulWidget {
  final Map<String, dynamic> product;
  final String shopEmail;
  
  const UT_ToolRequest({super.key, 
    required this.product,
    required this.shopEmail,
  });

  @override
  State<UT_ToolRequest> createState() => _UT_ToolRequestState();
}

class _UT_ToolRequestState extends State<UT_ToolRequest> {
  final List<String> weekdays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
  List<String> selectedWeekdays = [];
  final TextEditingController _qytController = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedWeekdays = widget.product['available_days'] != null
        ? List<String>.from(widget.product['available_days'])
        : [];
    _qytController.text = '1';
  }

  bool isBase64(String str) {
    try {
      base64Decode(str);
      return true;
    } catch (_) {
      return false;
    }
  }

  void handleAddNewOrder() async {
    LoadingDialog.show(context);

    try {
      final baseURL = dotenv.env['BASE_URL']; // Get the base URL
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final qyt = _qytController.text.isEmpty
          ? '1'
          : int.parse(_qytController.text) > int.parse(widget.product['quantity'])
              ? widget.product['quantity']
              : _qytController.text;

      final bodyData = {
        "tool_id": widget.product['id'],
        "shop_id": widget.shopEmail,
        "title": widget.product['title'],
        "qty": int.parse(qyt),
        "days": 1,
        "status": "pending",
        "date": DateTime.now().toString(),
      };
      final response = await http.post(
        Uri.parse('$baseURL/to/new'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': '$token',
        },
        body: jsonEncode(bodyData),
      );
      final data = jsonDecode(response.body);
      final status = data['status'];
      
      if (status == 200) {
        LoadingDialog.hide(context);
        final order = data['data'];
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UT_ProviderOrderStatus(
              provider: widget.product,
              status: 'success',
              order: widget.product,
            ),
          ),
        );
      } else {
        LoadingDialog.hide(context);
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Oops...',
          text: 'Sorry, something went wrong',
          backgroundColor: Colors.black,
          titleColor: Colors.white,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      LoadingDialog.hide(context);
      debugPrint('Something went wrong $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.yellow[700],
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Request Tools', style: TextStyle(color: Colors.black, fontSize: screenWidth * 0.05)),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight * 0.02),
              Text(
                "Tool: ${widget.product['title'] ?? 'Name'}",
                style: TextStyle(fontSize: screenWidth * 0.045, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: screenHeight * 0.01),
              Center(
                child: widget.product['image'] != null && widget.product['image'].isNotEmpty && isBase64(widget.product['image'])
                    ? Image.memory(
                        base64Decode(widget.product['image']),
                        height: screenWidth * 0.4,
                        width: screenWidth * 0.4,
                        fit: BoxFit.cover,
                      )
                    : Icon(Icons.image, size: screenWidth * 0.4), // Fallback icon
              ),
              SizedBox(height: screenHeight * 0.02),
              Text(
                "Availability: ${widget.product['availability'] ?? 'Available'}",
                style: TextStyle(fontSize: screenWidth * 0.045, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: screenHeight * 0.02),
              Text(
                "Available Days:",
                style: TextStyle(fontSize: screenWidth * 0.045, fontWeight: FontWeight.bold),
              ),
              Wrap(
                spacing: 8.0,
                children: weekdays.map((day) {
                  return FilterChip(
                    label: Text(day),
                    selected: selectedWeekdays.contains(day),
                    onSelected: (isSelected) {},
                  );
                }).toList(),
              ),
              SizedBox(height: screenHeight * 0.02),
              Text(
                "Amount: LKR ${widget.product['price'] ?? 'N/A'} per tool",
                style: TextStyle(fontSize: screenWidth * 0.045, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: screenHeight * 0.01),
              Text(
                "Available Quantity: ${widget.product['quantity'] ?? 'N/A'}",
                style: TextStyle(fontSize: screenWidth * 0.045, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: screenHeight * 0.02),
              Text(
                "Enter the number of quantity you want to request",
                style: TextStyle(fontSize: screenWidth * 0.045, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: screenHeight * 0.01),
              TextField(
                keyboardType: TextInputType.number,
                controller: _qytController,
                decoration: InputDecoration(
                  labelText: 'Number of quantity',
                  hintText: '1',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: screenHeight * 0.05),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    _showConfirmAlert(widget.product['price'], _qytController.text.isEmpty ? '1' : _qytController.text);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.yellow,
                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1, vertical: 15),
                    textStyle: TextStyle(fontSize: screenWidth * 0.045, color: Colors.white),
                  ),
                  child: Text('Request Now'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showConfirmAlert(price, qyt) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Request'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Tool: ${widget.product['title'] ?? 'title'}'),
              Text('Amount: LKR $price for $qyt quantity'),
              Text('Total: LKR ${double.parse(price) * int.parse(qyt)}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                handleAddNewOrder();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.yellow,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                textStyle: TextStyle(fontSize: 14, color: Colors.white),
              ),
              child: Text('Request Tools'),
            ),
          ],
        );
      },
    );
  }
}