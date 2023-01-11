import 'dart:async';

import 'package:anonim_io/src/core/utils/const.dart';
import 'package:anonim_io/src/core/utils/failure.dart';
import 'package:anonim_io/src/models/message/message.dart';
import 'package:anonim_io/src/repositories/chat_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'conversation_state.dart';
part 'conversation_cubit.freezed.dart';

class ConversationCubit extends Cubit<ConversationState> {
  ConversationCubit({required ChatRepository chatRepository})
      : _chatRepository = chatRepository,
        super(const ConversationState.initial());

  final ChatRepository _chatRepository;

  void changeMessage(String text) => emit(state.copyWith(message: text));

  Future<void> sendMesage(
    String senderId,
    String recipientId,
    String recipientEmail,
  ) async {
    await _chatRepository.sendMessage(
      recipientId,
      Message(
        senderId: senderId,
        recipientUserId: recipientId,
        recipientUserEmail: recipientEmail,
        message: state.message.trim(),
        timestamp: DateTime.now(),
      ),
    );
  }
}
