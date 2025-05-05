import 'package:equatable/equatable.dart';

sealed class CreateMeetLocationState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CreateMeetLocationInitial extends CreateMeetLocationState {}

class CreateMeetLocationLoading extends CreateMeetLocationState {}

class CreateMeetLocationSuccess extends CreateMeetLocationState {
  final String message;

  CreateMeetLocationSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class CreateMeetLocationFailure extends CreateMeetLocationState {
  final String error;

  CreateMeetLocationFailure(this.error);

  @override
  List<Object?> get props => [error];
}
