import 'package:anonim_io/src/auth_bloc/auth_bloc.dart';
import 'package:anonim_io/src/core/utils/pages.dart';
import 'package:anonim_io/src/screens/auth/login_page.dart';
import 'package:anonim_io/src/screens/conservation/conversation_page.dart';
import 'package:anonim_io/src/screens/home/home_page.dart';
import 'package:anonim_io/src/screens/loading_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  AppRouter({required AuthBloc authBloc}) : _authBloc = authBloc;

  final AuthBloc _authBloc;

  final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>();
  // final GlobalKey<NavigatorState> _shellNavigatorKey =
  //     GlobalKey<NavigatorState>();

  Widget _loginPage(_, __) => const LoginPage();
  NoTransitionPage<NoTransitionPage<HomePage>> _homePage(_, __) =>
      const NoTransitionPage(child: HomePage());
  Widget _loadingPage(_, __) => const LoadingPage();
  Widget _chatPage(_, GoRouterState state) => ConversationPage(
        recipientUserId: state.params['id']!,
        recipientUserEmail: state.queryParams['email']!,
      );

  late final GoRouter router = GoRouter(
    initialLocation: Pages.home,
    navigatorKey: _rootNavigatorKey,
    routes: [
      GoRoute(path: Pages.login, builder: _loginPage),
      GoRoute(
        path: Pages.home,
        pageBuilder: _homePage,
        routes: <GoRoute>[
          GoRoute(
            path: Pages.conversationRouteName,
            name: Pages.conversationRouteName,
            builder: _chatPage,
          ),
        ],
      ),
      GoRoute(path: Pages.loadingPage, builder: _loadingPage),
    ],
    refreshListenable: GoRouterRefreshStream(_authBloc.stream),
    debugLogDiagnostics: true,
    urlPathStrategy: UrlPathStrategy.path,
    redirect: (state) {
      switch (state.location) {
        case Pages.home:
          return _authBloc.state.maybeMap(
            authenticated: (_) => null,
            unauthenticated: (_) => Pages.login,
            orElse: () => Pages.loadingPage,
          );
        case Pages.login:
          return _authBloc.state.maybeMap(
            authenticated: (_) => Pages.home,
            loading: (_) => Pages.loadingPage,
            orElse: () => null,
          );
        case Pages.loadingPage:
          return _authBloc.state.maybeMap(
            authenticated: (_) => Pages.home,
            unauthenticated: (_) => Pages.login,
            orElse: () => null,
          );
        default:
          return null;
      }
    },
  );
}
