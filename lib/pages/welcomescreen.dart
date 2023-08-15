// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:mess/pages/loginscreen.dart';
import 'package:mess/pages/registerscreen.dart';
import '../decorations/welocmescreenbuttons.dart';
import 'package:flutter_svg/svg.dart';

class welcomeScreen extends StatefulWidget {
  static String id = "welcomeScreen";
  const welcomeScreen({super.key});

  @override
  State<welcomeScreen> createState() => _welcomeScreenState();
}

class _welcomeScreenState extends State<welcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ListView(
          children: [
            Center(
              child: Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 178, 193, 203),
                    // gradient: SweepGradient(colors: Colors.accents)
                  ),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 15,
                      ),
                      Container(
                        height: 400,
                        width: 370,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 240, 231, 140),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: SvgPicture.asset(
                          'asset/image2.svg',
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Hero(
                        tag: "logo",
                        child: CircleAvatar(
                          backgroundImage: AssetImage("asset/logo.jpg"),
                          radius: 50,
                        ),
                      ),
                      const Text(
                        "Discover your",
                        style: TextStyle(
                            fontSize: 28, fontWeight: FontWeight.w700),
                      ),
                      const Text(
                        "Dream chat App",
                        style: TextStyle(
                            fontSize: 28, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Text(
                        "Explore all the most exiting features",
                        style: TextStyle(color: Colors.black38),
                      ),
                      const Text("based on the Firease and user Experience",
                          style: TextStyle(color: Colors.black38)),
                      const SizedBox(
                        height: 40,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          welocmeScreen_button_register_and_login(
                            buttotext: "Register",
                            onpressed: () {
                              Navigator.pushNamed(context, registerpage.id);
                            },
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          welocmeScreen_button_register_and_login(
                            buttotext: "Login",
                            onpressed: () {
                              Navigator.pushNamed(context, loginscreen.id);
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
