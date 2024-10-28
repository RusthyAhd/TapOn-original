import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tap_on/Tool_Provider/TP_AddTool.dart';
import 'package:tap_on/widgets/Loading.dart';
import 'package:http/http.dart' as http;

class TP_ToolManager extends StatefulWidget {
  const TP_ToolManager({super.key});

  @override
  _TP_ToolManagerState createState() => _TP_ToolManagerState();
}

class _TP_ToolManagerState extends State<TP_ToolManager> {
  final List<Map<String, dynamic>> menuItems = [];
  TextEditingController nameController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  bool available = true;

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
      final providerId = prefs.getString('toolProviderId');

      final response = await http
          .get(Uri.parse('$baseURL/tool/get/all/$providerId'), headers: {
        'Content-Type': 'application/json',
        'Authorization': '$token',
      });

      final data = jsonDecode(response.body);
      final status = data['status'];

      if (status == 200) {
        final tools = data['data'];
        setState(() {
          menuItems.clear();
          for (var tool in tools) {
            menuItems.add({
              'id': tool['tool_id'] ?? 0,
              'name': tool['service'] ?? 'Service Name',
              'price': tool['item_price'] ?? 0.0,
              'quantity': tool['qty'] ?? 0,
              'available': tool['availability'] == 'Available' ? true : false,
              'image': tool['pic'] ?? '',
            });
          }
        });
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
    }
  }

  void handleEditTool(Map<String, dynamic> tool, int index) async {
    try {
      LoadingDialog.show(context);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final baseURL = dotenv.env['BASE_URL'];
      final token = prefs.getString('token');

      final requestBody = {
        'title': nameController.text == '' ? tool['name'] : nameController.text,
        'price': priceController.text == ''
            ? tool['price']
            : double.tryParse(priceController.text) ?? 0.0,
        'qty': quantityController.text == ''
            ? tool['quantity']
            : int.tryParse(quantityController.text) ?? 0,
        'availability': available ? 'Available' : 'Not Available',
        'pic': tool['image'],
      };

      final response = await http.put(
        Uri.parse('$baseURL/tool/update/${tool['id']}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': '$token',
        },
        body: json.encode(requestBody),
      );

      final data = jsonDecode(response.body);
      final status = data['status'];

      if (status == 200) {
        LoadingDialog.hide(context);
        setState(() {
          menuItems[index]['name'] =
              nameController.text == '' ? tool['name'] : nameController.text;
          menuItems[index]['price'] = priceController.text == ''
              ? tool['price']
              : double.tryParse(priceController.text) ?? 0.0;
          menuItems[index]['available'] = available;
          menuItems[index]['quantity'] = quantityController.text == ''
              ? tool['quantity']
              : int.tryParse(quantityController.text) ?? 0;
        });
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          title: 'Success',
          text: 'Service updated successfully',
          backgroundColor: Colors.black,
          titleColor: Colors.white,
          textColor: Colors.white,
        );
      } else {
        LoadingDialog.hide(context);
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Oops...',
          text: 'Failed to update service',
          backgroundColor: Colors.black,
          titleColor: Colors.white,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      LoadingDialog.hide(context);
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
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow[700],
        title: Text('Menu Management'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TP_AddTool()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.yellow),
                  child: Text('+ Item'),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.02),
            Expanded(
              child: ListView.builder(
                itemCount: menuItems.length,
                itemBuilder: (context, index) {
                  var item = menuItems[index];

                  return Card(
                    elevation: 4,
                    child: ListTile(
                      leading: SizedBox(
                        width: screenWidth * 0.2,
                        height: screenHeight * 0.1,
                        child: item['image'] == null || item['image'].isEmpty
                            ? Icon(Icons.image)
                            : Image(
                                image: MemoryImage(
                                  base64Decode(
                                    item['image'].padRight(
                                      item['image'].length +
                                          (4 - item['image'].length % 4) % 4,
                                      '=',
                                    ),
                                  ),
                                ),
                              ),
                      ),
                      title: Text(item['name']),
                      subtitle: Text(
                          'Quantity: ${item['quantity']}\nLKR ${item['price']}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            item['available'] ? 'Available' : 'Not Available',
                            style: TextStyle(
                                color: item['available']
                                    ? Colors.green
                                    : Colors.red),
                          ),
                          SizedBox(width: screenWidth * 0.02),
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              _editItemDialog(context, item, index);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _editItemDialog(
      BuildContext context, Map<String, dynamic> item, int index) {
    nameController.text = item['name'];
    priceController.text = item['price'].toString();
    quantityController.text = item['quantity'].toString();
    available = item['available'];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Edit Item"),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: 'Name'),
                  ),
                  TextField(
                    controller: priceController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Price'),
                  ),
                  TextField(
                    controller: quantityController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Quantity'),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Available:'),
                      Switch(
                        value: available,
                        onChanged: (bool value) {
                          setState(() {
                            available = value;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () {
                handleEditTool(item, index);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}