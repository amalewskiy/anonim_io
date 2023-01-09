part of 'login_cubit.dart';

@freezed
abstract class LoginState with _$LoginState {
  const factory LoginState.initial({
    @Default('') String email,
    @Default('') String password,
    @Default(FormStatus.initial) FormStatus formStatus,
     @Default(Failure()) Failure failure,
  }) = _Initial;
}
