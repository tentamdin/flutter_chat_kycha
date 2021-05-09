import 'package:flutter/material.dart';
import 'package:kycha/utils/constants.dart';
import 'package:kycha/utils/database.dart';
import 'package:kycha/widgets/custom_textfield.dart';

class ConversationScreen extends StatefulWidget {
  final String chatRoomId;
  ConversationScreen({this.chatRoomId});
  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  DatabaseMethods databaseMethods = DatabaseMethods();
  TextEditingController messageController = TextEditingController();
  Stream chatStream;

  Widget chatList() {
    return StreamBuilder(
        stream: chatStream,
        builder: (context, snapShot) {
          return snapShot.hasData
              ? ListView.builder(
                  itemCount: snapShot.data.docs.length,
                  itemBuilder: (context, index) {
                    print("Snapshot msg $snapShot");
                    return MessageTile(
                      message: snapShot.data.docs[index].data()["message"],
                      isSendByMe: snapShot.data.docs[index].data()["sendBy"] ==
                          Constants.myUsername,
                      user: snapShot.data.docs[index].data()["sendBy"],
                    );
                  })
              : Container();
        });
  }

  sendMessage() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        "message": messageController.text,
        "sendBy": Constants.myUsername,
        "time": DateTime.now().millisecondsSinceEpoch,
      };
      databaseMethods.addChatMessages(widget.chatRoomId, messageMap);
      messageController.text = "";
    }
  }

  @override
  void initState() {
    databaseMethods.getChatMessages(widget.chatRoomId).then((value) {
      setState(() {
        chatStream = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "KyCha",
          style: TextStyle(color: Colors.yellow),
        ),
      ),
      body: Container(
        child: Stack(
          children: [
            chatList(),
            Container(
              alignment: Alignment.bottomCenter,
              padding: EdgeInsets.symmetric(
                horizontal: 10,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      textEditingController: messageController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter a username!';
                        } else {
                          return null;
                        }
                      },
                      // textEditingController: searchTextEditingController,
                      hintText: "send a chat",
                      iconData: Icons.add_a_photo,
                      obscureText: false,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.greenAccent,
                            Colors.green,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(40)),
                    child: IconButton(
                      icon: Icon(Icons.send_rounded),
                      onPressed: () {
                        sendMessage();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool isSendByMe;
  final String user;
  MessageTile({this.message, this.isSendByMe, this.user});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 10,
        right: 10,
      ),
      margin: EdgeInsets.symmetric(
        vertical: 6,
      ),
      width: isSendByMe
          ? MediaQuery.of(context).size.width
          : MediaQuery.of(context).size.width - 40,
      child: Row(
        mainAxisAlignment:
            isSendByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          isSendByMe
              ? Container()
              : Padding(
                  padding: const EdgeInsets.only(top: 20, right: 10),
                  child: CircleAvatar(
                    backgroundColor: Colors.blueAccent,
                    child: Text(
                      "${user.substring(0, 1).toUpperCase()}",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isSendByMe
                        ? [
                            Colors.white10,
                            Colors.white12,
                          ]
                        : [
                            Colors.blueAccent,
                            Colors.blue,
                          ],
                  ),
                  borderRadius: isSendByMe
                      ? BorderRadius.only(
                          topLeft: Radius.circular(23),
                          topRight: Radius.circular(23),
                          bottomLeft: Radius.circular(23),
                        )
                      : BorderRadius.only(
                          topLeft: Radius.circular(23),
                          topRight: Radius.circular(23),
                          bottomRight: Radius.circular(23),
                        )),
              child: Text(
                message,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//
// isSendByMe
// ? Container()
//     : CircleAvatar(
// backgroundColor: Colors.blueAccent,
// child: Text(
// "${user.substring(0, 1).toUpperCase()}",
// style: TextStyle(color: Colors.white),
// ),
// ),
