// ignore_for_file: dead_code

import 'dart:ui';

import 'package:firebase_exam_app/bloc/user_bloc.dart';
import 'package:firebase_exam_app/ui/repository/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_exam_app/firebase_options.dart';
import 'package:firebase_exam_app/ui/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );

  const fatalError = true;
  FlutterError.onError = (errorDetails) {
    if (fatalError) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    } else {
      FirebaseCrashlytics.instance.recordFlutterError(errorDetails);
    }
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    if (fatalError) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    } else {
      FirebaseCrashlytics.instance.recordError(error, stack);
    }
    return true;
  };

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final UserRepository userRepository = UserRepository();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<UserBloc>(create: (context) => UserBloc(userRepository)),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
