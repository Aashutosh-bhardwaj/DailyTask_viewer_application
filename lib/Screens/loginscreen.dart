
import 'package:flutter/material.dart';
import 'package:pharmafly/Screens/services/api_service.dart';
import 'package:pharmafly/Screens/signup.dart';

import 'signupscreen.dart';
import 'homescreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isPasswordVisible = false;
  bool isLoading = false;

  get child => null;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // LOGIN FUNCTION
  Future<void> loginUser() async {

    String email = emailController.text.trim();
    String password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter email and password"),
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {

      final result = await ApiService.login(
        email,
        password,
      );

      if (!mounted) return;

      String token = result['access_token'];

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Login Successful!"),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(token: token),
        ),
      );

    } catch (e) {

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ),
      );

    } finally {

      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }


  // OPEN SIGNUP SCREEN
  Future<void> openSignup() async {

    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (context) => const SignupScreen(),
      ),
    );

    if (!mounted) return;

    if (result != null) {
      emailController.text = result;
      passwordController.clear();
    }
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,

      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(25),

          child: Column(
            children: [

              const Icon(
                Icons.visibility,
                size: 80,
                color: Colors.blue,
              ),

              const SizedBox(height: 20),

              const Text(
                "Task Viewer",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                "Welcome Back! Login to Continue",
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 35),

              // EMAIL FIELD

              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,

                decoration: InputDecoration(
                  hintText: "Enter your Gmail",
                  prefixIcon: const Icon(Icons.email),

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // PASSWORD FIELD

              TextField(
                controller: passwordController,
                obscureText: !isPasswordVisible,

                decoration: InputDecoration(
                  hintText: "Enter your Password",
                  prefixIcon: const Icon(Icons.lock),

                  suffixIcon: IconButton(
                    icon: Icon(
                      isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),

                    onPressed: () {
                      setState(() {
                        isPasswordVisible =
                        !isPasswordVisible;
                      });
                    },
                  ),

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // LOGIN BUTTON

              SizedBox(
                width: double.infinity,
                height: 55,

                child: ElevatedButton(

                  onPressed: isLoading ? null : loginUser,

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),

                  child: isLoading

                      ? const CircularProgressIndicator(
                    color: Colors.white,
                  )

                      : const Text(
                    "LOGIN",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // SIGNUP BUTTON

              Row(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [

                  const Text(
                    "Don't have an account?",
                  ),

          ElevatedButton(
            onPressed: () async {

              print("SIGNUP BUTTON CLICKED");

              String email = emailController.text.trim();
              String password = passwordController.text.trim();

              // Empty field validation
              if (email.isEmpty || password.isEmpty) {

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Please enter email and password")),
                );

                return;
              }

              // Password validation
              if (password.length < 8) {

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Password must be at least 8 characters")),
                );

                return;
              }

              try {

                final result = await ApiService.signup(
                  email,
                  password,
                );

                print("SIGNUP SUCCESS: $result");

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Signup Successful")),
                );

              } catch (e) {

                print("SIGNUP FAILED: $e");

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(e.toString())),
                );
              }
            },
            child: const Text(
                      "Sign Up",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ),

                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
}
