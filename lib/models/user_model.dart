import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String firstName;
  final String lastName;
  final String email;
  final int age;
  final String number;

  User({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.age,
    required this.number,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      age: json['age'] ?? 0,
      number: json['number'] ?? '',
    );
  }

  factory User.fromDocumentSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return User.fromJson(data);
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'age': age,
      'number': number,
    };
  }
}
