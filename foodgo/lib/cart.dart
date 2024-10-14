import 'package:flutter/material.dart';
import 'package:foodgo/home.dart';

class CartPage extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  final Function(int) onRemoveItem;

  CartPage({Key? key, required this.cartItems, required this.onRemoveItem})
      : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final double _deliveryCharge = 100.0;
  int _selectedPaymentMethodIndex = 0;
  bool _isPaymentMethodSelected = false;

  void _increaseQuantity(int index) {
    setState(() {
      widget.cartItems[index]['quantity']++;
    });
  }

  void _decreaseQuantity(int index) {
    setState(() {
      if (widget.cartItems[index]['quantity'] > 1) {
        widget.cartItems[index]['quantity']--;
      }
    });
  }

   void _validateOrder() {
    if (_selectedPaymentMethodIndex == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please select a payment method!"),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      // Process the order for all items
      for (var item in widget.cartItems) {
        print("Ordering ${item['quantity']} of ${item['name']}");
      }

      // Clear the cart
      widget.onRemoveItem(0); // Ensure this method clears the cart

      // Show success popup
      _showSuccessPopup();
    }
  }

  void _showSuccessPopup() {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(20),
          height: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle,
                size: 80,
                color: Colors.red,
              ),
              SizedBox(height: 20),
              Text(
                'Success!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.red),
              ),
              SizedBox(height: 10),
              Text(
                'Your payment was successful. A receipt for the purchase has been sent to your email.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              Spacer(),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => homepage()),
                    (Route<dynamic> route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                ),
                child: Text(
                  'Go Back',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double totalPrice = widget.cartItems.fold(0.0, (sum, item) {
      return sum + (item['price'] * item['quantity']);
    });

    double taxRate = 0.05;
    double taxAmount = totalPrice * taxRate;
    double grandTotal = totalPrice + taxAmount + _deliveryCharge;

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 20,
            left: 5,
            child: IconButton(
              icon: Icon(Icons.arrow_back, size: 30),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          Positioned(
            top: 70,
            left: 15,
            child: Text(
              'Order Summary',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
          ),
          widget.cartItems.isEmpty
              ? Center(
                  child: Text(
                    "Your cart is empty!",
                    style: TextStyle(
                        fontSize: 22,
                        color: Colors.grey,
                        fontWeight: FontWeight.w400),
                  ),
                )
              : SingleChildScrollView(
                  padding: EdgeInsets.only(top: 100, left: 5, right: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: widget.cartItems.length,
                        itemBuilder: (context, index) {
                          final item = widget.cartItems[index];
                          return Dismissible(
                            key: Key(item['name']),
                            background: Container(color: Colors.red),
                            direction: DismissDirection.endToStart,
                            onDismissed: (direction) {
                              setState(() {
                                widget.onRemoveItem(index);
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              decoration: BoxDecoration(
                                color: Colors.grey[200], // Background color
                                borderRadius: BorderRadius.circular(
                                    15), // Rounded corners
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black, // Shadow color
                                    blurRadius: 5,
                                    offset: Offset(0, 2), // Shadow position
                                  ),
                                ],
                              ),
                              child: ListTile(
                                contentPadding: EdgeInsets.all(
                                    15), // Padding inside the ListTile
                                title: Text(
                                  item['name'],
                                  style: TextStyle(
                                      fontSize: 23, color: Colors.black),
                                ),
                                subtitle: Text(
                                  'Quantity: ${item['quantity']} | Price: Rs. ${item['price']}',
                                  style: TextStyle(
                                      color: Colors
                                          .black54), // Subtitle text color
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon:
                                          Icon(Icons.remove, color: Colors.red),
                                      onPressed: () => _decreaseQuantity(index),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete,
                                          color: Colors.black),
                                      onPressed: () {
                                        setState(() {
                                          widget.onRemoveItem(index);
                                        });
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                "${item['name']} removed from cart"),
                                            duration: Duration(
                                                seconds:
                                                    1), // Duration of the Snackbar
                                          ),
                                        );
                                      },
                                    ),
                                    IconButton(
                                      icon:
                                          Icon(Icons.add, color: Colors.green),
                                      onPressed: () => _increaseQuantity(index),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 90),
                      Divider(color: Colors.grey),

                      // Payment Method Section
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Payment Method',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            SizedBox(height: 10),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedPaymentMethodIndex =
                                      1; // Select Credit Card
                                  _isPaymentMethodSelected =
                                      true; // Reset payment selection flag
                                });
                              },
                              child: Container(
                                width: double.infinity,
                                height: 75,
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 44, 43, 43),
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image.asset(
                                        'assets/images/card.png',
                                        height: 45,
                                      ),
                                    ),
                                    const Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Credit Card',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18),
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            '3528 **** **** 1234',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 19.0),
                                      child: Container(
                                        width: 20,
                                        height: 20,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color:
                                              _selectedPaymentMethodIndex == 1
                                                  ? Colors.black
                                                  : Colors.white,
                                          border:
                                              Border.all(color: Colors.grey),
                                        ),
                                        child: _selectedPaymentMethodIndex == 1
                                            ? Center(
                                                child: Container(
                                                  width: 8,
                                                  height: 8,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              )
                                            : null,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedPaymentMethodIndex =
                                      2; // Select Cash on Delivery
                                  _isPaymentMethodSelected =
                                      true; // Reset payment selection flag
                                });
                              },
                              child: Container(
                                width: double.infinity,
                                height: 75,
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 156, 206, 247),
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Icon(
                                        Icons.local_shipping_outlined,
                                        color: Colors.black,
                                        size: 45,
                                      ),
                                    ),
                                    const Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Cash on Delivery',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w400),
                                          ),
                                          SizedBox(height: 0),
                                          Text(
                                            'Pay when you receive the order',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 19.0),
                                      child: Container(
                                        width: 20,
                                        height: 20,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color:
                                              _selectedPaymentMethodIndex == 2
                                                  ? Colors.black
                                                  : Colors.white,
                                          border:
                                              Border.all(color: Colors.grey),
                                        ),
                                        child: _selectedPaymentMethodIndex == 2
                                            ? Center(
                                                child: Container(
                                                  width: 8,
                                                  height: 8,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              )
                                            : null,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // Exclamation mark for unselected payment method
                            if (!_isPaymentMethodSelected)
                              Padding(
                                padding: const EdgeInsets.only(top: 5, left: 5),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.error,
                                      color: Colors.red,
                                      size: 20,
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      'Please select a payment method!',
                                      style: TextStyle(
                                          color: Colors.red, fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Divider(color: Colors.grey),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Total Price:',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400,
                                        color: Color.fromARGB(
                                            255, 139, 137, 137))),
                                Text('Rs. ${totalPrice.toStringAsFixed(1)}',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400,
                                        color: Color.fromARGB(
                                            255, 139, 137, 137))),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Tax (${(taxRate * 100).toInt()}%):',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400,
                                        color: Color.fromARGB(
                                            255, 139, 137, 137))),
                                Text('Rs. ${taxAmount.toStringAsFixed(1)}',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400,
                                        color: Color.fromARGB(
                                            255, 139, 137, 137))),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Delivery Charge:',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400,
                                        color: Color.fromARGB(
                                            255, 139, 137, 137))),
                                Text(
                                    'Rs. ${_deliveryCharge.toStringAsFixed(1)}',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400,
                                        color: Color.fromARGB(
                                            255, 139, 137, 137))),
                              ],
                            ),
                            Divider(color: Colors.grey),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Grand Total:',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                                Text('Rs. ${grandTotal.toStringAsFixed(1)}',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ],
                        ),
                      ),

                      SizedBox(
                        height: 30,
                      ),

                      Padding(
                        padding: const EdgeInsets.only(left: 25, bottom: 10),
                        child: ElevatedButton(
                          onPressed: _validateOrder,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: EdgeInsets.symmetric(
                                horizontal: 90, vertical: 10),
                          ),
                          child: Text(
                            'Order Now',
                            style: TextStyle(
                                fontSize: 30,
                                color: Colors.white,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),

                      SizedBox(
                        height: 0,
                      )
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}


