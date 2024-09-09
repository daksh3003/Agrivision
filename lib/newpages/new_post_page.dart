import 'package:flutter/material.dart';
import 'package:agriplant/pages/orders_page.dart';
import 'package:agriplant/models/marketplace.dart'; // Import MarketplaceProduct model
import 'package:image_picker/image_picker.dart'; // Import image_picker package
import 'dart:io'; // Import dart:io for File class

class NewPostPage extends StatefulWidget {
  final Marketplace product; // Add a required product field

  const NewPostPage({required this.product, super.key}); // Updated constructor to accept product

  @override
  _NewPostPageState createState() => _NewPostPageState();
}

class _NewPostPageState extends State<NewPostPage> {
  final _formKey = GlobalKey<FormState>(); // Key for the form
  String transactionType = 'Sell'; // Initial selected value for transaction type
  String selectedUnit = 'Kg'; // State for unit selection
  File? _image; // Variable to hold the selected image
  bool _isImageUploadDisabled = false; // Boolean to control the interactivity of the Upload Image container
  bool _isPriceReadOnly = false; // Boolean to control whether the price field is read-only
  double? _fixedPricePerUnit; // Fixed price per unit for "Buy"
  final ImagePicker _picker = ImagePicker(); // Create an instance of ImagePicker

  final TextEditingController _quantityController = TextEditingController(); // Controller for quantity input
  final TextEditingController _priceController = TextEditingController(); // Controller for price input

  @override
  void initState() {
    super.initState();
    _fixedPricePerUnit = widget.product.price; // Set fixed price based on product
  }

  Future<void> pickImageFromGallery() async {
    if (_isImageUploadDisabled) return; // Do nothing if image upload is disabled
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path); // Update the state with the selected image
      });
    }
  }

  void _setDefaultImage() {
    setState(() {
      _image = File(widget.product.image); // Load image from assets
      _isImageUploadDisabled = true; // Disable image upload when default image is set
      _priceController.text = _fixedPricePerUnit.toString(); // Set the fixed price for "Buy"
      _isPriceReadOnly = true; // Make price field read-only
    });
  }

  bool _validateForm() {
    return _formKey.currentState?.validate() ?? false; // Validate the form
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(widget.product.name), // Use product.name for the AppBar title
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey, // Form key for validation
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'I want to',
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Radio<String>(
                            value: 'Buy',
                            groupValue: transactionType,
                            onChanged: (value) {
                              setState(() {
                                transactionType = value!;
                                if (transactionType == 'Buy') {
                                  _setDefaultImage(); // Set default image and price for "Buy"
                                } else {
                                  _image = null; // Clear image for "Sell"
                                  _isImageUploadDisabled = false; // Re-enable image upload for "Sell"
                                  _priceController.clear(); // Clear price field
                                  _isPriceReadOnly = false; // Make price field editable
                                }
                              });
                            },
                          ),
                          const Text('Buy'),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Radio<String>(
                            value: 'Sell',
                            groupValue: transactionType,
                            onChanged: (value) {
                              setState(() {
                                transactionType = value!;
                                if (transactionType == 'Sell') {
                                  _image = null; // Clear image for "Sell"
                                  _isImageUploadDisabled = false; // Re-enable image upload for "Sell"
                                  _priceController.clear(); // Clear price field
                                  _isPriceReadOnly = false; // Make price field editable
                                }
                              });
                            },
                          ),
                          const Text('Sell'),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text('Address', style: TextStyle(fontSize: 16)),
                const SizedBox(height: 10),
                TextFormField(
                  maxLines: 3,
                  readOnly: false,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.location_on),
                      onPressed: () {
                        // Implement address picker or location search
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Unit section with label and dropdown on the same line
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Unit', style: TextStyle(fontSize: 16)),
                    Container(
                      width: 150, // Set width of the DropdownButton
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: DropdownButton<String>(
                        isExpanded: true, // Ensures the dropdown takes the full width of the container
                        value: selectedUnit,
                        iconSize: 30, // Increase the size of the dropdown icon
                        style: const TextStyle(fontSize: 16),
                        dropdownColor: Colors.white, // Adjust dropdown background color if needed
                        items: [
                          DropdownMenuItem(
                            child: Text(
                              'Kg',
                              style: TextStyle(color: Colors.grey.shade800), // Gray color for the text
                            ),
                            value: 'Kg',
                          ),
                          DropdownMenuItem(
                            child: Text(
                              'Grams',
                              style: TextStyle(color: Colors.grey.shade800), // Gray color for the text
                            ),
                            value: 'Grams',
                          ),
                          DropdownMenuItem(
                            child: Text(
                              'Ton',
                              style: TextStyle(color: Colors.grey.shade800), // Gray color for the text
                            ),
                            value: 'Ton',
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            selectedUnit = value!;
                          });
                        },
                        underline: Container(
                          height: 2,
                          color: Colors.transparent, // Remove underline
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text('Quantity and Price', style: TextStyle(fontSize: 16)),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _quantityController,
                        decoration: const InputDecoration(
                          labelText: 'Quantity (in units)',
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a quantity';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        controller: _priceController,
                        decoration: const InputDecoration(
                          labelText: 'Price per unit',
                        ),
                        keyboardType: TextInputType.number,
                        readOnly: _isPriceReadOnly, // Make the price field read-only based on the state
                        validator: (value) {
                          if (transactionType == 'Sell' && (value == null || value.isEmpty)) {
                            return 'Please enter a price';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text('Upload image', style: TextStyle(fontSize: 16)),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: _isImageUploadDisabled ? null : pickImageFromGallery, // Disable if flag is true
                  child: Container(
                    height: 150, // Increased height of the container
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: _image == null
                        ? Center(
                      child: Icon(
                        Icons.image,
                        size: 50, // Increased size of the icon
                        color: Colors.grey,
                      ),
                    )
                        : Image.file(
                      _image!,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: FilledButton(
                    onPressed: _validateForm() ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const OrdersPage(),
                        ),
                      );
                    } : null, // Disable the button if the form is not valid
                    child: const Text('Submit'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
