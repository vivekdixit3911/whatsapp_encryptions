// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
late User loggedin;

class chatscreen extends StatefulWidget {
  static String id = 'chatscreen';
  const chatscreen({super.key});

  @override
  State<chatscreen> createState() => chatscreenState();
}

class chatscreenState extends State<chatscreen> {
  final keyboard = TextEditingController();
  final _auth = FirebaseAuth.instance;

  late String message;

  var getter;

  @override
  void initState() {
    super.initState();
    userinfo();
  }

  void userinfo() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedin = user;
      }
    } catch (e) {
      print(e);
    }
  }

// this code gives the messages when called from firestroe or say when pressed any button
  // void getMessages() async {
  //   getter = await _firestore.collection("messages").get();
  //   for (var messages in getter.docs) {
  //     print(messages.data());
  //   }
  // }

  // Future<void> getMessagesinStream() async {
  //   await for (var get in _firestore.collection('messages').snapshots()) {
  //     for (var gives in get.docs) {
  //       print(gives.data());
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("✨Chats"),
        backgroundColor: Colors.deepPurple,
        actions: [
          TextButton(
            child: const Icon(
              Icons.logout,
              color: Colors.black,
            ),
            onPressed: () {
              _auth.signOut();
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const streamreciever(),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 310,
                  child: TextField(
                    controller: keyboard,
                    onChanged: (value) {
                      message = value;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                      hintText: "type your mesage here",
                    ),
                  ),
                ),
              ),
              TextButton(
                  onPressed: () {
                    keyboard.clear();
                    _firestore.collection('messages').add({
                      'Sender': loggedin.email,
                      'Text': message,
                      'Timestamp': FieldValue.serverTimestamp(),
                    });
                  },
                  child: const CircleAvatar(
                    backgroundColor: Color.fromARGB(255, 3, 255, 205),
                    child: Icon(Icons.send, color: Colors.white),
                  )),
            ],
          ),
        ],
      ),
    );
  }
}

class streamreciever extends StatelessWidget {
  const streamreciever({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream:
          _firestore.collection('messages').orderBy('Timestamp').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("aa rhe sabr karo ");
        }
        if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Text("no message avilable");
        }
        final extract = snapshot.data!.docs.reversed;
        List<styeletext> messdis = [];
        for (var messages in extract) {
          var messagetext = messages.get('Text');
          var sender = messages.get('Sender');
          var currentuser = loggedin.email;
          var messagewidget = styeletext(
              text: messagetext, sender: sender, isme: currentuser == sender);
          messdis.add(messagewidget);
        }
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              // physics: BouncingScrollPhysics(),
              reverse: true,
              children: messdis,
            ),
          ),
        );
      },
    );
  }
}

class styeletext extends StatelessWidget {
  final text;
  final sender;
  final bool isme;
  const styeletext(
      {super.key,
      required this.text,
      required this.sender,
      required this.isme});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isme ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            "$sender",
            style: const TextStyle(fontSize: 12),
          ),
          Material(
            elevation: 15,
            borderRadius: isme
                ? const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                    topLeft: Radius.circular(20))
                : const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                    topRight: Radius.circular(20)),
            color: isme
                ? Colors.lightBlueAccent
                : const Color.fromARGB(255, 188, 184, 184),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                "$text",
                style: isme
                    ? const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      )
                    : const TextStyle(
                        fontSize: 18,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
