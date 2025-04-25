class LoginModel {
  final String message;
  final String? token;

  LoginModel({required this.message, this.token});

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      message: json['message'] ?? '',
      token: json['token'],
    );
  }
}
