import 'package:bloc/bloc.dart';
import 'package:cculacare/logic/detection/chatbot_state.dart';
import 'package:flutter/material.dart';

class ChatBotCubit extends Cubit<ChatBotState> {
  ChatBotCubit() : super(ChatBotInitial());

  TextEditingController messageController = TextEditingController();
  final List<Map<String, String>> messages = [
    {"sender": "bot", "text": "Hello! How can I assist you today?"},
    {"sender": "user", "text": "Can you tell me about eye care?"},
  ];
}