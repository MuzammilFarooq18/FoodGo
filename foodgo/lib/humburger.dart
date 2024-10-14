import 'package:flutter/material.dart';
import 'package:foodgo/cart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class humburger extends StatefulWidget {
  const humburger({super.key});

  @override
  State<humburger> createState() => _humburgerState();
}

class _humburgerState extends State<humburger> {
  double spicyLevel = 0;
  int quantity = 1;
  double pricePerItem = 550;
  late double totalPrice;

  List<Map<String, dynamic>> cartItems = [];
  int _cartQuantity = 0;
  Offset cartIconPosition = Offset(300, 50);

  @override
  void initState() {
    super.initState();
    totalPrice = pricePerItem * quantity;
    _loadCartItems();  // Cart ko load karne ka function call karo
  }

  // didChangeDependencies: Yeh tab call hoga jab page back kar ke reload ho
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadCartItems();  // Cart quantity ko wapas reload karo jab page open ho
  }

  // Cart items load karna aur cart quantity ko update karna
  void _loadCartItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cartData = prefs.getString('cartItems');
    if (cartData != null) {
      List<dynamic> jsonList = jsonDecode(cartData);
      cartItems = jsonList.map((item) => Map<String, dynamic>.from(item)).toList();
      setState(() {
        _cartQuantity = cartItems.fold(0, (sum, item) => sum + (item['quantity'] as int));  // Cart quantity ko update karo
      });
    }
  }

  void _saveCartItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonString = jsonEncode(cartItems);
    await prefs.setString('cartItems', jsonString);
  }

  void clearCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('cartItems');
    setState(() {
      cartItems.clear();
      _cartQuantity = 0;
    });
  }

  void updateTotalPrice() {
    setState(() {
      totalPrice = pricePerItem * quantity;
    });
  }

  void addToCart() {
    Map<String, dynamic> selectedItem = {
      'name': 'Chicken Burger',
      'quantity': quantity,
      'price': totalPrice,
    };
    cartItems.add(selectedItem);
    _cartQuantity += quantity;
    _saveCartItems();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added to Cart!'),
        duration: Duration(milliseconds: 1),
      ),
    );

    setState(() {
      quantity = 1;
      updateTotalPrice();
    });
  }

  void _removeItemFromCart(int index) {
    setState(() {
      _cartQuantity -= cartItems[index]['quantity'] as int;
      cartItems.removeAt(index);
      _saveCartItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 40.0, left: 5.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.black),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 0),
                Center(
                  child: Image.asset(
                    'assets/images/container3.png',
                    height: 120,
                    width: 120,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 5),
                Center(
                  child: Text(
                    "Humburger Chicken Burger",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 20),
                      SizedBox(width: 8),
                      Text(
                        '4.9',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 0),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, top: 10.0, right: 20.0),
                  child: Text(
                    "CHumburger: A good beef patty cooked and served on a bun, often with toppings like cheese, lettuce, tomato, onion, pickles, and condiments. Chicken burger: A similar type of burger but made with the breaded and grilled chicken patty instead of beef, pickles, and ketchup on a toasted bun.",
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
                SizedBox(height: 10),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    'Spicy',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getSpicyLabel(spicyLevel),
                        style: TextStyle(
                          fontSize: 18,
                          color: _getSpicyColor(spicyLevel),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Slider(
                        value: spicyLevel,
                        min: 0,
                        max: 10,
                        divisions: 10,
                        activeColor: _getSpicyColor(spicyLevel),
                        inactiveColor: Colors.grey[300],
                        label: spicyLevel.toStringAsFixed(1),
                        onChanged: (newValue) {
                          setState(() {
                            spicyLevel = newValue;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Quantity',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.remove, color: Colors.white),
                                  onPressed: () {
                                    setState(() {
                                      if (quantity > 1) {
                                        quantity--;
                                        updateTotalPrice();
                                      }
                                    });
                                  },
                                ),
                                Text(
                                  '$quantity',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.add, color: Colors.white),
                                  onPressed: () {
                                    setState(() {
                                      quantity++;
                                      updateTotalPrice();
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 20),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 5),
                            child: Text(
                              'Total Price: ${totalPrice.toStringAsFixed(1)}',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    child: ElevatedButton(
                      onPressed: addToCart, // Call addToCart on button press
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding:
                            EdgeInsets.symmetric(horizontal: 80, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: Text(
                        'Add to Cart ',
                        style: TextStyle(fontSize: 27,color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: cartIconPosition.dx,
            top: cartIconPosition.dy,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CartPage(
                      cartItems: cartItems,
                      onRemoveItem: _removeItemFromCart, // Include the remove function here
                    ),
                  ),
                );
              },
              child: Stack(
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    color: Colors.black,
                    size: 40,
                  ),
                  if (_cartQuantity > 0)
                    Positioned(
                      right: 0,
                      bottom: 16,
                      child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '$_cartQuantity',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
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

  String _getSpicyLabel(double level) {
    if (level <= 3) {
      return 'Low';
    } else if (level <= 7) {
      return 'Mid';
    } else {
      return 'Hot';
    }
  }

  Color _getSpicyColor(double level) {
    if (level <= 3) {
      return Colors.green;
    } else if (level <= 7) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
}





































