import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({
    super.key,
    required this.textStyleH1,
    required this.textStyleH2,
  });

  final TextStyle textStyleH1;
  final TextStyle textStyleH2;
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmNewPasswordController = TextEditingController();
  String _message = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Change your password',
                style: widget.textStyleH1,
              ),
              Text(
                _message,
                style: const TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _currentPasswordController,
                decoration: const InputDecoration(
                  labelText: 'Current Password',
                ),
                obscureText: true,
                validator: (value) => value!.isEmpty
                    ? 'Please enter your current password'
                    : null,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _newPasswordController,
                decoration: const InputDecoration(
                  labelText: 'New Password',
                ),
                obscureText: true,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a new password' : null,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _confirmNewPasswordController,
                decoration: const InputDecoration(
                  labelText: 'Confirm New Password',
                ),
                obscureText: true,
                validator: (value) => value != _newPasswordController.text
                    ? 'Passwords do not match'
                    : null,
              ),
              const SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: _changePassword,
                child: const Text('Change Password'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _changePassword() async {
    if (_formKey.currentState!.validate()) {
      // reference:
      // https://stackoverflow.com/questions/52293129/how-to-change-password-using-firebase-in-flutter
      try {
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          final credential = EmailAuthProvider.credential(
            email: user.email!,
            password: _currentPasswordController.text,
          );

          await user.reauthenticateWithCredential(credential);
          await user.updatePassword(_newPasswordController.text);

          setState(() {
            _message = 'Password changed successfully';
          });

          // Clear the text fields
          _currentPasswordController.clear();
          _newPasswordController.clear();
          _confirmNewPasswordController.clear();
        }
      } on FirebaseAuthException catch (e) {
        setState(() {
          _message = e.message!;
        });
      }
    }
  }
}
