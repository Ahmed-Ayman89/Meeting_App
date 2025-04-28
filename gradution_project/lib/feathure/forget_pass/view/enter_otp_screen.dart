import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradution_project/core/theme/theme_ext.dart';
import 'package:gradution_project/core/widgets/custtom_Feild.dart';
import 'package:gradution_project/feathure/LogIn/view/Log_%20in.dart';
import '../../../core/theme/theme_cubit.dart';
import '../manager/otp_cubit.dart';
import '../manager/otp_state.dart';

class EnterOtpScreen extends StatelessWidget {
  final String email;

  const EnterOtpScreen({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    final otpController = TextEditingController();
    final newPasswordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    return BlocProvider(
      create: (_) => OtpCubit(),
      child: Scaffold(
        backgroundColor: context.backgroundColor,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: context.backgroundColor,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back, color: context.textColor),
          ),
          actions: [
            IconButton(
              icon: Icon(
                context.isDark ? Icons.dark_mode : Icons.light_mode,
                color: context.textColor,
              ),
              onPressed: () {
                context.read<ThemeCubit>().toggleTheme();
              },
            ),
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Center(
                    child: Column(
                      children: [
                        Icon(Icons.email, size: 80, color: context.textColor),
                        SizedBox(height: 10),
                        Text(
                          'Enter OTP',
                          style: TextStyle(
                            color: context.textColor,
                            fontSize: 36,
                            fontFamily: 'Concert One',
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Please enter the OTP and your new password',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: context.textColor,
                            fontSize: 16,
                            fontFamily: 'Concert One',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 50),
                  CustomTextField(
                    hintText: 'OTP Code',
                    controller: otpController,
                    isEditing: true,
                    prefixIcon: Icons.lock_outline,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the OTP';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    hintText: 'New Password',
                    controller: newPasswordController,
                    isEditing: true,
                    prefixIcon: Icons.lock,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your new password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),
                  BlocConsumer<OtpCubit, OtpState>(
                    listener: (context, state) {
                      if (state is OtpSuccess) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text(
                              'Password changed successfully! Please login.',
                              style: TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Colors.green,
                            behavior: SnackBarBehavior.floating,
                            margin: const EdgeInsets.all(16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                        Future.delayed(const Duration(seconds: 2), () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (_) => LogIn()),
                            (route) => false,
                          );
                        });
                      } else if (state is OtpError) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              state.error,
                              style: const TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Colors.redAccent,
                            behavior: SnackBarBehavior.floating,
                            margin: const EdgeInsets.all(16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                    builder: (context, state) {
                      return Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF30C3D4),
                            minimumSize: const Size(160, 51),
                          ),
                          onPressed: state is OtpLoading
                              ? null
                              : () {
                                  if (formKey.currentState!.validate()) {
                                    OtpCubit.get(context).verifyOtp(
                                      email: email,
                                      otp: otpController.text.trim(),
                                      newPassword:
                                          newPasswordController.text.trim(),
                                    );
                                  }
                                },
                          child: state is OtpLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text(
                                  'Verify & Continue',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
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
    );
  }
}
