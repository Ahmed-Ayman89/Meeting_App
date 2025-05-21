import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradution_project/core/theme/theme_ext.dart';
import 'package:gradution_project/core/widgets/custtom_Feild.dart';
import 'package:gradution_project/core/utils/App_assets.dart';
import 'package:gradution_project/feathure/regester/manager/regester_cubit.dart';
import 'package:gradution_project/feathure/regester/manager/regester_state.dart';

import '../../home/navigation.dart';

Widget buildSignUpTitle(BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Welcome!',
        style: TextStyle(
          color: context.textColor,
          fontSize: 46,
          fontFamily: 'Concert One',
        ),
      ),
      Text(
        'Create an account to join WeyNak',
        style: TextStyle(
          color: context.isDark ? Colors.white70 : Colors.black54,
          fontSize: 16,
          fontFamily: 'Concert One',
        ),
      ),
    ],
  );
}

Widget buildSignUpForm({
  required BuildContext context,
  required GlobalKey<FormState> formKey,
  required TextEditingController nameController,
  required TextEditingController emailController,
  required TextEditingController passwordController,
  required TextEditingController phoneController,
}) {
  return Form(
    key: formKey,
    child: Column(
      children: [
        CustomTextField(
          hintText: 'phone',
          controller: phoneController,
          isEditing: true,
          prefixIcon: Icons.contact_page,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your phone number';
            }
            return null;
          },
          onChanged: (value) {},
        ),
        const SizedBox(height: 10),
        CustomTextField(
          hintText: 'Name',
          controller: nameController,
          isEditing: true,
          prefixIcon: Icons.person,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your name';
            }
            return null;
          },
          onChanged: (value) {},
        ),
        const SizedBox(height: 10),
        CustomTextField(
          hintText: 'Email',
          controller: emailController,
          isEditing: true,
          prefixIcon: Icons.email,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email';
            }
            final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
            if (!emailRegex.hasMatch(value)) {
              return 'Please enter a valid email address';
            }
            return null;
          },
          onChanged: (value) {},
        ),
        const SizedBox(height: 10),
        CustomTextField(
          hintText: 'Password',
          controller: passwordController,
          isEditing: true,
          prefixIcon: Icons.lock,
          validator: (value) {
            if (value == null || value.length < 6) {
              return 'Password must be at least 6 characters';
            }
            return null;
          },
          onChanged: (value) {},
        ),
      ],
    ),
  );
}

Widget buildSignUpButton({
  required BuildContext context,
  required GlobalKey<FormState> formKey,
  required TextEditingController nameController,
  required TextEditingController emailController,
  required TextEditingController passwordController,
  required TextEditingController phoneController,
}) {
  return BlocConsumer<RegisterCubit, RegisterState>(
    listener: (context, state) {
      if (state is RegisterSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.model.message),
            backgroundColor: Colors.green,
          ),
        );
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const Navigation(),
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
      } else if (state is RegisterError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${state.error}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    },
    builder: (context, state) {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(180, 51),
          backgroundColor: const Color(0xFF30C3D4),
        ),
        onPressed: state is RegisterLoading
            ? null
            : () {
                if (formKey.currentState!.validate()) {
                  RegisterCubit.get(context).userRegister(
                    name: nameController.text,
                    email: emailController.text,
                    password: passwordController.text,
                    phone: phoneController.text,
                  );
                }
              },
        child: state is RegisterLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                    color: Colors.white, strokeWidth: 2),
              )
            : const Text(
                'Sign Up',
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

Widget buildSocialLogins(BuildContext context) {
  return Column(
    children: [
      Text(
        'or sign up with',
        style: TextStyle(
          color: context.textColor,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      const SizedBox(height: 20),
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
  );
}
