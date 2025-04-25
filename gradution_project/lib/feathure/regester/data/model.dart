class RegisterModel {
  final String message;

  RegisterModel({required this.message});

  factory RegisterModel.fromJson(Map<String, dynamic> json) {
    return RegisterModel(
      message: json['message'] ?? '',
    );
  }
}
