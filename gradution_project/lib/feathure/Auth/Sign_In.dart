import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'Log_ in.dart';
import '../home/home_page.dart';
import '../../core/widgets/custtom_Feild.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _confirmEmailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _confirmEmailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        'Welcome!',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 46,
                            fontFamily: 'Concert One'),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Create an account to join WeyNak',
                        style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                            fontFamily: 'Concert One'),
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        hintText: 'E-mail',
                        controller: _emailController,
                        isEditing: true,
                        prefixIcon: Icons.email,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        hintText: 'Confirm Email',
                        controller: _confirmEmailController,
                        isEditing: true,
                        prefixIcon: Icons.email,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (value != _emailController.text) {
                            return 'Emails do not match';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        hintText: 'Password',
                        controller: _passwordController,
                        isEditing: true,
                        prefixIcon: Icons.lock,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          } else if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        hintText: 'Confirm Password',
                        controller: _confirmPasswordController,
                        isEditing: true,
                        prefixIcon: Icons.lock,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your Password';
                          }
                          if (value != _passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              minimumSize: const Size(180, 51),
                              backgroundColor: const Color(0xFF30C3D4)),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              final email = _emailController.text;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text('Signing up with $email')),
                              );
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomePage()),
                              );
                            }
                          },
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already have an account?',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LogIn(),
                          ),
                        );
                      },
                      child: const Text(
                        'Log In',
                        style: TextStyle(
                          color: Color(0xFF30C3D4),
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        FontAwesomeIcons.facebook,
                        color: Colors.white,
                        size: 35,
                      ),
                    ),
                    const SizedBox(width: 15),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        FontAwesomeIcons.google,
                        color: Colors.white,
                        size: 35,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
