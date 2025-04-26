import '../data/model/model_password.dart';

abstract class ForgotPasswordState {}

class ForgotPasswordInitial extends ForgotPasswordState {}

class ForgotPasswordLoading extends ForgotPasswordState {}

class ForgotPasswordSuccess extends ForgotPasswordState {
  final ForgotPasswordModel model;
  ForgotPasswordSuccess(this.model);
}

class ForgotPasswordError extends ForgotPasswordState {
  final String error;
  ForgotPasswordError(this.error);
}
