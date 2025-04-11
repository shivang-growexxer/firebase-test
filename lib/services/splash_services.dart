import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_exam_app/ui/auth/login_screen.dart';
import 'package:firebase_exam_app/ui/users/user_list.dart';
import 'package:flutter/material.dart';

class SplashServices {
  void isLogin(BuildContext context) {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    if (user != null) {
      Timer(
        Duration(seconds: 3),
        () => Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => UserList()),
          (route) => false,
        ),
      );
    } else {
      Timer(
        Duration(seconds: 3),
        () => Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
          (route) => false,
        ),
      );
    }
  }
}
