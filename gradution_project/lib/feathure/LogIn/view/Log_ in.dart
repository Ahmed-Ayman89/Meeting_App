import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradution_project/core/theme/theme_ext.dart';
import '../../../core/theme/theme_cubit.dart';

import '../../../core/utils/App_color.dart';
import '../../../core/widgets/custtom_Feild.dart';
import '../../forget_pass/view/forget_password.dart';
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

  List<String> emailSuggestions = [];
  List<String> allEmails = [];
  bool _didFetchEmailHistory = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> fetchEmailHistory(BuildContext context) async {
    final cubit = LoginCubit.get(context);
    final emails = await cubit.getEmailHistory();
    setState(() {
      allEmails = emails;
      emailSuggestions = emails;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginCubit(),
      child: Builder(
        builder: (context) {
          // نفذ مرة واحدة فقط
          if (!_didFetchEmailHistory) {
            fetchEmailHistory(context);
            _didFetchEmailHistory = true;
          }

          return Scaffold(
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
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomTextField(
                              hintText: 'E-mail',
                              controller: _emailController,
                              isEditing: true,
                              prefixIcon: Icons.email,
                              validator: (value) =>
                                  value == null || value.isEmpty
                                      ? 'Please enter your email'
                                      : null,
                              onChanged: (value) {
                                setState(() {
                                  emailSuggestions = allEmails
                                      .where((email) => email
                                          .toLowerCase()
                                          .startsWith(value.toLowerCase()))
                                      .toList();
                                });
                              },
                            ),
                            const SizedBox(height: 4),
                            if (emailSuggestions.isNotEmpty)
                              Container(
                                margin: EdgeInsets.only(top: 4),
                                constraints: BoxConstraints(maxHeight: 150),
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .cardColor
                                      .withOpacity(0.9), // شفافية 90%
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 8,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                  border: Border.all(
                                    color: Theme.of(context)
                                        .dividerColor
                                        .withOpacity(0.2),
                                    width: 1,
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Material(
                                    color: context.backgroundColor,
                                    child: ListView.builder(
                                      padding: EdgeInsets.zero,
                                      shrinkWrap: true,
                                      physics: BouncingScrollPhysics(),
                                      itemCount: emailSuggestions.length,
                                      itemBuilder: (context, index) {
                                        final suggestion =
                                            emailSuggestions[index];
                                        return InkWell(
                                          onTap: () {
                                            _emailController.text = suggestion;
                                            setState(() {
                                              emailSuggestions = [];
                                            });
                                            FocusScope.of(context).unfocus();
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 12, horizontal: 16),
                                            decoration: BoxDecoration(
                                              border: index <
                                                      emailSuggestions.length -
                                                          1
                                                  ? Border(
                                                      bottom: BorderSide(
                                                        color: Theme.of(context)
                                                            .dividerColor
                                                            .withOpacity(0.1),
                                                        width: 1,
                                                      ),
                                                    )
                                                  : null,
                                            ),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.history,
                                                  size: 20,
                                                  color: Theme.of(context)
                                                      .hintColor,
                                                ),
                                                SizedBox(width: 12),
                                                Expanded(
                                                  child: Text(
                                                    suggestion,
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      color: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium
                                                          ?.color,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            const SizedBox(height: 10),
                            CustomTextField(
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: true,
                              hintText: 'Password',
                              controller: _passwordController,
                              isEditing: true,
                              prefixIcon: Icons.lock,
                              validator: (value) =>
                                  value == null || value.isEmpty
                                      ? 'Please enter your password'
                                      : null,
                              onChanged: (value) {},
                            ),
                            const SizedBox(height: 10),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const ForgotPassword(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Forgot Password?',
                                  style: TextStyle(
                                    color: AppColor.lightblue,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
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
          );
        },
      ),
    );
  }
}
