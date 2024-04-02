import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _errorMessage;

  // copied from hub page
  static const TextStyle textStyleH1 = TextStyle(
    fontSize: 50,
    fontWeight: FontWeight.normal,
    color: Color.fromARGB(255, 100, 50, 50),
  );
  static const TextStyle textStyleH2 = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
    color: Color.fromARGB(255, 170, 89, 89),
  );

  // cleanup resources from controllers
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'UWU',
          style: textStyleH2,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Register',
                style: textStyleH1,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter your email' : null,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
                obscureText: true,
                validator: (value) => value?.isEmpty ?? true
                    ? 'Please enter your password'
                    : null,
              ),
              const SizedBox(height: 24.0),
              if (_errorMessage != null)
                Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _handleRegister,
                child: const Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      try {
        final userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user?.uid)
            .set({'email': _emailController.text});

        Navigator.pushReplacementNamed(context, '/login');
      } on FirebaseAuthException catch (e) {
        setState(() {
          _errorMessage = e.code == 'weak-password'
              ? 'Password provided is too weak'
              : e.code == 'email-already-in-use'
                  ? 'Email already exists'
                  : 'Registration failed';
        });
      }
    }
  }
}
