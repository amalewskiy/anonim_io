import 'package:anonim_io/src/auth_bloc/auth_bloc.dart';
import 'package:anonim_io/src/core/utils/const.dart';
import 'package:anonim_io/src/core/utils/failure.dart';
import 'package:anonim_io/src/repositories/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_state.dart';
part 'login_cubit.freezed.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({
    required AuthRepository authRepository,
    required AuthBloc authBloc,
  })  : _authRepository = authRepository,
        _authBloc = authBloc,
        super(const LoginState.initial());

  final AuthRepository _authRepository;
  final AuthBloc _authBloc;

  void changeEmail(String newEmail) => emit(state.copyWith(email: newEmail));

  void changePassword(String newPassword) =>
      emit(state.copyWith(password: newPassword));

  Future<void> login() async {
    emit(state.copyWith(formStatus: FormStatus.sending));
    try {
      final user = await _authRepository.signInOrSignUp(
        state.email,
        state.password,
      );
      _authBloc.add(AuthEvent.loggedIn(user: user));
      emit(state.copyWith(formStatus: FormStatus.sended));
    } on Failure catch (e) {
      emit(state.copyWith(formStatus: FormStatus.failure, failure: e));
    }
  }
}
