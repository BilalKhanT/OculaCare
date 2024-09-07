import 'package:equatable/equatable.dart';

sealed class KeyboardListenerState extends Equatable {
  const KeyboardListenerState();

  @override
  List<Object> get props => [];
}

final class KeyboardOpened extends KeyboardListenerState {}

final class KeyboardClosed extends KeyboardListenerState {}
