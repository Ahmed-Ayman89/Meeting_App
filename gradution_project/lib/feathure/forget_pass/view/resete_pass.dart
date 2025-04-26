import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradution_project/core/utils/App_color.dart';
import 'package:gradution_project/core/widgets/custtom_Feild.dart';

import '../../LogIn/view/Log_ in.dart';
import '../manager/reset_password_cubit.dart';
import '../manager/reset_password_state.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;
  final String token;

  const ResetPasswordScreen(
      {super.key, required this.email, required this.token});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ResetPasswordCubit(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Center(
                      child: Column(
                        children: const [
                          Icon(Icons.lock_reset,
                              size: 80, color: AppColor.white),
                          SizedBox(height: 10),
                          Text(
                            'Reset Password',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 36,
                              fontFamily: 'Concert One',
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Enter your new password below',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                              fontFamily: 'Concert One',
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 50),

                    // Password Field
                    CustomTextField(
                      hintText: 'New Password',
                      controller: _passwordController,
                      isEditing: true,
                      prefixIcon: Icons.lock,
                      validator: (value) {
                        if (value == null || value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Confirm Password Field
                    CustomTextField(
                      hintText: 'Confirm Password',
                      controller: _confirmController,
                      isEditing: true,
                      prefixIcon: Icons.lock_outline,
                      validator: (value) {
                        if (value != _passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),

                    // Bloc Button
                    BlocConsumer<ResetPasswordCubit, ResetPasswordState>(
                      listener: (context, state) {
                        if (state is ResetPasswordSuccess) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                state.model.message,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              backgroundColor: Colors.green,
                              behavior: SnackBarBehavior.floating,
                              margin: const EdgeInsets.all(20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              duration: const Duration(seconds: 3),
                            ),
                          );
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (_) => const LogIn()),
                            (route) => false,
                          );
                        } else if (state is ResetPasswordError) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(state.error)),
                          );
                        }
                      },
                      builder: (context, state) {
                        return Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColor.lightblue,
                              minimumSize: const Size(160, 51),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: state is ResetPasswordLoading
                                ? null
                                : () {
                                    if (_formKey.currentState!.validate()) {
                                      ResetPasswordCubit.get(context)
                                          .resetPassword(
                                        email: widget.email,
                                        password:
                                            _passwordController.text.trim(),
                                        confirmPassword:
                                            _confirmController.text.trim(),
                                        otp: widget.token,
                                      );
                                    }
                                  },
                            child: state is ResetPasswordLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white)
                                : const Text(
                                    'Reset Password',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
