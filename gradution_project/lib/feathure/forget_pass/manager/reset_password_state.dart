import '../data/model/model_reset.dart';

abstract class ResetPasswordState {}

class ResetPasswordInitial extends ResetPasswordState {}

class ResetPasswordLoading extends ResetPasswordState {}

class ResetPasswordSuccess extends ResetPasswordState {
  final ResetPasswordModel model;
  ResetPasswordSuccess(this.model);
}

class ResetPasswordError extends ResetPasswordState {
  final String error;
  ResetPasswordError(this.error);
}
