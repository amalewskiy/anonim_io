import 'package:anonim_io/injector.dart';
import 'package:anonim_io/src/auth_bloc/auth_bloc.dart';
import 'package:anonim_io/src/core/utils/const.dart';
import 'package:anonim_io/src/core/utils/failure.dart';
import 'package:anonim_io/src/core/utils/palette.dart';
import 'package:anonim_io/src/models/message/message.dart';
import 'package:anonim_io/src/repositories/chat_repository.dart';
import 'package:anonim_io/src/screens/conservation/cubit/conversation_cubit.dart';
import 'package:anonim_io/src/widgets/content_page.dart';
import 'package:anonim_io/src/widgets/failure_wigdet.dart';
import 'package:anonim_io/src/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class ConversationPage extends StatelessWidget {
  const ConversationPage({
    required this.recipientUserId,
    required this.recipientUserEmail,
    super.key,
  });

  final String recipientUserId;
  final String recipientUserEmail;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ConversationCubit>(
      create: (_) => sl<ConversationCubit>(),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(40),
          child: AppBar(
            leading: BackButton(onPressed: () => context.pop()),
            title: Text(recipientUserEmail),
          ),
        ),
        body: ContentPage(
          withScrollPhysics: false,
          child: Column(
            children: [
              StreamBuilder(
                stream: sl<ChatRepository>().getStreamConversation(
                  context.read<AuthBloc>().state.maybeWhen(
                        authenticated: (user) => user.id,
                        orElse: () => '',
                      ),
                  recipientUserId,
                ),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return const LoadingWidget();
                    case ConnectionState.active:
                      if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                        return _Messages(
                          participantUserId: recipientUserId,
                          conversation: snapshot.data!,
                        );
                      } else {
                        return const Expanded(
                          child: Center(child: Text('No message here yet')),
                        );
                      }
                    // ignore: no_default_cases
                    default:
                      return const FailureWidget(exception: Failure())
                          .showErrorWidgetOnContentPage(context: context);
                  }
                },
              ),
              _InputField(
                participantUserId: recipientUserId,
                participantUserEmail: recipientUserEmail,
              ),
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
        itemBuilder: (context, index) => _Message(
          message: conversation[index],
          isSender: conversation[index].senderId != participantUserId,
        ),
        separatorBuilder: (_, __) => const SizedBox(height: 4),
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
    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment:
            isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(appPadding),
            decoration: BoxDecoration(
              color: isSender ? Palette.mainBlue : Palette.recipientUserMessage,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(messageRadius),
                topRight: const Radius.circular(messageRadius),
                bottomLeft: isSender
                    ? const Radius.circular(messageRadius)
                    : const Radius.circular(4),
                bottomRight: isSender
                    ? const Radius.circular(4)
                    : const Radius.circular(messageRadius),
              ),
            ),
            child: Text(
              message.message,
              style: Theme.of(context)
                  .textTheme
                  .headline1!
                  .copyWith(color: isSender ? Colors.white : Colors.black),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            DateFormat('dd.MM hh:mm').format(message.timestamp),
            style:
                Theme.of(context).textTheme.headline1!.copyWith(fontSize: 11),
          ),
          const SizedBox(height: appPadding),
        ],
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  _InputField({
    required this.participantUserId,
    required this.participantUserEmail,
  });

  final String participantUserId;
  final String participantUserEmail;

  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: Theme.of(context).textTheme.headlineSmall,
      textAlignVertical: TextAlignVertical.center,
      onChanged: (text) =>
          context.read<ConversationCubit>().changeMessage(text),
      decoration: InputDecoration(
        hintText: 'Message',
        suffixIcon: IconButton(
          icon: const Icon(Icons.send_outlined),
          onPressed: () async {
            controller.clear();
            await context.read<ConversationCubit>().sendMesage(
                  context.read<AuthBloc>().state.maybeWhen(
                        authenticated: (user) => user.id,
                        orElse: () => '',
                      ),
                  participantUserId,
                  participantUserEmail,
                );
          },
        ),
      ),
    );
  }
}
