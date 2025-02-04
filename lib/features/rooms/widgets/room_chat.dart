import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sw/common/constants/colors.dart';
import 'package:sw/common/utils/cache_helper.dart';
import 'package:sw/features/auth/models/user_model.dart';
import 'package:sw/features/rooms/bloc/pusher_bloc.dart';
import 'package:sw/features/rooms/cubit/room_cubit.dart';
import 'package:sw/features/rooms/models/message_model.dart';

class RoomChat extends HookWidget {
  const RoomChat({super.key, this.showChat = true});
  final bool showChat;
  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = useScrollController();
    void scrollToBottom() {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }

    final List<MessageModel> messages = context.watch<PusherBloc>().messages;
    final UserModel user =
        UserModel.fromJson(jsonDecode(CacheHelper.getCache(key: 'user')));
    return Column(
      children: [
        if (showChat)
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.backgroundColor,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: AppColors.primaryColor.withOpacity(0.5),
                  width: 1.5,
                ),
              ),
              child: Column(
                mainAxisAlignment:
                    showChat ? MainAxisAlignment.start : MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: BlocConsumer<PusherBloc, PusherState>(
                      listener: (context, state) {
                        if (state is GetOldMessagesSuccess ||
                            state is MessageRecived) {
                          Future.delayed(
                            const Duration(seconds: 1),
                            () {
                              scrollToBottom();
                            },
                          );
                        }
                      },
                      builder: (context, state) {
                        if (state is GetOldMessagesLoading) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primaryColor,
                            ),
                          );
                        }
                        if (messages.isNotEmpty) {
                          return ListView.separated(
                            controller: scrollController,
                            padding: const EdgeInsets.only(top: 8),
                            reverse: false,
                            itemCount: messages.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final isMe = messages[index].senderId == user.id;
                              return ChatMessageBubble(
                                isMe: isMe,
                                username: messages[index].senderName!,
                                message: messages[index].message!,
                                showAvatar: false,
                              );
                            },
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  MessageInputField(onSend: (message) {
                    context.read<PusherBloc>().add(SendMessage(
                        message, context.read<RoomCubit>().myRoom!.id!));
                  }),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class ChatMessageBubble extends StatelessWidget {
  final bool isMe;
  final String username;
  final String message;
  final bool showAvatar;

  const ChatMessageBubble({
    super.key,
    required this.isMe,
    required this.username,
    required this.message,
    this.showAvatar = true,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: isMe ? TextDirection.ltr : TextDirection.rtl,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showAvatar)
            CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.primaryColor.withOpacity(0.2),
              child: const Icon(
                Icons.person,
                size: 20,
                color: AppColors.primaryColor,
              ),
            ),
          const SizedBox(width: 8),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: isMe
                    ? AppColors.primaryColor
                    : AppColors.greyColor.withOpacity(0.2),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isMe ? 16 : 4),
                  bottomRight: Radius.circular(isMe ? 4 : 16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    username,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: isMe ? Colors.black : AppColors.greyColor,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message,
                    style: TextStyle(
                      color: isMe ? Colors.black : AppColors.greyColor,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MessageInputField extends StatelessWidget {
  final ValueChanged<String> onSend;

  const MessageInputField({
    super.key,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.primaryColor.withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              style: const TextStyle(color: AppColors.greyColor),
              decoration: InputDecoration(
                hintText: "Type a message...",
                hintStyle:
                    TextStyle(color: AppColors.greyColor.withOpacity(0.6)),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              onSubmitted: onSend,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: AppColors.primaryColor),
            onPressed: () {
              if (controller.text.isNotEmpty) {
                FocusScope.of(context).unfocus();
                onSend(controller.text);
                controller.clear();
              }
            },
          ),
        ],
      ),
    );
  }
}
