import 'package:equatable/equatable.dart';

abstract class ChatBotState extends Equatable {
  const ChatBotState();

  @override
  List<Object?> get props => [];
}

class ChatBotInitial extends ChatBotState {}

class ChatBotLoading extends ChatBotState {}

class ChatBotLoaded extends ChatBotState {
  final List<Map<String, String>> conversation;

  const ChatBotLoaded(this.conversation);

  @override
  List<Object?> get props => [conversation];
}

class ChatBotError extends ChatBotState {}