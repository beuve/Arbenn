import 'package:arbenn/components/user_elements.dart';
import 'package:arbenn/data/event_data.dart';
import 'package:arbenn/data/user_data.dart';
import 'package:arbenn/utils/icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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

  @override
  String toString() {
    return toJson().toString();
  }

  Future<void> save() async {
    FirebaseFirestore.instance
        .collection('chats')
        .doc(eventId)
        .collection(id)
        .add(toJson());
  }
}

class ChatSummary {
  final String chatId;
  final String eventId;
  final String name;
  final Widget image;

  ChatSummary(
      {required this.chatId,
      required this.eventId,
      required this.name,
      required this.image});

  static Future<ChatSummary> loadFromUserId(
      {required String eventId, required String userId}) async {
    UserSumarryData? userSumarryData =
        await UserSumarryData.loadFromUserId(userId);
    if (userSumarryData == null) {
      Future.error("No user found");
    }
    await userSumarryData!.getPicture();
    return ChatSummary(
        chatId: userId,
        eventId: eventId,
        name: userSumarryData.firstName,
        image: ProfileMiniature(picture: userSumarryData.picture, size: 30));
  }
}

class ChatData {
  /// Correspond to the user (for chat with admin and unique user) or the
  /// eventId if the chat is the event chat (with all attendes).
  final String chatId;
  final String eventId;
  late Stream<List<ChatMessageData>> messages;

  Future<void> createChatIfNotExists() async {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('chats').doc(eventId);

    return FirebaseFirestore.instance.runTransaction<void>((transaction) async {
      // Get the document
      DocumentSnapshot snapshot = await transaction.get(documentReference);

      Map<String, dynamic>? infos = snapshot.data() as Map<String, dynamic>?;
      if (infos != null) {
        List<String> chatIds = infos["chatIds"] as List<String>;

        if (!chatIds.any((id) => id == chatId)) {
          chatIds.add(chatId);
          transaction.update(documentReference, {
            'chatIds': chatIds,
          });
        }
      } else {
        transaction.set(documentReference, {
          'chatIds': [chatId],
        });
      }
    });
  }

  ChatData({required this.chatId, required this.eventId}) {
    messages = FirebaseFirestore.instance
        .collection('chats')
        .doc(eventId)
        .collection(chatId)
        .orderBy("timestamp", descending: true)
        .limit(100) // make it variable in the future
        .snapshots()
        .asyncMap((infos) => infos.docs
            .map((e) => ChatMessageData.fromJson(chatId, eventId, e.data()))
            .toList());
  }

  static Stream<List<ChatSummary>> listEventChats(String eventId) {
    final ChatSummary eventChatSummary = ChatSummary(
        chatId: eventId,
        eventId: eventId,
        name: "tout le monde",
        image: const Icon(
          ArbennIcons.userGroup,
          size: 30,
        ));
    return FirebaseFirestore.instance
        .collection('chats')
        .doc(eventId)
        .snapshots()
        .asyncMap((infos) async {
      Map<String, dynamic>? list = infos.data();
      if (list == null) {
        return [];
      } else {
        var userChats = await Future.wait((list["chatIds"] as List<String>).map(
            (userId) =>
                ChatSummary.loadFromUserId(eventId: eventId, userId: userId)));
        return [eventChatSummary, ...userChats];
      }
    });
  }
}
