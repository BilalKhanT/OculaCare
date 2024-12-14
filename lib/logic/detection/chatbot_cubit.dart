import 'package:bloc/bloc.dart';
import 'package:cculacare/configs/routes/router.dart';
import 'package:cculacare/logic/detection/chat_loading_cubit.dart';
import 'package:cculacare/logic/detection/chatbot_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatBotCubit extends Cubit<ChatBotState> {
  ChatBotCubit() : super(ChatBotInitial());

  TextEditingController messageController = TextEditingController();
  final List<Map<String, String>> messages = [
    {"sender": "bot", "text": "Hello! How can I assist you today?"},
    {"sender": "user", "text": "Can you tell me about eye care?"},
  ];

  sendChat(BuildContext context) async {
    context.read<ChatLoadingCubit>().toggleLoading(true);
    await Future.delayed(Duration(seconds: 3));
    context.read<ChatLoadingCubit>().toggleLoading(false);
  }
}