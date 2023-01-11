import 'package:anonim_io/injector.dart';
import 'package:anonim_io/src/auth_bloc/auth_bloc.dart';
import 'package:anonim_io/src/config/app_router.dart';
import 'package:anonim_io/src/config/app_theme.dart';
import 'package:anonim_io/src/core/utils/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>(
      create: (_) => sl<AuthBloc>(),
      child: MaterialApp.router(
        title: appTitle,
        theme: AppTheme.light,
        debugShowCheckedModeBanner: false,
        routeInformationProvider:
            sl<AppRouter>().router.routeInformationProvider,
        routeInformationParser: sl<AppRouter>().router.routeInformationParser,
        routerDelegate: sl<AppRouter>().router.routerDelegate,
      ),
    );
  }
}
