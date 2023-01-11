import 'dart:developer';
import 'dart:io';

import 'package:anonim_io/injector.dart';
import 'package:anonim_io/src/auth_bloc/auth_bloc.dart';
import 'package:anonim_io/src/core/utils/const.dart';
import 'package:anonim_io/src/core/utils/failure.dart';
import 'package:anonim_io/src/models/message/message.dart';
import 'package:anonim_io/src/repositories/chat_repository.dart';
import 'package:anonim_io/src/screens/conservation/cubit/conversation_cubit.dart';
import 'package:anonim_io/src/widgets/content_page.dart';
import 'package:anonim_io/src/widgets/error_widget.dart';
import 'package:anonim_io/src/widgets/failure_wigdet.dart';
import 'package:anonim_io/src/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class ConversationPage extends StatelessWidget {
  const ConversationPage({required this.userId, super.key});

  final String userId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ConversationCubit>(
      create: (_) => sl<ConversationCubit>(),
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(onPressed: () => context.pop()),
        ),
        body: ContentPage(
          child: Column(
            children: [
              StreamBuilder(
                stream: sl<ChatRepository>().getStreamConversation(
                  context.read<AuthBloc>().state.maybeWhen(
                        authenticated: (user) => user.id,
                        orElse: () => '',
                      ),
                  userId,
                ),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return const LoadingWidget();
                    case ConnectionState.active:
                      if (snapshot.hasData) {
                        return _Messages(
                          participantUserId: userId,
                          conversation: snapshot.data!,
                        );
                      } else {
                        return const Expanded(
                          child: Center(child: Text('Start conversation')),
                        );
                      }
                    // ignore: no_default_cases
                    default:
                      return const FailureWidget(exception: Failure())
                          .showErrorWidgetOnContentPage(context: context);
                  }
                },
              ),
              _InputField(participantUserId: userId),
            ],
          ),
        ),
      ),
    );
  }
}

class _Messages extends StatelessWidget {
  const _Messages({
    required this.participantUserId,
    required this.conversation,
  });

  final String participantUserId;
  final List<Message> conversation;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.separated(
        shrinkWrap: true,
        reverse: true,
        itemCount: conversation.length,
        padding: const EdgeInsets.all(8),
        itemBuilder: (context, index) => _Message(
          message: conversation[index],
          isSender: conversation[index].senderId != participantUserId,
        ),
        separatorBuilder: (_, __) => const SizedBox(height: 8),
      ),
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({
    required this.message,
    required this.isSender,
  });

  final Message message;
  final bool isSender;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment:
            isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: screenSize.width * 0.6,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isSender ? Colors.orange : Colors.white.withOpacity(0.6),
              borderRadius: const BorderRadius.all(
                Radius.circular(8),
              ),
              border: !isSender ? Border.all(color: Colors.cyan) : null,
            ),
            child: Text(
              message.message,
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium!
                  .copyWith(color: isSender ? Colors.white : null),
            ),
          ),
          const SizedBox(height: 12),
          // Text(
          //   DateFormat('dd.MM.yyyy HH:mm', Platform.localeName)
          //       .format(message.timestamp),
          //   style: Theme.of(context)
          //       .textTheme
          //       .bodySmall!
          //       .copyWith(color: Colors.cyan),
          // )
        ],
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  _InputField({required this.participantUserId});

  final String participantUserId;

  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: Theme.of(context).textTheme.headlineSmall,
      textAlignVertical: TextAlignVertical.center,
      onChanged: (text) =>
          context.read<ConversationCubit>().changeMessage(text),
      // context.read<ConversationCubit>().changeMessageText(value),
      decoration: InputDecoration(
        border: const OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        hintText: 'Message',
        suffixIcon: IconButton(
          icon: const Icon(Icons.send_outlined),
          onPressed: () async {
            await context.read<ConversationCubit>().sendMesage(
                  context.read<AuthBloc>().state.maybeWhen(
                        authenticated: (user) => user.id,
                        orElse: () => '',
                      ),
                  participantUserId,
                );
            controller.clear();
          },
        ),
      ),
    );
  }
}
