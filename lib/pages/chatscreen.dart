import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart' as crypto;

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
late User loggedin;

class chatscreen extends StatefulWidget {
  static String id = 'chatscreen';
  const chatscreen({Key? key}) : super(key: key);

  @override
  State<chatscreen> createState() => _chatscreenState();
}

class _chatscreenState extends State<chatscreen> {
  final keyboard = TextEditingController();
  final _auth = FirebaseAuth.instance;

  late String message;

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

  String encrypt(String text) {
    final key = crypto.md5.convert(utf8.encode(loggedin.email)).toString();
    final encrypter = crypto.AES(
        Uint8List.fromList(utf8.encode(key.substring(0, 16))),
        crypto.AESMode.ecb);
    final encrypted = encrypter.encrypt(utf8.encode(text), padding: true);
    return base64.encode(encrypted.bytes);
  }

  String decrypt(String? text) {
    if (text == null) return '';
    final key = crypto.md5.convert(utf8.encode(loggedin.email)).toString();
    final encrypter = crypto.AES(
        Uint8List.fromList(utf8.encode(key.substring(0, 16))),
        crypto.AESMode.ecb);
    final decrypted = encrypter.decrypt64(text, padding: true);
    return utf8.decode(decrypted);
  }

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
          const StreamReceiver(),
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
                      hintText: "type your message here",
                    ),
                  ),
                ),
              ),
              TextButton(
                  onPressed: () {
                    keyboard.clear();
                    _firestore.collection('messages').add({
                      'Sender': loggedin.email,
                      'Text': encrypt(message), // Encrypt the message
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

class StreamReceiver extends StatelessWidget {
  const StreamReceiver({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream:
          _firestore.collection('messages').orderBy('Timestamp').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Please wait...");
        }
        if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Text("no messages available");
        }
        final extract = snapshot.data!.docs.reversed;
        List<StyledText> messages = [];
        for (var message in extract) {
          var messageText = decrypt(message.get('Text')); // Decrypt the message
          var sender = message.get('Sender');
          var currentUser = loggedin.email;
          var messageWidget = StyledText(
              text: messageText, sender: sender, isMe: currentUser == sender);
          messages.add(messageWidget);
        }
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              reverse: true,
              children: messages,
            ),
          ),
        );
      },
    );
  }
}

class StyledText extends StatelessWidget {
  final String text;
  final String sender;
  final bool isMe;
  const StyledText(
      {Key? key, required this.text, required this.sender, required this.isMe})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            "$sender",
            style: const TextStyle(fontSize: 12),
          ),
          Material(
            elevation: 15,
            borderRadius: isMe
                ? const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                    topLeft: Radius.circular(20))
                : const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                    topRight: Radius.circular(20)),
            color: isMe
                ? Colors.lightBlueAccent
                : const Color.fromARGB(255, 188, 184, 184),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                "$text",
                style: isMe
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
