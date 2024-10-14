import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  String? email, password, confirmPassword, deliveryAddress;

  // State variables for password visibility and loading state
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false; // Loading state

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _signUp() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true; // Show loading indicator
      });

      _formKey.currentState!.save();

      // Trim any whitespace from the passwords
      String trimmedPassword = password!.trim();
      String trimmedConfirmPassword = confirmPassword!.trim();

      // Validate passwords match after trimming
      if (trimmedPassword != trimmedConfirmPassword) {
        setState(() {
          _isLoading = false; // Hide loading indicator
        });

        // Show dialog for password mismatch
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Password Mismatch'),
              content: const Text('The passwords you entered do not match.'),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                ),
              ],
            );
          },
        );

        return; // Early exit if passwords don't match
      }

      try {
        await _auth.createUserWithEmailAndPassword(
          email: email!,
          password: trimmedPassword,
        );

        // Optionally: Store the delivery address or other user info in Firestore here

        // Simulate loading for 2 seconds
        await Future.delayed(const Duration(seconds: 2));

        // Navigate back to the login page
        Navigator.pop(context); // Close the sign-up page
      } on FirebaseAuthException catch (e) {
        setState(() {
          _isLoading = false; // Hide loading indicator
        });
        if (e.code == 'weak-password') {
          _showSnackbar('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          _showSnackbar('The account already exists for that email.');
        } else {
          _showSnackbar('An error occurred. Please try again.');
        }
      } catch (e) {
        setState(() {
          _isLoading = false; // Hide loading indicator
        });
        _showSnackbar('An unknown error occurred: $e');
      }
    }
  }

  // Function to show Snackbar
  void _showSnackbar(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'FOODGO',
          style: TextStyle(
              fontSize: 35, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.start, // Aligns items at the start (top)
            children: [
              const SizedBox(height: 20), // Space from the top
              // Guiding text
              Text(
                'Create your account to start using our services.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 0),
              Text(
                'Fill in the details below to sign up.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 30), // Adjust space before the form
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Email TextField
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(color: Colors.black),
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                              color:
                                  Colors.grey), // Change to grey when focused
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        email = value;
                      },
                    ),
                    const SizedBox(height: 16),
                    // Password TextField
                    TextFormField(
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(color: Colors.black),
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                              color:
                                  Colors.grey), // Change to grey when focused
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        password = value;
                      },
                    ),
                    const SizedBox(height: 16),
                    // Confirm Password TextField
                    TextFormField(
                      obscureText: !_isConfirmPasswordVisible,
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        labelStyle: TextStyle(color: Colors.black),
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                              color:
                                  Colors.grey), // Change to grey when focused
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isConfirmPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            setState(() {
                              _isConfirmPasswordVisible =
                                  !_isConfirmPasswordVisible;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        confirmPassword = value;
                      },
                    ),

                    const SizedBox(height: 20),
                    // Sign Up Button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      onPressed: _isLoading ? null : _signUp,
                      child: _isLoading
                          ? SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'Sign Up',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 23),
                            ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
