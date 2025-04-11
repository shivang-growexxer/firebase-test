import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_exam_app/ui/auth/login_screen.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isVisible = false;
  bool loading = false;

  void register() {
    setState(() {
      loading = true;
    });
    _auth
        .createUserWithEmailAndPassword(
          email: emailController.text.toString(),
          password: passwordController.text.toString(),
        )
        .then((value) {
          setState(() {
            loading = false;
          });
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
            (route) => false,
          );
        })
        .onError((error, stackTrace) {
          setState(() {
            loading = false;
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 25.0, right: 25),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  fillColor: Colors.blueAccent,
                  hintText: 'Enter Email',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Email is required';
                  } else if (value.contains('@') && value.contains('.')) {
                    return null;
                  } else {
                    return 'Invalid email format';
                  }
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: passwordController,
                obscureText: isVisible ? true : false,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      isVisible ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        isVisible = !isVisible;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Password is required';
                  } else if (value.length > 8) {
                    return null;
                  } else {
                    return 'Password must be at least 8 characters';
                  }
                },
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                        (route) => false,
                      );
                    },
                    child: Text(
                      "Already have an account, Login",
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    register();
                  }
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child:
                        loading
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text(
                              "Register",
                              style: TextStyle(color: Colors.white),
                            ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
