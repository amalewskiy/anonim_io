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
        super(const ConversationState.initial()) {
    //  _conversationStreamSubscription = _chatRepository.getStreamConversation(loggedInUserId, recipientUserId).listen((event) => ))
  }

  final ChatRepository _chatRepository;
  late final StreamSubscription<List<Message>> _conversationStreamSubscription;

  void changeMessage(String text) => emit(state.copyWith(message: text));

  Future<void> sendMesage(String senderId, String recipientId) async {
    await _chatRepository.sendMessage(
      recipientId,
      Message(
        senderId: senderId,
        message: state.message.trim(),
        timestamp: DateTime.now(),
      ),
    );
  }
}

//  _userStreamSubscription =
//         _authRepository.user.listen((user) => add(_UserChanged(user: user)));