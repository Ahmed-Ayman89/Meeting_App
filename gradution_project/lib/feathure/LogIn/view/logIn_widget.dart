import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradution_project/core/utils/App_assets.dart';
import 'package:gradution_project/core/utils/App_color.dart';
import 'package:gradution_project/core/widgets/custtom_Feild.dart';
import 'package:shared_preferences/shared_preferences.dart'; // ضفنا الشيرد برفرانس
import '../../regester/view/Sign_In.dart';
import '../../forget_pass/view/forget_password.dart';
import '../manager/logIn_cubit.dart';
import '../manager/logIn_state.dart';
import '../../home/navigation.dart';

// Logo
Widget buildLogo() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      CircleAvatar(
        radius: 44,
        backgroundColor: AppColor.black,
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
          color: Colors.white,
          fontSize: 46,
          fontFamily: 'Concert One',
        ),
      ),
    ],
  );
}

// Title
Widget buildTitle() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'LOG IN',
        style: TextStyle(
          color: Colors.white,
          fontSize: 46,
          fontFamily: 'Concert One',
        ),
      ),
      Text(
        'Use your E-mail and Password to login',
        style: TextStyle(
          color: Colors.white,
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
}) {
  return Form(
    key: formKey,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          hintText: 'E-mail',
          controller: emailController,
          isEditing: true,
          prefixIcon: Icons.email,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email';
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
        CustomTextField(
          hintText: 'Password',
          controller: passwordController,
          isEditing: true,
          prefixIcon: Icons.lock,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your password';
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ForgotPassword(),
                ),
              );
            },
            child: const Text(
              'Forgot Password?',
              style: TextStyle(
                color: AppColor.white,
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
        // نحفظ التوكن
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', state.model.token ?? '');
        await prefs.setBool('isLoggedIn', true);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Login Successful',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            backgroundColor: AppColor.lightblue,
            duration: Duration(seconds: 3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.all(10),
          ),
        );

        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Navigation()),
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
          minimumSize: Size(159, 51),
          backgroundColor: Color(0xFF30C3D4),
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
            ? SizedBox(
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
          const Text(
            "Don't have an account?",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SignIn(),
                ),
              );
            },
            child: const Text(
              'Sign In',
              style: TextStyle(
                color: Color(0xFF30C3D4),
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
          const Text(
            'or log in with ',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  // Handle Facebook login
                },
                child: SvgPicture.asset(AppAssets.face),
              ),
              const SizedBox(width: 15),
              InkWell(
                onTap: () {
                  // Handle Google login
                },
                child: SvgPicture.asset(AppAssets.googel),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
