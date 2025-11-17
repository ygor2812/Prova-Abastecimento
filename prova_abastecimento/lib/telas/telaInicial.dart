import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/authProvider.dart' as app;

class TelaInicial extends StatelessWidget {
  const TelaInicial({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Image.asset(
          "assets/imagem/posto.jpg",
          width: 300,
          height: 150,
        ),
        elevation: 10,
        backgroundColor: Colors.transparent,
      ),
     drawer: Drawer(
  child: Container(
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        colors: [Colors.deepPurple, Colors.blueAccent],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    ),
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          decoration: const BoxDecoration(color: Colors.transparent),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/imagem/posto.jpg",
                width: 140,
                height: 90,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 10),
              const Text(
                "Controle de Abastecimento",
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),

        ListTile(
          leading: const Icon(Icons.directions_car, color: Colors.white),
          title: const Text("Meus Veículos", style: TextStyle(color: Colors.white)),
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/veiculos');
          },
        ),

        ListTile(
          leading: const Icon(Icons.local_gas_station, color: Colors.white),
          title: const Text("Abastecer Veículo", style: TextStyle(color: Colors.white)),
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/veiculos');
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Selecione o veículo para registrar o abastecimento"),
                duration: Duration(seconds: 2),
              ),
            );
          },
        ),

        ListTile(
          leading: const Icon(Icons.history, color: Colors.white),
          title: const Text("Histórico de Abastecimentos", style: TextStyle(color: Colors.white)),
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/veiculos');
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Selecione o veículo para ver o histórico"),
                duration: Duration(seconds: 2),
              ),
            );
          },
        ),

        const Divider(color: Colors.white30, height: 20),

        ListTile(
          leading: const Icon(Icons.logout, color: Colors.white),
          title: const Text("Sair", style: TextStyle(color: Colors.white)),
          onTap: () async {
            await context.read<app.AuthProvider>().logout();
            if (context.mounted) {
              Navigator.pushReplacementNamed(context, '/login');
            }
          },
        ),
      ],
    ),
  ),
),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(27),
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Colors.deepPurple, Colors.blueAccent]),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 120),
            const Text(
              "Bem-vindo!",
              style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              child: CupertinoButton(
                padding: const EdgeInsets.all(17),
                color: Colors.greenAccent,
                child: const Text(
                  "MEUS VEÍCULOS",
                  style: TextStyle(color: Colors.black45, fontSize: 16, fontWeight: FontWeight.w600),
                ),
                onPressed: () => Navigator.pushNamed(context, '/veiculos'),
              ),
            ),

            const SizedBox(height: 10),

            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white70, width: 0.8),
                borderRadius: BorderRadius.circular(7),
              ),
              child: ElevatedButton(
                child: const Text(
                  "SAIR",
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                ),
                onPressed: () async {
                  await context.read<app.AuthProvider>().logout();
                  Navigator.pushReplacementNamed(context, '/login');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}