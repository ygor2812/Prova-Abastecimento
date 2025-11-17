import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/authProvider.dart';

class TelaRegistro extends StatefulWidget {
  const TelaRegistro({super.key});

  @override
  State<TelaRegistro> createState() => _TelaRegistroState();
}

class _TelaRegistroState extends State<TelaRegistro> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();
  final TextEditingController confirmarController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Image.asset(
          "/assets/imagem/posto.jpg",
          width: 150,
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
            colors: [Colors.deepPurple, Colors.blueAccent],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            const Text(
              "Crie sua conta",
              style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            CupertinoTextField(
              controller: emailController,
              cursorColor: Colors.white,
              padding: const EdgeInsets.all(15),
              placeholder: "Digite seu e-mail",
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
              placeholder: "Crie uma senha",
              obscureText: true,
              placeholderStyle: const TextStyle(color: Colors.white70, fontSize: 14),
              style: const TextStyle(color: Colors.white, fontSize: 14),
              decoration: const BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.all(Radius.circular(7)),
              ),
            ),

            const SizedBox(height: 5),

            CupertinoTextField(
              controller: confirmarController,
              padding: const EdgeInsets.all(15),
              cursorColor: Colors.white,
              placeholder: "Confirme a senha",
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
              child: ElevatedButton(
                style:ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(17),
                backgroundColor: Colors.greenAccent,
                foregroundColor:Colors.black87,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
                ),
                child: auth.loading
                    ? const CupertinoActivityIndicator(color: Colors.black)
                    : const Text(
                        "REGISTRAR",
                        style: TextStyle(
                          color: Colors.black45,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                onPressed: auth.loading
                    ? null
                    : () async {
                        final email = emailController.text.trim();
                        final senha = senhaController.text.trim();
                        final confirma = confirmarController.text.trim();

                        if (email.isEmpty || senha.isEmpty || confirma.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Preencha todos os campos")),
                          );
                          return;
                        }
                        if (!email.contains('@')) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("E-mail inválido")),
                          );
                          return;
                        }
                        if (senha.length < 6) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Senha deve ter 6+ caracteres")),
                          );
                          return;
                        }
                        if (senha != confirma) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("As senhas não coincidem")),
                          );
                          return;
                        }

                        bool ok = await auth.registrar(email, senha);

                        if (ok) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Conta criada com sucesso!")),
                          );
                          Navigator.pop(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(auth.error ?? "Erro ao criar conta")),
                          );
                        }
                      },
              ),
            ),

            const SizedBox(height: 7),

            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white70, width: 0.8),
                borderRadius: BorderRadius.circular(7),
              ),
              child: ElevatedButton(
                child: const Text(
                  "VOLTAR",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}