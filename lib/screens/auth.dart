import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire/screens/home.dart';
import 'package:lottie/lottie.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthpageState();
}

class _AuthpageState extends State<AuthPage> {
  int _currentSegment = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        automaticallyImplyLeading: true,
        elevation: 0.0,
        backgroundColor: Colors.blueGrey[50],
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Sign Up / Sign In',
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w300),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Lottie.asset(
              'asset/hello.json',
              height: 400,
              repeat: true,
              reverse: false,
              animate: true,
            ),
            Column(
              children: [
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: MediaQuery.of(context).size.height * 0.05,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: CupertinoSlidingSegmentedControl(
                      thumbColor: Color.fromRGBO(0, 137, 133, 1),
                      backgroundColor: Colors.white,
                      children: const {
                        0: Text("Sign Up",
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w300)),
                        1: Text("Sign In",
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w300)),
                      },
                      onValueChanged: (int? val) {
                        if (val != null) {
                          setState(() {
                            _currentSegment = val;
                          });
                        }
                      },
                      groupValue: _currentSegment,
                    ),
                  ),
                ),
              ],
            ),
            _currentSegment == 0
                ? SignUpWidget()
                : _currentSegment == 1
                    ? SignInWidget()
                    : Container(),
          ],
        ),
      ),
    );
  }
}

class SignInWidget extends StatefulWidget {
  @override
  State<SignInWidget> createState() => _SignInWidgetState();
}

class _SignInWidgetState extends State<SignInWidget> {
  @override
  // ignore: override_on_non_overriding_member
  final TextEditingController _emailcontroller = TextEditingController();

  final TextEditingController _passwordcontroller = TextEditingController();

  Future<void> _signInWithEmailandPassWord(BuildContext context) async {
    try {
      // ignore: unused_local_variable
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: _emailcontroller.text, password: _passwordcontroller.text);
      Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: TextField(
              controller: _emailcontroller,
              cursorColor: Color.fromRGBO(
                70,
                177,
                123,
                1,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                labelText: 'Email',
                labelStyle: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w300),
                prefixIcon: Icon(
                  Icons.person,
                ),
              ),
            ),
          ),
          SizedBox(height: 16),
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: TextField(
              controller: _passwordcontroller,
              cursorColor: Color.fromRGBO(
                70,
                177,
                123,
                1,
              ),
              obscureText: true,
              decoration: InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                labelText: 'Password',
                labelStyle: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w300),
                prefixIcon: Icon(
                  Icons.lock,
                ),
              ),
            ),
          ),
          SizedBox(height: 24),
          InkWell(
            onTap: () {
              _signInWithEmailandPassWord(context);
            },
            child: Container(
              width: MediaQuery.of(context).size.width * 0.3,
              height: MediaQuery.of(context).size.height * 0.05,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  'Sign In',
                  style: TextStyle(fontFamily: 'Poppins', color: Colors.black),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class SignUpWidget extends StatefulWidget {
  @override
  State<SignUpWidget> createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
  final TextEditingController _confirmpasswordcontroller =
      TextEditingController();
  Future<void> _signUpWithEmailandPassWord(BuildContext context) async {
    try {
      // ignore: unused_local_variable
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _emailcontroller.text, password: _passwordcontroller.text);
      Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: TextField(
              controller: _emailcontroller,
              cursorColor: Color.fromRGBO(
                70,
                177,
                123,
                1,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                labelText: 'Email',
                labelStyle:
                    TextStyle(color: Colors.black, fontFamily: 'Poppins'),
                prefixIcon: Icon(
                  Icons.person,
                ),
              ),
            ),
          ),
          SizedBox(height: 16),
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: TextField(
              controller: _passwordcontroller,
              cursorColor: Color.fromRGBO(
                70,
                177,
                123,
                1,
              ),
              obscureText: true,
              decoration: InputDecoration(
                border: InputBorder.none,
                labelText: 'Password',
                labelStyle:
                    TextStyle(fontFamily: 'Poppins', color: Colors.black),
                prefixIcon: Icon(
                  Icons.lock,
                ),
              ),
            ),
          ),
          SizedBox(height: 16),
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: TextField(
              controller: _confirmpasswordcontroller,
              cursorColor: Color.fromRGBO(
                70,
                177,
                123,
                1,
              ),
              obscureText: true,
              decoration: InputDecoration(
                border: InputBorder.none,
                labelText: 'Confirm Password',
                labelStyle:
                    TextStyle(fontFamily: 'Poppins', color: Colors.black),
                prefixIcon: Icon(
                  Icons.lock,
                ),
              ),
            ),
          ),
          SizedBox(height: 24),
          InkWell(
            onTap: () {
              _signUpWithEmailandPassWord(context);
            },
            child: Container(
              width: MediaQuery.of(context).size.width * 0.3,
              height: MediaQuery.of(context).size.height * 0.05,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  'Sign Up',
                  style: TextStyle(fontFamily: 'Poppins', color: Colors.black),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
