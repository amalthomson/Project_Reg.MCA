import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:farmconnect/features/user_auth/firebase_auth_implementation/firebase_auth_services.dart';
import 'package:farmconnect/features/user_auth/presentation/pages/login_page.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  // final FirebaseAuthService _auth = FirebaseAuthService();

  final _formKey = GlobalKey<FormState>();

  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phonecontroller = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  String email = '', phone = '', username = '', password = '', userrole = '';

  final dbRef = FirebaseDatabase.instance.ref().child('users');
  CollectionReference collectionReference = FirebaseFirestore.instance.collection('users');
  final _auth = FirebaseAuth.instance;

  // void register() async {
  //   try {
  //     final newUser = _auth.createUserWithEmailAndPassword(
  //         email: email, password: password)
  //         .then((value) {
  //       FirebaseFirestore.instance.collection('users').doc(value.user?.uid).set(
  //           {"email": value.user?.email,
  //             "name": username,
  //             "phone": phone,
  //             "role": userrole,});
  //     },
  //     );
  //     if  (newUser != null) {
  //       Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context)=>LoginPage()));
  //     }
  //   } catch (e) {
  //     print (e);
  //     SnackBar(
  //       content: Text("Username Already exists"),
  //       backgroundColor: Colors.teal,
  //     );
  //     Fluttertoast.showToast(msg: e.toString());
  //     print(e);
  //
  //   }
  // }

  void register() async {
    try {
      print("Starting registration...");

      final newUser = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      print("User created successfully!");

      final userId = newUser.user?.uid;
      print("User ID: $userId");

      final userData = {
        "email": email,
        "name": username,
        "phone": phone,
        "role": userrole,
      };

      await FirebaseFirestore.instance.collection('users').doc(userId).set(userData);
      print("User data saved to Firestore!");

      // ... Other code ...

      if (newUser != null) {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
        );
      }
    } catch (e) {
      print("Error occurred during registration: $e");
      // ... Handle errors ...
    }
  }


  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,

      appBar: AppBar(
        title: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "   FarmConnect",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Container(

        child: SingleChildScrollView(

          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Text(
                    //   "Sign Up with FarmConnect",
                    //   style: TextStyle(
                    //     fontSize: 40,
                    //     fontWeight: FontWeight.bold,
                    //     color: Colors.white,
                    //   ),
                    // ),
                    SizedBox(
                      height: 20,
                    ),
                    Form(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction, // Enable auto-validation
                      child: Column(
                        children: [
                          DropdownButtonFormField(

                            decoration: InputDecoration(
                              labelText: 'SignUp as',
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.9),
                              border: OutlineInputBorder(  // Optional: You can specify a custom border
                                borderRadius: BorderRadius.circular(1.0),
                                borderSide: BorderSide(),
                              ),
                            ),
                            validator: (value) {
                              if (value == null) {
                                return "Select One";
                              }
                            },
                            value: userrole.isNotEmpty ? userrole : null,
                            items: <String>['Customer', 'Farmer']
                                .map<DropdownMenuItem<String>>((String value)
                            {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),);
                            }).toList(),
                            onChanged: (value){
                              setState(() {
                                userrole = value.toString();
                              });
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: _usernameController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.9),
                              labelText: 'Name',
                              hintText: 'Enter your Name',
                            ),
                            onSaved: (value) {
                              username = value ?? '';
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Name is required';
                              }
                              // You can add more validation logic for name here if needed
                              if (!RegExp(r'^[a-zA-Z\s\-\’]+$')
                                  .hasMatch(value)) {
                                return ("Please enter a valid email");
                              } else

                              return null;
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.9),
                              labelText: 'Email',
                              hintText: 'Enter your email',
                            ),
                            onSaved: (value) {
                              email = value ?? '';
                            },
                            validator: (value) {
                              if (value!.length == 0) {
                                return "Email cannot be empty";
                              }
                              if (!RegExp(r"^([A-Za-z0-9_\-\.])+\@([A-Za-z0-9_\-\.])+\.([A-Za-z]{2,4})$")
                                  .hasMatch(value)) {
                                return ("Please enter a valid email");
                              } else {
                                return null;
                              }
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: _phonecontroller,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.9),
                              labelText: 'Phone Number',
                              hintText: 'Enter your Phone Number',
                            ),
                            onSaved: (value) {
                              phone = value ?? '';
                            },
                            validator: (val) {
                              if (val!.length == 0) {
                                return "Phone Number cannot be empty";
                              }
                              if(!(val.isEmpty) && !RegExp(r"^[0-9]{10}$").hasMatch(val)){
                                return "Enter a valid phone number";
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.9),
                              labelText: 'Password',
                              hintText: 'Enter your Password',
                            ),
                            onSaved: (value) {
                              password = value ?? '';
                            },
                            validator: (value) {
                              if (!_isValidPassword(value!)) {
                                return 'Password must be at least 8 characters with at least one number and a special character.';
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: _confirmPasswordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.9),
                              labelText: 'Confirm Password',
                              hintText: 'Reenter Password',
                            ),
                            validator: (value) {
                              if (value != _passwordController.text) {
                                return 'Passwords do not match';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    GestureDetector(
                      onTap: register,
                      // onTap: _signUp,
                      child: Container(
                        width: double.infinity,
                        height: 45,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            "Sign Up",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Already have an account?",
                            style: TextStyle(color: Colors.white)),
                        SizedBox(
                          width: 5,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginPage(),
                              ),
                                  (route) => false,
                            );
                          },
                          child: Text("Login",
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  // void _signUp() async {
  //   String username = _usernameController.text;
  //   String email = _emailController.text;
  //   String password = _passwordController.text;
  //   String confirmPassword = _confirmPasswordController.text;
  //
  //   // Validate the password
  //   if (!_isValidPassword(password)) {
  //     _showPasswordErrorDialog(
  //       "Password must be at least 8 characters with at least one number and a special character.",
  //     );
  //     return;
  //   }
  //
  //   // Check if passwords match
  //   if (password != confirmPassword) {
  //     _showPasswordErrorDialog("Passwords do not match.");
  //     return;
  //   }
  //
  //   User? user = await _auth.signUpWithEmailAndPassword(email, password);
  //
  //   if (user != null) {
  //     print("User is successfully created");
  //     Navigator.pushNamed(context, "/home");
  //   } else {
  //     print("Some error happened");
  //   }
  // }

  bool _isValidPassword(String password) {
    final minLength = 8;
    final hasNumber = RegExp(r'[0-9]').hasMatch(password);
    final hasSpecialChar =
    RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password);

    return password.length >= minLength && hasNumber && hasSpecialChar;
  }

  void _showPasswordErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Invalid Password"),
          content: Text(errorMessage),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }
}