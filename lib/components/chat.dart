import 'package:arbenn/components/scroller.dart';
import 'package:arbenn/data/chat_data.dart';
import 'package:arbenn/data/user_data.dart';
import 'package:arbenn/utils/colors.dart';
import 'package:arbenn/utils/icons.dart';
import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  final ChatMessageData message;
  final bool fromCurrentUser;
  final Nuance color;

  const ChatMessage({
    Key? key,
    required this.message,
    required this.fromCurrentUser,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      if (fromCurrentUser) Expanded(flex: 1, child: Container()),
      Flexible(
          flex: 3,
          child: Align(
              alignment: fromCurrentUser
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              child: Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(10),
                        topRight: const Radius.circular(10),
                        bottomLeft: fromCurrentUser
                            ? const Radius.circular(10)
                            : Radius.zero,
                        bottomRight: fromCurrentUser
                            ? Radius.zero
                            : const Radius.circular(10),
                      ),
                      color: fromCurrentUser ? color.dark : color.darker),
                  child: Text(message.message,
                      textWidthBasis: TextWidthBasis.longestLine,
                      textAlign:
                          fromCurrentUser ? TextAlign.right : TextAlign.left,
                      style: TextStyle(color: color.lighter))))),
      if (!fromCurrentUser) Expanded(flex: 1, child: Container()),
    ]);
  }
}

class Chat extends StatelessWidget {
  final ChatData chatData;
  final UserSumarryData sender;
  final Nuance color;
  final TextEditingController _messageController = TextEditingController();

  Chat({
    required this.sender,
    required this.chatData,
    this.color = Palette.yellow,
    Key? key,
  }) : super(key: key);

  Widget _buildInput([bool hasMessage = true]) {
    return Row(
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(10),
            color: Palette.grey.lighter,
            child: TextField(
              autocorrect: false,
              autofocus: true,
              controller: _messageController,
              decoration: InputDecoration(
                fillColor: Palette.green.lighter,
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: color.dark)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: color.dark)),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: color.dark)),
                contentPadding: const EdgeInsets.all(5),
              ),
              cursorColor: color.dark,
              style: TextStyle(color: color.darker, fontSize: 20),
            ),
          ),
        ),
        TextButton(
          onPressed: () async {
            if (!hasMessage && chatData.eventId != chatData.chatId) {
              await chatData.createChatIfNotExists();
            }
            if (_messageController.text.trim() != "") {
              await ChatMessageData(
                      id: chatData.chatId,
                      eventId: chatData.eventId,
                      sender: sender,
                      timestamp: DateTime.now().millisecondsSinceEpoch,
                      message: _messageController.text.trim())
                  .save();
            }
            _messageController.text = "";
          },
          child: Container(
            padding: const EdgeInsets.only(right: 15),
            child: Icon(
              ArbennIcons.send,
              size: 30,
              color: color.darker,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: chatData.messages,
        builder: (BuildContext context,
            AsyncSnapshot<List<ChatMessageData>> messages) {
          if (messages.hasData) {
            bool hasMessage = messages.data!.isNotEmpty;
            return Padding(
                padding: const EdgeInsets.all(5),
                child: Column(children: [
                  Expanded(
                    child: ScrollList(
                      reverse: true,
                      color: color,
                      children: messages.data!
                          .map((m) => ChatMessage(
                              message: m,
                              color: color,
                              fromCurrentUser:
                                  sender.userId == m.sender.userId))
                          .toList(),
                    ),
                  ),
                  _buildInput(hasMessage)
                ]));
          } else if (messages.hasError) {
            return Column(children: [
              const Expanded(child: Text("Error")),
              _buildInput()
            ]);
          } else {
            return Column(
                children: [Expanded(child: Container()), _buildInput()]);
          }
        });
  }
}
