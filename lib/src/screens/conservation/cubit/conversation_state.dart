part of 'conversation_cubit.dart';

@freezed
class ConversationState with _$ConversationState {
  const factory ConversationState.initial({
    @Default([]) List<Message> conversation,
    @Default('') String message,
    @Default(FormStatus.loading) FormStatus status,
    @Default(Failure()) Failure failure,
  }) = _Initial;
}
