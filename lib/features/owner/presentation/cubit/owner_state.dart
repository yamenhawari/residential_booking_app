import 'dart:io';
import 'package:equatable/equatable.dart';

abstract class OwnerState extends Equatable {
  const OwnerState();
  @override
  List<Object> get props => [];
}

class OwnerInitial extends OwnerState {}

class OwnerLoading extends OwnerState {}

class OwnerSuccess extends OwnerState {
  final String message;
  const OwnerSuccess(this.message);
  @override
  List<Object> get props => [message];
}

class OwnerError extends OwnerState {
  final String message;
  const OwnerError(this.message);
  @override
  List<Object> get props => [message];
}

class OwnerImagesChanged extends OwnerState {
  final List<File> images;
  const OwnerImagesChanged(this.images);
  @override
  List<Object> get props => [images];
}
