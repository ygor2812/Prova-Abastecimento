import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'firebase_options.dart';
import 'telas/usuario/telaLogin.dart';
import 'telas/usuario/telaRegistro.dart';
import 'telas/TelaInicial.dart';
import 'telas/Veiculo/ListarVeiculo.dart';
import 'telas/Veiculo/CadastroVeiculo.dart';
import 'provider/authProvider.dart' as app;
import 'provider/veiculoProvider.dart';
import 'models/veiculo.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => app.AuthProvider()),
        ChangeNotifierProvider(create: (_) => VeiculoProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Controle de Veículos',
        theme: ThemeData(useMaterial3: true, colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)),
        initialRoute: '/',
        routes: {
          '/': (context) => const AuthWrapper(),
          '/login': (context) => const TelaLogin(),
          '/registro': (context) => const TelaRegistro(),
          '/home': (context) => const TelaInicial(),
          '/veiculos': (context) => const TelaListaVeiculos(),
          '/novo-veiculo': (context) => const TelaCadastroVeiculo(),
          '/editar-veiculo': (context) => TelaCadastroVeiculo(
                veiculo: ModalRoute.of(context)?.settings.arguments as Veiculo?,
              ),
        },
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (snapshot.hasData) {
          context.read<VeiculoProvider>().carregar();
          return const TelaInicial();
        }
        return const TelaLogin();
      },
    );
  }
}