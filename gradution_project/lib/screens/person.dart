import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradution_project/core/theme/theme_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import '../core/widgets/custtom_Feild.dart';

class PersonPage extends StatefulWidget {
  const PersonPage({super.key});

  @override
  State<PersonPage> createState() => _PersonPageState();
}

class _PersonPageState extends State<PersonPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  String? imagePath;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String loadedName = prefs.getString('userName') ?? "";
    String loadedEmail = prefs.getString('userEmail') ?? "";
    String loadedPhone = prefs.getString('userPhone') ?? "";
    String? loadedImagePath = prefs.getString('userImagePath');

    setState(() {
      nameController.text = loadedName;
      emailController.text = loadedEmail;
      phoneController.text = loadedPhone;
      imagePath = loadedImagePath;
    });
  }

  void _saveUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', nameController.text);
    await prefs.setString('userEmail', emailController.text);
    await prefs.setString('userPhone', phoneController.text);

    setState(() {}); // تحديث الواجهة بعد الحفظ
  }

  void _saveImagePath(String path) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userImagePath', path);
    setState(() {
      imagePath = path;
    });
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _saveImagePath(pickedFile.path);
    }
  }

  void _clearUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // يمسح كل البيانات المخزنة
    setState(() {
      nameController.text = "";
      emailController.text = "";
      phoneController.text = "";
      imagePath = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color:
                context.watch<ThemeCubit>().state ? Colors.white : Colors.black,
            size: 30,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: _clearUserData,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: Color(0xFF30C3D4),
                radius: 82,
                child: CircleAvatar(
                  radius: 78,
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: ClipOval(
                      child: imagePath != null
                          ? Image.file(File(imagePath!),
                              fit: BoxFit.cover, width: 200, height: 200)
                          : Icon(Icons.camera_alt,
                              size: 50, color: Colors.white),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              CustomTextField(
                  hintText: 'Name',
                  isEditing: true,
                  controller: nameController),
              SizedBox(height: 15),
              CustomTextField(
                  hintText: 'E-Mail',
                  isEditing: true,
                  controller: emailController),
              SizedBox(height: 15),
              CustomTextField(
                  hintText: 'Phone',
                  isEditing: true,
                  controller: phoneController),
              SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(200, 25),
                  backgroundColor: context.watch<ThemeCubit>().state
                      ? Colors.black
                      : Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                onPressed: () {
                  _saveUserData();
                },
                child: Text(
                  'Save',
                  style: TextStyle(
                    fontSize: 20,
                    color: context.watch<ThemeCubit>().state
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
