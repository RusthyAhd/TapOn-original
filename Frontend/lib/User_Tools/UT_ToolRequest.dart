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

  const UT_ToolRequest({
    Key? key,
    required this.product,
    required this.shopEmail,
  }) : super(key: key);

  @override
  State<UT_ToolRequest> createState() => _UT_ToolRequestState();
}

class _UT_ToolRequestState extends State<UT_ToolRequest> {
  final List<String> weekdays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
  List<String> selectedWeekdays = [];
  TextEditingController _qytController = TextEditingController();
  int quantity = 1;

  @override
  void initState() {
    super.initState();
    selectedWeekdays = widget.product['available_days'] != null
        ? List<String>.from(widget.product['available_days'])
        : [];
    quantity = int.parse(widget.product['quantity'] ?? '1');
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

  Future<void> handleAddNewOrder() async {
    LoadingDialog.show(context);

    try {
      final baseURL = dotenv.env['BASE_URL'];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final bodyData = {
        "tool_id": widget.product['id'],
        "shop_id": widget.shopEmail,
        "title": widget.product['title'],
        "qty": quantity,
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

      if (data['status'] == 200) {
        LoadingDialog.hide(context);
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
        _showErrorAlert();
      }
    } catch (e) {
      LoadingDialog.hide(context);
      debugPrint('Something went wrong $e');
    }
  }

  void _showErrorAlert() {
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

  void _showConfirmAlert() {
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
              Text('Amount: LKR ${widget.product['price']} x $quantity'),
              Text('Total: LKR ${double.parse(widget.product['price']) * quantity}'),
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
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
              ),
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Request Tools', style: TextStyle(color: Colors.white, fontSize: screenWidth * 0.05)),
        centerTitle: true,
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
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          child: SingleChildScrollView(
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: screenHeight * 0.02),
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: widget.product['image'] != null && widget.product['image'].isNotEmpty && isBase64(widget.product['image'])
                            ? Image.memory(
                                base64Decode(widget.product['image']),
                                height: screenWidth * 0.4,
                                width: screenWidth * 0.4,
                                fit: BoxFit.cover,
                              )
                            : Icon(Icons.image, size: screenWidth * 0.4, color: Colors.grey[400]),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    _buildInfoRow("Tool", widget.product['title']),
                    _buildInfoRow("Availability", widget.product['availability']),
                    _buildInfoRow("Amount", "LKR ${widget.product['price']} per hour"),
                    _buildInfoRow("Available Quantity", widget.product['quantity']),
                    SizedBox(height: screenHeight * 0.02),
                    Text("Enter Quantity", style: TextStyle(fontSize: screenWidth * 0.05, fontWeight: FontWeight.bold)),
                    SizedBox(height: screenHeight * 0.01),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove_circle, color: Colors.blueAccent),
                          onPressed: quantity > 1
                              ? () => setState(() {
                                    quantity--;
                                    _qytController.text = quantity.toString();
                                  })
                              : null,
                        ),
                        SizedBox(
                          width: 50,
                          child: TextField(
                            controller: _qytController,
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(border: InputBorder.none),
                            onChanged: (value) {
                              setState(() {
                                quantity = int.tryParse(value) ?? 1;
                              });
                            },
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.add_circle, color: Colors.blueAccent),
                          onPressed: quantity < int.parse(widget.product['quantity'] ?? '1')
                              ? () => setState(() {
                                    quantity++;
                                    _qytController.text = quantity.toString();
                                  })
                              : null,
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.04),
                    Center(
                      child: ElevatedButton(
                        onPressed: _showConfirmAlert,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.2, vertical: 15),
                        ),
                        child: Text('Request Now', style: TextStyle(fontSize: screenWidth * 0.045)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("$title:", style: TextStyle(fontWeight: FontWeight.bold)),
          Text(value ?? 'N/A', style: TextStyle(color: Colors.black54)),
        ],
      ),
    );
  }
}
