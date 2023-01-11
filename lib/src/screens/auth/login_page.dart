import 'package:anonim_io/injector.dart';
import 'package:anonim_io/src/core/utils/const.dart';
import 'package:anonim_io/src/screens/auth/cubit/login_cubit.dart';
import 'package:anonim_io/src/widgets/content_page.dart';
import 'package:anonim_io/src/widgets/failure_wigdet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginCubit>(
      create: (_) => sl<LoginCubit>(),
      child: ContentPage(
        child: BlocConsumer<LoginCubit, LoginState>(
          listenWhen: (previous, current) =>
              previous.formStatus != current.formStatus,
          listener: (context, state) {
            if (state.formStatus == FormStatus.failure) {
              FailureWidget(exception: state.failure)
                  .showErrorToast(context: context);
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.15),
                const Image(image: AssetImage('assets/logo.png')),
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(hintText: 'Email'),
                  onChanged: (value) =>
                      context.read<LoginCubit>().changeEmail(value),
                ),
                const SizedBox(height: mediumHorizontalSpacing),
                TextField(
                  obscureText: true,
                  decoration: const InputDecoration(hintText: 'Password'),
                  onChanged: (value) =>
                      context.read<LoginCubit>().changePassword(value),
                ),
                const SizedBox(height: mediumHorizontalSpacing),
                ElevatedButton(
                  onPressed: () => context.read<LoginCubit>().login(),
                  child: const Text('Login or sign up'),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
