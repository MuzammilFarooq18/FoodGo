import 'package:flutter/material.dart';
import 'package:foodgo/cart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class customizepage extends StatefulWidget {
  const customizepage({super.key});

  @override
  State<customizepage> createState() => _customizepageState();
}

class _customizepageState extends State<customizepage> {
  double _spiceLevel = 1;
  int _portionCount = 1;
  double _pricePerPortion = 350;
  double _totalPrice = 0.0;
  int _cartQuantity = 0; // To keep track of quantity in cart
  Offset _cartPosition = Offset(300, 50); // Default position of the cart icon

  Map<String, double> toppingPrices = {
    'Tomato': 50,
    'Onions': 50,
    'Pickles': 75,
    'Bacons': 200,
  };

  Map<String, double> sidePrices = {
    'Fries': 250,
    'Salad': 200,
    'Coleslaw': 120,
    'Mushroom': 180,
  };

  List<Map<String, dynamic>> cartItems = []; // Cart items list

  @override
  void initState() {
    super.initState();
    _loadCartItems(); // Load cart items from SharedPreferences
  }

  Future<void> _loadCartItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? itemsString = prefs.getString('cartItems');
    if (itemsString != null) {
      List<dynamic> items = json.decode(itemsString);
      setState(() {
        cartItems =
            items.map((item) => Map<String, dynamic>.from(item)).toList();
        _cartQuantity = cartItems.fold(
            0,
            (int sum, item) =>
                sum + (item['quantity'] as int)); // Corrected type
      });
    }
  }

  Future<void> _saveCartItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String itemsString = json.encode(cartItems); // Encode cart items
    await prefs.setString('cartItems', itemsString); // Save as a single string
  }

  void _removeCartItem(int index) {
    setState(() {
      _cartQuantity -= cartItems[index]['quantity'] as int; // Decrease quantity
      cartItems.removeAt(index); // Remove item from cart
      _saveCartItems(); // Update SharedPreferences
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 20, // Adjust the position
            left: 5, // Adjust the position
            child: IconButton(
              icon: Icon(Icons.arrow_back, size: 30),
              onPressed: () {
                Navigator.pop(context); // Back navigation
              },
            ),
          ),

          Positioned(
            top: 60,
            left: -75,
            child: Image.asset(
              'assets/images/customize.png',
              height: 300,
              width: 300,
            ),
          ),
          Positioned(
            top: 0,
            left: 10,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildToppingsSection(),
                  SizedBox(height: 20),
                  _buildSidesSection(),
                  SizedBox(height: 20),
                  _buildPriceDisplay(),
                ],
              ),
            ),
          ),
          Positioned(
            top: 55,
            left: 175,
            child: Container(
              width: 200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Customize: ',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text:
                              'Your Burger to Your Taste. Ultimate Experience',
                          style: TextStyle(
                            fontSize: 17,
                            color: Color.fromARGB(255, 110, 108, 108),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30),
                  _buildSpiceSelector(),
                  SizedBox(height: 20),
                  _buildPortionSelector(),
                ],
              ),
            ),
          ),
          // Draggable Cart Icon
          Positioned(
            top: 123,
            left: _cartPosition.dx,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CartPage(
                        cartItems: cartItems, onRemoveItem: _removeCartItem),
                  ),
                );
              },
              child: Stack(
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 45,
                    color: Colors.black,
                  ),
                  if (_cartQuantity >
                      0) // Show badge if quantity is greater than 0
                    Positioned(
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: BoxConstraints(
                          maxWidth: 20,
                          maxHeight: 20,
                        ),
                        child: Center(
                          child: Text(
                            '$_cartQuantity',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartIcon() {
    return Stack(
      alignment: Alignment.topLeft,
      children: [
        Icon(
          Icons.shopping_cart_outlined,
          size: 50,
          color: Colors.black,
        ),
        if (_cartQuantity > 0)
          Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
            child: Text(
              _cartQuantity.toString(),
              style: TextStyle(
                fontSize: 12,
                color: Colors.white,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPriceDisplay() {
    double totalPrice = _portionCount * _pricePerPortion + _totalPrice;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(10),
          ),
          
          child: Text(
            'Total Price: ${totalPrice.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(width: 50),
        ElevatedButton(
          onPressed: () {
            // Add the item to the cart and update the quantity
            Map<String, dynamic> selectedItem = {
              'name': 'Customized Burger',
              'quantity': _portionCount,
              'price': _portionCount * _pricePerPortion + _totalPrice,
            };

            setState(() {
              cartItems.add(selectedItem); // Add item to cart
              _cartQuantity += _portionCount;
              _portionCount = 1;
              _totalPrice = 0.0;
              _spiceLevel = 1;
            });

            // Save the cart items to SharedPreferences
            _saveCartItems();

            // Show a message (optional)
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Added to your Cart!',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                duration: Duration(
                    milliseconds: 1), // Snackbar will show for 1 second
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red, // Red background
            padding: EdgeInsets.symmetric(vertical: 9, horizontal: 17),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12), // Rounded corners
            ),
          ),
          child: Text(
            'Add to Cart',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSpiceSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Spicy",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Slider(
          value: _spiceLevel,
          min: 0,
          max: 2,
          divisions: 2,
          label: _getSpiceLabel(_spiceLevel),
          onChanged: (value) {
            setState(() {
              _spiceLevel = value;
            });
          },
          activeColor: _getSpiceColor(_spiceLevel),
          inactiveColor: Colors.grey,
        ),
        Text(
          _getSpiceLabel(_spiceLevel),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: _getSpiceColor(_spiceLevel),
          ),
        ),
      ],
    );
  }

  Widget _buildPortionSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Portion",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 35, // Adjust the height
              width: 35, // Adjust the width
              decoration: BoxDecoration(
                color: Colors.red, // Background color red
                borderRadius:
                    BorderRadius.circular(8), // Optional: Rounded corners
              ),
              child: IconButton(
                icon: Icon(Icons.remove,
                    color: Colors.white, size: 20), // Icon color white
                onPressed: () {
                  setState(() {
                    if (_portionCount > 1) {
                      _portionCount--;
                    }
                  });
                },
              ),
            ),
            SizedBox(width: 30), // Add space between the buttons and text
            Text(
              _portionCount.toString(),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
            ),
            SizedBox(width: 30), // Add space between the text and add button
            Container(
              height: 35,
              width: 35,
              decoration: BoxDecoration(
                color: Colors.red, // Background color red
                borderRadius:
                    BorderRadius.circular(8), // Optional: Rounded corners
              ),
              child: IconButton(
                icon: Icon(Icons.add,
                    color: Colors.white, size: 20), // Icon color white
                onPressed: () {
                  setState(() {
                    _portionCount++;
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildToppingsSection() {
    List<Map<String, String>> toppings = [
      {'name': 'Tomato', 'image': 'assets/images/tomato.png'},
      {'name': 'Onions', 'image': 'assets/images/onion.png'},
      {'name': 'Pickles', 'image': 'assets/images/pickles.png'},
      {'name': 'Bacons', 'image': 'assets/images/bacon.png'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 360),
        Text(
          "Toppings",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: toppings.map((topping) {
              return Padding(
                padding: const EdgeInsets.only(right: 0.0),
                child: _buildToppingCard(topping['name']!, topping['image']!),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildSidesSection() {
    List<Map<String, String>> sides = [
      {'name': 'Fries', 'image': 'assets/images/fries.png'},
      {'name': 'Salad', 'image': 'assets/images/salad.png'},
      {'name': 'Coleslaw', 'image': 'assets/images/coleslaw.png'},
      {'name': 'Mushroom', 'image': 'assets/images/mushroom.png'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 0),
        Text(
          "Sides Options",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: sides.map((side) {
              return Padding(
                padding: const EdgeInsets.only(right: 0.0),
                child: _buildSideCard(side['name']!, side['image']!),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildToppingCard(String itemName, String imagePath) {
    return Container(
      width: 90,
      height: 136,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 3,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            imagePath,
            height: 65,
            width: 65,
          ),
          SizedBox(height: 0),
          Text(
            itemName,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: IconButton(
                icon: Icon(Icons.add, color: Colors.white),
                onPressed: () {
                  _addTopping(itemName);
                  _showAddedDialog(itemName);
                },
                iconSize: 18,
                padding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSideCard(String itemName, String imagePath) {
    return Container(
      width: 90,
      height: 136,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 3,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            imagePath,
            height: 65,
            width: 65,
          ),
          SizedBox(height: 0),
          Text(
            itemName,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: IconButton(
                icon: Icon(Icons.add, color: Colors.white),
                onPressed: () {
                  _addSide(itemName);
                  _showAddedDialog(itemName);
                },
                iconSize: 18,
                padding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _addTopping(String topping) {
    setState(() {
      _totalPrice += toppingPrices[topping] ?? 0.0;
    });
  }

  void _addSide(String side) {
    setState(() {
      _totalPrice += sidePrices[side] ?? 0.0;
    });
  }

  void _showAddedDialog(String itemName) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Stack(
          children: [
            Positioned(
              top: 40,
              left: MediaQuery.of(context).size.width * 0.1,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 24,
                      ),
                      SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          '$itemName has been added!',
                          style: TextStyle(fontSize: 18),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );

    // Auto close the dialog after 1 second
    Future.delayed(Duration(seconds: 1), () {
      Navigator.of(context).pop(); // Close dialog after delay
    });
  }

  String _getSpiceLabel(double level) {
    if (level == 0) return "Less Spicy";
    if (level == 1) return "Normal Spicy";
    return "Hot";
  }

  Color _getSpiceColor(double level) {
    if (level == 0) return Colors.green;
    if (level == 1) return Colors.orange;
    return Colors.red;
  }
}





