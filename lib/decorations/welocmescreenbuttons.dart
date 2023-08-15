// ignore_for_file: camel_case_types, use_key_in_widget_constructors

import 'package:flutter/material.dart';

class welocmeScreen_button_register_and_login extends StatelessWidget {
  final String buttotext;
  final Function() onpressed;
  const welocmeScreen_button_register_and_login(
      {required this.buttotext, required this.onpressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onpressed,
      child: Container(
        height: 50,
        width: 150,
        decoration: BoxDecoration(
            color: const Color.fromARGB(221, 227, 210, 210),
            borderRadius: BorderRadius.circular(15)),
        child: Center(
          child: Text(
            buttotext,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontWeight: FontWeight.w700, fontSize: 18, color: Colors.black),
          ),
        ),
      ),
    );
  }
}

//
//
//
//

// LAST RED WALA BUTTON

class lastredbutton_register_login extends StatelessWidget {
  final String text;
  final Function() onpressed;
  const lastredbutton_register_login(
      {required this.text, required this.onpressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onpressed,
      style: const ButtonStyle(
        backgroundColor: MaterialStatePropertyAll(Colors.redAccent),
      ),
      child: Padding(
        padding: const EdgeInsets.only(right: 90, left: 90),
        child: Text(text, style: const TextStyle(fontSize: 18)),
      ),
    );
  }
}
