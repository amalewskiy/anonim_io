import 'dart:async';

import 'package:anonim_io/src/core/services/database_service.dart';
import 'package:anonim_io/src/models/message/message.dart';

abstract class ChatRepository {
  Stream<List<Message>> getStreamConversation(
    String loggedInUserId,
    String recipientUserId,
  );
  Stream<List<Message>> getRecentMessages(String loggedInUserId);
  Future<void> sendMessage(String recipientId, Message message);
}

class ChatRepositoryImpl implements ChatRepository {
  @override
  Stream<List<Message>> getStreamConversation(
    String loggedInUserId,
    String recipientUserId,
  ) =>
      DatabaseService.chatCollection
          .doc(loggedInUserId)
          .collection('conversations')
          .doc(recipientUserId)
          .collection('all')
          .orderBy('timestamp', descending: true)
          .snapshots()
          .transform(
        StreamTransformer.fromHandlers(
          handleData: (data, sink) {
            final snaps = data.docs.map((doc) => doc.data()).toList();
            final messages = snaps.map(Message.fromJson).toList();
            sink.add(messages);
          },
        ),
      );

  @override
  Stream<List<Message>> getRecentMessages(String loggedInUserId) =>
      DatabaseService.chatCollection
          .doc(loggedInUserId)
          .collection('recent')
          .orderBy('timestamp', descending: true)
          .snapshots()
          .transform(
        StreamTransformer.fromHandlers(
          handleData: (data, sink) {
            final snaps = data.docs.map((doc) => doc.data()).toList();
            final messages = snaps.map(Message.fromJson).toList();
            sink.add(messages);
          },
        ),
      );

  @override
  Future<void> sendMessage(String recipientId, Message message) async {
    try {
      await DatabaseService.chatCollection
          .doc(message.senderId)
          .collection('conversations')
          .doc(recipientId)
          .collection('all')
          .doc()
          .set(message.toJson());

      try {
        await DatabaseService.chatCollection
            .doc(message.senderId)
            .collection('recent')
            .doc(recipientId)
            .update(message.toJson());
      } catch (e) {
        await DatabaseService.chatCollection
            .doc(message.senderId)
            .collection('recent')
            .doc(recipientId)
            .set(message.toJson());
      }

      try {
        await DatabaseService.chatCollection
            .doc(recipientId)
            .collection('recent')
            .doc(message.senderId)
            .update(message.toJson());
      } catch (e) {
        await DatabaseService.chatCollection
            .doc(recipientId)
            .collection('recent')
            .doc(message.senderId)
            .set(message.toJson());
      }

      await DatabaseService.chatCollection
          .doc(recipientId)
          .collection('conversations')
          .doc(message.senderId)
          .collection('all')
          .doc()
          .set(message.toJson());
    } catch (e) {
      rethrow;
    }
  }
}
