// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:foodgo/home.dart';
// import 'package:foodgo/signup.dart';

// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});

//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final _formKey = GlobalKey<FormState>();
//   String? email, password;
//   bool _isPasswordVisible = false; // State variable for password visibility
//   bool _isLoading = false; // Loading state variable

//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   Future<void> _login() async {
//     if (_formKey.currentState!.validate()) {
//       _formKey.currentState!.save();
//       setState(() {
//         _isLoading = true; // Start loading
//       });

//       try {
//         await _auth.signInWithEmailAndPassword(
//           email: email!,
//           password: password!,
//         );

//         // Navigate to the Home Page on successful login
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => homepage()), // Ensure HomePage is correctly named
//         );
//       } on FirebaseAuthException catch (e) {
//         if (e.code == 'user-not-found') {
//           _showErrorDialog('No user found for that email. Please create your account.');
//         } else if (e.code == 'wrong-password') {
//           _showErrorDialog('Incorrect password provided. Please try again.');
//         } else {
//           _showErrorDialog('An unexpected error occurred.');
//         }
//       } catch (e) {
//         _showErrorDialog('An unexpected error occurred.');
//         print(e);
//       } finally {
//         setState(() {
//           _isLoading = false; // Stop loading
//         });
//       }
//     }
//   }

//   void _showErrorDialog(String message) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Error'),
//           content: Text(message),
//           actions: <Widget>[
//             TextButton(
//               child: const Text('OK'),
//               onPressed: () {
//                 Navigator.of(context).pop(); // Close the dialog
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'FOODGO',
//           style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold, color: Colors.black),
//         ),
//         centerTitle: true,
//         backgroundColor: Colors.red,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: SingleChildScrollView(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 // Guiding text
//                 SizedBox(height: 30),
//                 Text(
//                   'Welcome Back!',
//                   style: TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.red,
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 Text(
//                   'Please enter your email and password to log in.\n'
//                   'If you do not have an account, please sign up.',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     fontSize: 16,
//                     color: Colors.grey,
//                   ),
//                 ),
//                 const SizedBox(height: 40),
//                 TextFormField(
//                   decoration: InputDecoration(
//                     labelText: 'Email',
//                     labelStyle: TextStyle(color: Colors.black),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12), // Rounded corners
//                       borderSide: BorderSide.none, // No border when not focused
//                     ),
//                     enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       borderSide: BorderSide(color: Colors.transparent), // No border when enabled
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       borderSide: BorderSide(color: const Color.fromARGB(255, 187, 185, 185)), // Grey border when focused
//                     ),
//                     filled: true,
//                     fillColor: Colors.white,
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter your email';
//                     }
//                     if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
//                       return 'Please enter a valid email';
//                     }
//                     return null;
//                   },
//                   onSaved: (value) {
//                     email = value;
//                   },
//                 ),
//                 const SizedBox(height: 16),
//                 TextFormField(
//                   obscureText: !_isPasswordVisible, // Toggle password visibility
//                   decoration: InputDecoration(
//                     labelText: 'Password',
//                     labelStyle: TextStyle(color: Colors.black),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12), // Rounded corners
//                       borderSide: BorderSide.none, // No border when not focused
//                     ),
//                     enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       borderSide: BorderSide(color: Colors.transparent), // No border when enabled
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       borderSide: BorderSide(color: const Color.fromARGB(255, 187, 185, 185)), // Grey border when focused
//                     ),
//                     filled: true,
//                     fillColor: Colors.white,
//                     suffixIcon: IconButton(
//                       icon: Icon(
//                         _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
//                         color: Colors.black,
//                       ),
//                       onPressed: () {
//                         setState(() {
//                           _isPasswordVisible = !_isPasswordVisible; // Toggle visibility
//                         });
//                       },
//                     ),
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter your password';
//                     }
//                     return null;
//                   },
//                   onSaved: (value) {
//                     password = value;
//                   },
//                 ),
//                 const SizedBox(height: 20),
//                 ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.red,
//                   ),
//                   onPressed: _isLoading ? null : _login, // Disable button if loading
//                   child: _isLoading
//                       ? SizedBox(
//                           width: 24,
//                           height: 24,
//                           child: CircularProgressIndicator(
//                             color: Colors.white,
//                             strokeWidth: 2,
//                           ),
//                         )
//                       : const Text(
//                           'Login',
//                           style: TextStyle(color: Colors.white, fontSize: 23),
//                         ),
//                 ),
//                 const SizedBox(height: 20),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Text(
//                       'Don’t have an account? ',
//                       style: TextStyle(
//                         color: Colors.black,
//                         fontSize: 16,
//                       ),
//                     ),
//                     GestureDetector(
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(builder: (context) => SignUpPage()),
//                         );
//                       },
//                       child: Text(
//                         'Sign Up',
//                         style: TextStyle(
//                           color: Colors.blue,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }










import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodgo/signup.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String? email, password;
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });

      try {
        // Check for null values before login
        if (email == null || password == null) {
          _showErrorDialog('Email or Password cannot be null');
          return;
        }

        await _auth.signInWithEmailAndPassword(
          email: email!,
          password: password!,
        );

      } on FirebaseAuthException catch (e) {
        _showErrorDialog(e.message ?? 'An error occurred. Please try again.');
      } catch (e) {
        _showErrorDialog('An unexpected error occurred. Please try again.');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'FOODGO',
          style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 30),
                Text(
                  'WELCOME!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Please enter your email and password to log in.\n'
                  'If you do not have an account, please sign up.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 40),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: const Color.fromARGB(255, 187, 185, 185)),
                    ),
                    filled: true,
                    fillColor: Colors.white,
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
                TextFormField(
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: const Color.fromARGB(255, 187, 185, 185)),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
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
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  onPressed: _isLoading ? null : _login,
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
                          'Login',
                          style: TextStyle(color: Colors.white, fontSize: 23),
                        ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Don’t have an account? ',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignUpPage()),
                        );
                      },
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
