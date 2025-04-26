import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradution_project/core/utils/App_color.dart';
import 'package:gradution_project/core/widgets/custtom_Feild.dart';
import '../manager/otp_cubit.dart';
import '../manager/otp_state.dart';
import 'resete_pass.dart';

class EnterOtpScreen extends StatelessWidget {
  final String email;

  const EnterOtpScreen({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    final otpController = TextEditingController();

    return BlocProvider(
      create: (_) => OtpCubit(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Center(
                    child: Column(
                      children: const [
                        Icon(Icons.email, size: 80, color: AppColor.white),
                        SizedBox(height: 10),
                        Text(
                          'Enter OTP',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                            fontFamily: 'Concert One',
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Please enter the OTP sent to your email',
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
                  const SizedBox(height: 30),
                  BlocConsumer<OtpCubit, OtpState>(
                    listener: (context, state) {
                      if (state is OtpSuccess) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ResetPasswordScreen(
                              email: email,
                              token: otpController.text.trim(),
                            ),
                          ),
                        );
                      } else if (state is OtpError) {
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
                          ),
                          onPressed: state is OtpLoading
                              ? null
                              : () {
                                  if (otpController.text.isNotEmpty) {
                                    OtpCubit.get(context).verifyOtp(
                                      email: email,
                                      otp: otpController.text.trim(),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: const Text(
                                          "Enter the OTP",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.white,
                                          ),
                                        ),
                                        backgroundColor: AppColor.lightblue,
                                        behavior: SnackBarBehavior.floating,
                                        margin: const EdgeInsets.all(16),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        duration: const Duration(seconds: 2),
                                      ),
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
