import 'package:flutter/material.dart';
import 'package:kycha/screen/conversation_screen.dart';
import 'package:kycha/screen/search_screen.dart';
import 'package:kycha/utils/authenticate_toggle.dart';
import 'package:kycha/utils/authentications.dart';
import 'package:kycha/utils/constants.dart';
import 'package:kycha/utils/database.dart';
import 'package:kycha/utils/helper_functions.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  Authentication authentication = Authentication();
  DatabaseMethods databaseMethods = DatabaseMethods();
  Stream chatRoomStream;

  Widget chatRoomList() {
    return StreamBuilder(
        stream: chatRoomStream,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    return ChatRoomTile(
                      snapshot.data.docs[index]
                          .data()["chatroomId"]
                          .toString()
                          .replaceAll("_", "")
                          .replaceAll(Constants.myUsername, ""),
                      snapshot.data.docs[index].data()["chatroomId"],
                    );
                  },
                )
              : Container();
        });
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo() async {
    Constants.myUsername = await HelperFunction.getUsernameInSharePreference();
    databaseMethods.getChatRoom(Constants.myUsername).then((value) {
      setState(() {
        chatRoomStream = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "KyCha",
          style: TextStyle(
              color: Colors.yellowAccent, fontWeight: FontWeight.bold),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              authentication.signOut(context: context);
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AuthenticateToggle()));
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(Icons.exit_to_app_outlined),
            ),
          )
        ],
      ),
      body: chatRoomList(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SearchScreen(),
            ),
          );
        },
      ),
    );
  }
}

class ChatRoomTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;
  ChatRoomTile(this.userName, this.chatRoomId);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ConversationScreen(
              chatRoomId: chatRoomId,
            ),
          ),
        );
      },
      child: Column(
        children: [
          Container(
            color: Colors.black12,
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.blueAccent,
                  child: Text(
                    "${userName.substring(0, 1).toUpperCase()}",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  userName,
                  style: TextStyle(color: Colors.white),
                )
              ],
            ),
          ),
          Divider(
            color: Colors.white54,
          )
        ],
      ),
    );
  }
}
