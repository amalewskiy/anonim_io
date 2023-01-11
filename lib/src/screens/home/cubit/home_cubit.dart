import 'package:anonim_io/src/models/user/user.dart';
import 'package:anonim_io/src/repositories/user_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_state.dart';
part 'home_cubit.freezed.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(const HomeState.initial());

  final UserRepository _userRepository;

  Future<void> findUser(String email) async {
    if (email.trim().isEmpty) {
      emit(const HomeState.initial());
      return;
    }
    emit(const HomeState.findMode());
    final foundUser = await _userRepository.getUserByEmail(email.trim());
    emit(HomeState.findMode(foundUser: foundUser));
  }
}
