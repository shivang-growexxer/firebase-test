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
      appBar: AppBar(title: const Text("Update User")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField(_firstNameController, 'First Name'),
              _buildTextField(_lastNameController, 'Last Name'),
              _buildTextField(_emailController, 'Email', type: TextInputType.emailAddress),
              _buildTextField(_numberController, 'Phone Number'),
              _buildTextField(_ageController, 'Age', type: TextInputType.number),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: _submit, child: const Text("Update User")),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {TextInputType type = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextFormField(
        controller: controller,
        keyboardType: type,
        validator: (value) => value == null || value.isEmpty ? 'Required' : null,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
