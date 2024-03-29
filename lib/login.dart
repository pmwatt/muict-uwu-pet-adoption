import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'register.dart';
import 'hub.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String message = 'Enter your credentials';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text(message),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter your email' : null,
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter your password' : null,
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      final userCredential = await FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                        email: _emailController.text,
                        password: _passwordController.text,
                      );
                      // Navigate to home page or handle successful login
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) => Hub()));
                    } on FirebaseAuthException catch (e) {
                      setState(() {
                        message = 'Invalid login';
                      });
                    }
                  }
                },
                child: Text('Login'),
              ),
              TextButton(
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => RegisterPage())),
                child: Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
