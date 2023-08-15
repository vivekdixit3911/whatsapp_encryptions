import 'package:flutter/material.dart';

var inputdecorusernmae = InputDecoration(
  labelText: "Username",
  hintText: "username",
  fillColor: Colors.amberAccent,
  focusColor: Colors.amberAccent,
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(50),
    borderSide: const BorderSide(color: Colors.amberAccent),
  ),
  icon: const CircleAvatar(
    backgroundColor: Colors.grey,
    child: Icon(
      Icons.account_circle_sharp,
      color: Color.fromARGB(255, 0, 0, 0),
    ),
  ),
);

var inputdecorpassword = InputDecoration(
  labelText: "Password",
  hintText: "Password",
  fillColor: const Color.fromARGB(255, 98, 6, 246),
  focusColor: const Color.fromARGB(255, 98, 6, 246),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(50),
    borderSide: const BorderSide(color: Colors.amberAccent),
  ),
  icon: const CircleAvatar(
    backgroundColor: Colors.grey,
    child: Icon(
      Icons.password,
      color: Color.fromARGB(255, 0, 0, 0),
    ),
  ),
);
