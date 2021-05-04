import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kycha/utils/database.dart';
import 'package:kycha/widgets/custom_textfield.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _formKey = GlobalKey<FormState>();
  DatabaseMethods databaseMethods = DatabaseMethods();
  TextEditingController searchTextEditingController = TextEditingController();

  QuerySnapshot searchSnapshot;

  void searchUser() {
    if (_formKey.currentState.validate()) {
      databaseMethods.getUserByUsername(searchTextEditingController.text).then(
        (snapshot) {
          print("snapshor ${snapshot.toString()}");
          setState(
            () {
              searchSnapshot = snapshot;
            },
          );
        },
      );
    }
  }

  //make chat-room and chat
  // createChatroomAndChat(String username) {
  //   List<String> users = [];
  //   databaseMethods.createChatRoom();
  // }

  Widget searchList() {
    return searchSnapshot != null
        ? ListView.builder(
            itemCount: searchSnapshot.docs.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return SearchTile(
                username: searchSnapshot.docs[index].data()["username"],
                email: searchSnapshot.docs[index].data()["email"],
              );
            },
          )
        : Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("KyCha"),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 10,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Form(
                    key: _formKey,
                    child: Expanded(
                      child: CustomTextField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter a username!';
                          } else {
                            return null;
                          }
                        },
                        textEditingController: searchTextEditingController,
                        hintText: "search username ...",
                        iconData: null,
                        obscureText: false,
                      ),
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
                      icon: Icon(Icons.search),
                      onPressed: () {
                        searchUser();
                      },
                    ),
                  ),
                ],
              ),
              searchList(),
            ],
          ),
        ),
      ),
    );
  }
}

class SearchTile extends StatelessWidget {
  final String username;
  final String email;
  SearchTile({this.username, this.email});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                username,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              Text(
                email,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
          Spacer(),
          Container(
            child: ElevatedButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
              ),
              onPressed: () {},
              child: Text(
                "Message",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
