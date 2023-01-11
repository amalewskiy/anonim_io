import 'dart:developer';

import 'package:anonim_io/injector.dart';
import 'package:anonim_io/src/auth_bloc/auth_bloc.dart';
import 'package:anonim_io/src/core/utils/failure.dart';
import 'package:anonim_io/src/core/utils/pages.dart';
import 'package:anonim_io/src/models/message/message.dart';
import 'package:anonim_io/src/models/user/user.dart';
import 'package:anonim_io/src/repositories/chat_repository.dart';
import 'package:anonim_io/src/screens/home/cubit/home_cubit.dart';
import 'package:anonim_io/src/widgets/content_page.dart';
import 'package:anonim_io/src/widgets/failure_wigdet.dart';
import 'package:anonim_io/src/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeCubit>(
      create: (_) => sl<HomeCubit>(),
      child: ContentPage(
        withScrollPhysics: false,
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            return Column(
              children: [
                TextField(
                  decoration: const InputDecoration(
                    hintText: 'Search user',
                    suffixIcon: Icon(Icons.search),
                  ),
                  onChanged: (value) =>
                      context.read<HomeCubit>().findUser(value),
                ),
                state.when(
                  initial: () => const _WhenInitialState(),
                  findMode: (foundUser) => _WhenFindUserMode(
                    foundUser: foundUser,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _WhenInitialState extends StatelessWidget {
  const _WhenInitialState();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: sl<ChatRepository>().getRecentMessages(
        context.read<AuthBloc>().state.maybeWhen(
              authenticated: (user) => user.id,
              orElse: () => '',
            ),
      ),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const LoadingWidget();
          case ConnectionState.active:
            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              log('message');
              return _RecentMessages(conversations: snapshot.data!);
            } else {
              return Expanded(
                child: Center(
                  child: Text(
                    'Start conversation...',
                    style: Theme.of(context).textTheme.headline3,
                  ),
                ),
              );
            }
          // ignore: no_default_cases
          default:
            return const FailureWidget(exception: Failure())
                .showErrorWidgetOnContentPage(context: context);
        }
      },
    );
  }
}

class _RecentMessages extends StatelessWidget {
  const _RecentMessages({required this.conversations});

  final List<Message> conversations;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: conversations.length,
        padding: const EdgeInsets.all(8),
        itemBuilder: (context, index) => GestureDetector(
          onTap: () => context.pushNamed(
            Pages.conversationRouteName,
            params: {'id': conversations[index].recipientUserId},
            queryParams: {'email': conversations[index].recipientUserEmail},
          ),
          child: ListTile(
            title: Text(
              conversations[index].recipientUserEmail,
              style: Theme.of(context).textTheme.headline3,
            ),
            subtitle: Text(conversations[index].message),
          ),
        ),
        separatorBuilder: (_, __) => const SizedBox(height: 8),
      ),
    );
  }
}

class _WhenFindUserMode extends StatelessWidget {
  const _WhenFindUserMode({this.foundUser});

  final User? foundUser;

  @override
  Widget build(BuildContext context) {
    if (foundUser != null) {
      return GestureDetector(
        onTap: () => context.pushNamed(
          Pages.conversationRouteName,
          params: {'id': foundUser!.id},
          queryParams: {'email': foundUser!.email},
        ),
        child: ListTile(
          title: Text(
            foundUser!.email,
            style: Theme.of(context).textTheme.headline3,
          ),
        ),
      );
    } else {
      return Expanded(
        child: Center(
          child: Text(
            'User not found :(',
            style: Theme.of(context).textTheme.headline3,
          ),
        ),
      );
    }
  }
}
