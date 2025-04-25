import 'package:gradution_project/feathure/regester/data/model.dart';

abstract class RegisterState {}

class RegisterInitial extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisterSuccess extends RegisterState {
  final RegisterModel model;

  RegisterSuccess(this.model);
}

class RegisterError extends RegisterState {
  final String error;

  RegisterError(this.error);
}
