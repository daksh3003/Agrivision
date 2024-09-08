import 'package:flutter/material.dart';

class NewPostPage extends StatefulWidget {
  @override
  _NewPostPageState createState() => _NewPostPageState();
}

class _NewPostPageState extends State<NewPostPage> {
  String transactionType = 'Sell'; // Default value for transaction type
  String selectedType = 'Paddy Trading'; // Default pick type
  String address = 'No.30, Raju colony,\nRayachoty-Galiveedu Rd,\nKothapeta, Rayachoty,\nAndhra Pradesh - 516264.'; // Sample address
  int unit = 30; // Default unit
  String unitType = 'Kg'; // Default unit type
  int quantity = 10; // Default quantity
  int pricePerUnit = 1250; // Default price per unit

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('I want to', style: TextStyle(fontSize: 18)),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<String>(
                    title: Text('Buy'),
                    value: 'Buy',
                    groupValue: transactionType,
                    onChanged: (value) {
                      setState(() {
                        transactionType = value!;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile<String>(
                    title: Text('Sell'),
                    value: 'Sell',
                    groupValue: transactionType,
                    onChanged: (value) {
                      setState(() {
                        transactionType = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text('Pick type', style: TextStyle(fontSize: 16)),
            DropdownButton<String>(
              isExpanded: true,
              value: selectedType,
              items: [
                DropdownMenuItem(child: Text('Paddy Trading'), value: 'Paddy Trading'),
                DropdownMenuItem(child: Text('Wheat Trading'), value: 'Wheat Trading'),
                DropdownMenuItem(child: Text('Rice Trading'), value: 'Rice Trading'),
              ],
              onChanged: (value) {
                setState(() {
                  selectedType = value!;
                });
              },
            ),
            SizedBox(height: 10),
            Text('Address', style: TextStyle(fontSize: 16)),
            TextField(
              maxLines: 3,
              readOnly: true,
              decoration: InputDecoration(
                hintText: address,
                suffixIcon: IconButton(
                  icon: Icon(Icons.location_on),
                  onPressed: () {
                    // Handle address selection logic
                  },
                ),
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: Text('Unit = $unit')),
                SizedBox(width: 10),
                Expanded(
                  child: DropdownButton<String>(
                    value: unitType,
                    items: [
                      DropdownMenuItem(child: Text('Kg'), value: 'Kg'),
                      DropdownMenuItem(child: Text('Litre'), value: 'Litre'),
                      DropdownMenuItem(child: Text('Ton'), value: 'Ton'),
                    ],
                    onChanged: (value) {
                      setState(() {
                        unitType = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Quantity (in units)',
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        quantity = int.parse(value);
                      });
                    },
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Price per unit',
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        pricePerUnit = int.parse(value);
                      });
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text('Upload images', style: TextStyle(fontSize: 16)),
            Container(
              height: 100,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Icon(Icons.image),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Handle post confirmation logic
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
