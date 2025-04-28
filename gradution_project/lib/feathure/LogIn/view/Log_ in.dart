import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradution_project/core/theme/theme_ext.dart';
import '../../../core/theme/theme_cubit.dart';

import 'logIn_widget.dart';
import '../manager/logIn_cubit.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginCubit(),
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
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  buildLogo(context),
                  const SizedBox(height: 20),
                  buildTitle(context),
                  const SizedBox(height: 20),
                  buildLoginForm(
                    emailController: _emailController,
                    passwordController: _passwordController,
                    formKey: _formKey,
                    context: context,
                  ),
                  const SizedBox(height: 20),
                  buildLoginButton(
                    context: context,
                    formKey: _formKey,
                    emailController: _emailController,
                    passwordController: _passwordController,
                  ),
                  const SizedBox(height: 20),
                  buildFooter(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
