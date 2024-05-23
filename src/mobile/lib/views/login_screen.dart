import 'package:asky/api/authentication_api.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  final authenticationApi = AuthenticationApi();

  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

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
              TextField(
                controller: emailCtrl,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                    label: Text("E-mail"),
                    labelStyle: TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passCtrl,
                style: const TextStyle(color: Colors.white),
                obscureText: true,
                decoration: const InputDecoration(
                    label: Text("Senha"),
                    labelStyle: TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                  onPressed: () async {
                    await authenticationApi
                        .singIn(emailCtrl.text, passCtrl.text)
                        .then((c) => Navigator.pushNamed(context, "/"));
                  },
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
