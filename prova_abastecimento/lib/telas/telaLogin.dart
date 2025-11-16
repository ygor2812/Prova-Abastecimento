import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../telas/telaRegistro.dart';

class TelaLogin extends StatefulWidget {
  const TelaLogin({super.key});

  @override
  State<TelaLogin> createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();

  bool carregando = false;

  Future<void> fazerLogin() async {
    if (emailController.text.trim().isEmpty ||
        senhaController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("PREENCHA TODOS OS CAMPOS ... -_-")),
      );
      return;
    }

    setState(() => carregando = true);

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: senhaController.text.trim(),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login feito com sucesso.")),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("ERRO: ${e.message}")),
      );
    }

    setState(() => carregando = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,

      appBar: AppBar(
        title: Image.asset(
          "assets/imagem/marcas-de-carros-de-luxo-lamborghini.jpg",
          width: 300,
          height: 150,
          
        ),
        elevation: 10,
        backgroundColor: Colors.transparent,
      ),

      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(27),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.deepPurple,
              Colors.blueAccent,
            ],
          ),
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 30),

            const Text(
              "Digite os dados nos campos abaixo",
              style: TextStyle(color: Colors.white),
            ),

            const SizedBox(height: 20),

            CupertinoTextField(
              controller: emailController,
              cursorColor: Colors.white,
              padding: const EdgeInsets.all(15),
              placeholder: "Digite o seu email",
              placeholderStyle: const TextStyle(color: Colors.white70, fontSize: 14),
              style: const TextStyle(color: Colors.white, fontSize: 14),
              decoration: const BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.all(Radius.circular(7)),
              ),
            ),

            const SizedBox(height: 5),

            CupertinoTextField(
              controller: senhaController,
              padding: const EdgeInsets.all(15),
              cursorColor: Colors.white,
              placeholder: "Digite sua senha",
              obscureText: true,
              placeholderStyle: const TextStyle(color: Colors.white70, fontSize: 14),
              style: const TextStyle(color: Colors.white, fontSize: 14),
              decoration: const BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.all(Radius.circular(7)),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: CupertinoButton(
                padding: const EdgeInsets.all(17),
                color: Colors.greenAccent,
                child: carregando
                    ? const CupertinoActivityIndicator(color: Colors.black)
                    : const Text(
                        "ACESSAR",
                        style: TextStyle(
                          color: Colors.black45,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                onPressed: carregando ? null : fazerLogin,
              ),
            ),

            const SizedBox(height: 7),

            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white70, width: 0.8),
                borderRadius: BorderRadius.circular(7),
              ),
              child: CupertinoButton(
                child: const Text(
                  "CRIE SUA CONTA",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const TelaRegistro()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
