import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xff1A365D),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/logo.png", width: 300),
              const TextField(
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    label: Text("E-mail"),
                    labelStyle: TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 16),
              const TextField(
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    label: Text("Senha"),
                    labelStyle: TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, "/"),
                  style:
                      ElevatedButton.styleFrom(fixedSize: const Size(200, 50)),
                  child: const Text("Entrar"))
            ],
          ),
        ),
      ),
    );
  }
}
