import 'package:arbenn/data/user_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessageData {
  String id;
  String eventId;
  int timestamp;
  String message;
  UserSumarryData sender;

  ChatMessageData({
    required this.id,
    required this.eventId,
    required this.sender,
    required this.timestamp,
    required this.message,
  });

  static ChatMessageData fromJson(
      String id, String eventId, Map<String, dynamic> json) {
    return ChatMessageData(
        id: id,
        eventId: eventId,
        timestamp: json["timestamp"],
        message: json["message"],
        sender: UserSumarryData.fromJson(json["sender"]));
  }

  Map<String, dynamic> toJson() {
    return {
      "timestamp": timestamp,
      "message": message,
      "sender": sender.toJson()
    };
  }

  Future<void> save() async {
    FirebaseFirestore.instance
        .collection('chats')
        .doc(eventId)
        .collection(id)
        .add(toJson());
  }
}

class ChatData {
  /// Correspond to the user (for chat with admin and unique user) or the
  /// eventId if the chat is the event chat (with all attendes).
  final String id;
  final String eventId;
  late Stream<List<ChatMessageData>> messages;

  ChatData({required this.id, required this.eventId}) {
    messages = FirebaseFirestore.instance
        .collection('chats')
        .doc(eventId)
        .collection(id)
        .orderBy("timestamp", descending: true)
        .limit(100) // make it variable in the future
        .snapshots()
        .asyncMap((infos) => infos.docs
            .map((e) => ChatMessageData.fromJson(id, eventId, e.data()))
            .toList());
  }
}
