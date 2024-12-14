import 'package:cculacare/configs/presentation/constants/colors.dart';
import 'package:cculacare/logic/detection/chatbot_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ChatbotView extends StatelessWidget {
  const ChatbotView({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.screenBackground,
        appBar: AppBar(
          backgroundColor: AppColors.screenBackground,
          leading: IconButton(
            onPressed: () {
              context.pop();
            },
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: AppColors.appColor,
              size: 30.0,
            ),
          ),
          title: Text(
            'OculaBot',
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'MontserratMedium',
              fontWeight: FontWeight.w800,
              fontSize: screenWidth * 0.05,
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                reverse: true,
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                itemCount: context.read<ChatBotCubit>().messages.length,
                itemBuilder: (context, index) {
                  final message = context.read<ChatBotCubit>().messages[context.read<ChatBotCubit>().messages.length - 1 - index];
                  final isUser = message["sender"] == "user";
                  return Align(
                    alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 5.0),
                      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                      decoration: BoxDecoration(
                        color: isUser ? AppColors.appColor : Colors.grey[200],
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Text(
                        message["text"]!,
                        style: TextStyle(
                          color: isUser ? Colors.white : Colors.black,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 5.0,
                    offset: const Offset(0, -1),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      cursorColor: AppColors.appColor,
                      controller: context.read<ChatBotCubit>().messageController,
                      decoration: InputDecoration(
                        hintText: 'Type your message...',
                        hintStyle: TextStyle(
                          fontFamily: 'Montserrat',
                          color: Colors.grey.shade600
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[200],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  IconButton(
                    icon: const Icon(
                      Icons.send,
                      color: AppColors.appColor,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
