import 'package:firebase_exam_app/bloc/user_bloc.dart';
import 'package:firebase_exam_app/bloc/user_event.dart';
import 'package:firebase_exam_app/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpdateUserScreen extends StatefulWidget {
  final String userId;
  final User user;

  const UpdateUserScreen({super.key, required this.userId, required this.user});

  @override
  State<UpdateUserScreen> createState() => _UpdateUserScreenState();
}

class _UpdateUserScreenState extends State<UpdateUserScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _numberController;
  late final TextEditingController _ageController;

  @override
  void initState() {
    _firstNameController = TextEditingController(text: widget.user.firstName);
    _lastNameController = TextEditingController(text: widget.user.lastName);
    _emailController = TextEditingController(text: widget.user.email);
    _numberController = TextEditingController(text: widget.user.number);
    _ageController = TextEditingController(text: widget.user.age.toString());
    super.initState();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final updatedUser = User(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        email: _emailController.text.trim(),
        number: _numberController.text.trim(),
        age: int.parse(_ageController.text.trim()),
      );

      context.read<UserBloc>().add(UpdateUser(widget.userId, updatedUser));
      Navigator.pop(context); // Return to list
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        title: const Text("Update User"),
        backgroundColor: Colors.blueGrey[800],
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField(_firstNameController, 'First Name'),
              _buildTextField(_lastNameController, 'Last Name'),
              _buildTextField(
                _emailController,
                'Email',
                type: TextInputType.emailAddress,
              ),
              _buildTextField(
                _numberController,
                'Phone Number',
                type: TextInputType.phone,
              ),
              _buildTextField(
                _ageController,
                'Age',
                type: TextInputType.number,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  textStyle: const TextStyle(fontSize: 16),
                ),
                child: const Text("Update User"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    TextInputType type = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextFormField(
        controller: controller,
        keyboardType: type,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'This field is required';
          }
          if (label == 'Email' &&
              !RegExp(
                r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$',
              ).hasMatch(value.trim())) {
            return 'Enter a valid email address';
          }
          if (label == 'Phone Number' &&
              !RegExp(r'^\d{10}$').hasMatch(value.trim())) {
            return 'Enter a valid 10-digit phone number';
          }
          if (label == 'Age') {
            final age = int.tryParse(value.trim());
            if (age == null || age <= 0 || age > 120) {
              return 'Enter a valid age (1-120)';
            }
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.blueGrey[900]),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blueGrey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blueGrey.shade400),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.green.shade700, width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
