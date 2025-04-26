import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradution_project/core/widgets/custtom_Feild.dart';
import 'package:gradution_project/feathure/forget_pass/view/enter_otp_screen.dart';
import '../../../core/utils/App_color.dart';
import '../manager/forget_cubit.dart';
import '../manager/forget_state.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ForgotPasswordCubit(),
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
                        Center(
                          child: Column(
                            children: const [
                              Icon(Icons.lock_reset,
                                  size: 80, color: AppColor.white),
                              SizedBox(height: 10),
                              Text(
                                'Forgot Password',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 36,
                                  fontFamily: 'Concert One',
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Enter your email to reset your password',
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
                          hintText: 'E-mail',
                          controller: _emailController,
                          isEditing: true,
                          prefixIcon: Icons.email,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!value.contains('@') || !value.contains('.')) {
                              return 'Enter a valid email address';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 30),
                        BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
                          listener: (context, state) {
                            if (state is ForgotPasswordSuccess) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    state.model.message,
                                    style: const TextStyle(
                                      color: AppColor.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  ),
                                  backgroundColor: AppColor.lightblue,
                                  behavior: SnackBarBehavior.floating,
                                  margin: const EdgeInsets.all(20),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    side: const BorderSide(
                                      color: AppColor.white,
                                    ),
                                  ),
                                ),
                              );
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => EnterOtpScreen(
                                    email: _emailController.text.trim(),
                                  ),
                                ),
                              );
                            } else if (state is ForgotPasswordError) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text('Error: ${state.error}')),
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
                                onPressed: state is ForgotPasswordLoading
                                    ? null
                                    : () {
                                        if (_formKey.currentState!.validate()) {
                                          ForgotPasswordCubit.get(context)
                                              .sendResetLink(
                                                  email: _emailController.text
                                                      .trim());
                                        }
                                      },
                                child: state is ForgotPasswordLoading
                                    ? const CircularProgressIndicator(
                                        color: Colors.white,
                                      )
                                    : const Text(
                                        'Send Reset Link',
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
