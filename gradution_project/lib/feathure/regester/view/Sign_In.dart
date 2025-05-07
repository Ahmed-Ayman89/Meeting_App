import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradution_project/core/theme/theme_ext.dart';
import 'package:gradution_project/feathure/regester/manager/regester_cubit.dart';

import '../../../core/theme/theme_cubit.dart';
import 'Sign_In_widget.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RegisterCubit(),
      child: Scaffold(
        backgroundColor: context.backgroundColor,
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                buildSignUpTitle(context),
                const SizedBox(height: 20),
                buildSignUpForm(
                  context: context,
                  formKey: _formKey,
                  nameController: _nameController,
                  emailController: _emailController,
                  passwordController: _passwordController,
                  phoneController: _phoneController,
                ),
                const SizedBox(height: 20),
                buildSignUpButton(
                  context: context,
                  formKey: _formKey,
                  nameController: _nameController,
                  emailController: _emailController,
                  passwordController: _passwordController,
                  phoneController: _phoneController,
                ),
                const SizedBox(height: 30),
                buildSocialLogins(context),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
