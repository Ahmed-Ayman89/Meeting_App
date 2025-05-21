import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradution_project/core/theme/theme_ext.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/utils/App_assets.dart';
import '../../../core/utils/App_color.dart';
import '../../../core/widgets/custtom_Feild.dart';

import '../../regester/view/Sign_In.dart';
import '../../forget_pass/view/forget_password.dart';
import '../manager/logIn_cubit.dart';
import '../manager/logIn_state.dart';
import '../../home/navigation.dart';

// Logo
Widget buildLogo(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      CircleAvatar(
        radius: 44,
        backgroundColor: context.isDark ? AppColor.black : AppColor.white,
        child: ClipOval(
          child: Image.asset(
            AppAssets.mainlogo,
            width: 72,
            height: 72,
            fit: BoxFit.contain,
          ),
        ),
      ),
      const SizedBox(width: 10),
      Text(
        'WeyNak',
        style: TextStyle(
          color: context.textColor,
          fontSize: 46,
          fontFamily: 'Concert One',
        ),
      ),
    ],
  );
}

// Title
Widget buildTitle(BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'LOG IN',
        style: TextStyle(
          color: context.textColor,
          fontSize: 46,
          fontFamily: 'Concert One',
        ),
      ),
      Text(
        'Use your E-mail and Password to login',
        style: TextStyle(
          color: context.isDark ? Colors.white : Colors.black,
          fontSize: 16,
          fontFamily: 'Concert One',
        ),
      ),
    ],
  );
}

// Form
Widget buildLoginForm({
  required BuildContext context,
  required TextEditingController emailController,
  required TextEditingController passwordController,
  required GlobalKey<FormState> formKey,
  required List<String> emailSuggestions,
}) {
  return Form(
    key: formKey,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Autocomplete<String>(
          initialValue: TextEditingValue(text: emailController.text),
          optionsBuilder: (TextEditingValue textEditingValue) {
            if (textEditingValue.text.isEmpty) {
              return const Iterable<String>.empty();
            }
            return emailSuggestions.where((email) => email
                .toLowerCase()
                .startsWith(textEditingValue.text.toLowerCase()));
          },
          onSelected: (String selection) {
            emailController.text = selection;
          },
          fieldViewBuilder:
              (context, controller, focusNode, onEditingComplete) {
            controller.text = emailController.text;
            controller.selection = emailController.selection;
            controller.addListener(() {
              emailController.value = controller.value;
            });

            return CustomTextField(
              hintText: 'E-mail',
              controller: controller,
              isEditing: true,
              prefixIcon: Icons.email,
              validator: (value) => value == null || value.isEmpty
                  ? 'Please enter your email'
                  : null,
              onChanged: (value) {},
            );
          },
        ),
        const SizedBox(height: 10),
        CustomTextField(
          hintText: 'Password',
          controller: passwordController,
          isEditing: true,
          prefixIcon: Icons.lock,
          validator: (value) => value == null || value.isEmpty
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
                  builder: (context) => const ForgotPassword(),
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
  );
}

// Login Button
Widget buildLoginButton({
  required BuildContext context,
  required GlobalKey<FormState> formKey,
  required TextEditingController emailController,
  required TextEditingController passwordController,
}) {
  return BlocConsumer<LoginCubit, LoginState>(
    listener: (context, state) async {
      if (state is LoginSuccess) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', state.model.accessToken);
        await prefs.setString('refresh_token', state.model.refreshToken);
        await prefs.setBool('isLoggedIn', true);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Login Successful',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            backgroundColor: AppColor.lightblue,
            duration: const Duration(seconds: 3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(10),
          ),
        );

        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  Navigation(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
            ),
          );
        });
      } else if (state is LoginError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${state.error}')),
        );
      }
    },
    builder: (context, state) {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(159, 51),
          backgroundColor: AppColor.lightblue,
        ),
        onPressed: state is LoginLoading
            ? null
            : () {
                if (formKey.currentState!.validate()) {
                  final email = emailController.text;
                  final password = passwordController.text;

                  LoginCubit.get(context).userLogin(
                    email: email,
                    password: password,
                  );
                }
              },
        child: state is LoginLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Text(
                'Log in',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
      );
    },
  );
}

// Footer
Widget buildFooter(BuildContext context) {
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Don't have an account?",
            style: TextStyle(
              color: context.textColor,
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SignUp()),
              );
            },
            child: const Text(
              'Sign In',
              style: TextStyle(
                color: AppColor.lightblue,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'or log in with ',
            style: TextStyle(
              color: context.textColor,
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {},
                child: SvgPicture.asset(AppAssets.face),
              ),
              const SizedBox(width: 15),
              InkWell(
                onTap: () {},
                child: SvgPicture.asset(AppAssets.googel),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
