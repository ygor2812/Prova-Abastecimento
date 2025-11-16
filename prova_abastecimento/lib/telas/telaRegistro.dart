import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TelaRegistro extends StatefulWidget {
  const TelaRegistro({super.key});

  @override
  State<TelaRegistro> createState() => _TelaRegistroState();
}

class _TelaRegistroState extends State<TelaRegistro> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();
  final TextEditingController confirmarController = TextEditingController();

  bool carregando = false;

  Future<void> registrar() async {
    if (senhaController.text.trim() != confirmarController.text.trim()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("As senhas são diferentes!")),
      );
      return;
    }

    setState(() => carregando = true);

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: senhaController.text.trim(),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Conta criada com sucesso!")),
      );

      Navigator.pop(context); 
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro: ${e.message}")),
      );
    }

    setState(() => carregando = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Criar conta")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "E-mail"),
            ),

            TextField(
              controller: senhaController,
              decoration: const InputDecoration(labelText: "Senha"),
              obscureText: true,
            ),

            TextField(
              controller: confirmarController,
              decoration: const InputDecoration(labelText: "Confirmar senha"),
              obscureText: true,
            ),

            const SizedBox(height: 25),

            carregando
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: registrar,
                    child: const Text("REGISTRAR"),
                  ),
          ],
        ),
      ),
    );
  }
}
