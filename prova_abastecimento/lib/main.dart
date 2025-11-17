import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'firebase_options.dart';
import 'telas/usuario/telaLogin.dart';
import 'telas/usuario/telaRegistro.dart';
import 'telas/TelaInicial.dart';
import 'telas/veiculo/ListarVeiculo.dart';
import 'telas/veiculo/CadastroVeiculo.dart';
import 'provider/authProvider.dart' as app;
import 'provider/veiculoProvider.dart';
import 'models/veiculo.dart';
import 'provider/abastecimentoProvider.dart';
import 'telas/abastecimento/listarAbastecimento.dart';

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
        ChangeNotifierProvider(create: (_) => AbastecimentoProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Controle de Veículos',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          scaffoldBackgroundColor: Colors.transparent,
          appBarTheme: const AppBarTheme(
          elevation:0,
          ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.greenAccent,
            foregroundColor:Colors.black45,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
          ),
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color:Colors.white),
        ),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders:{
            TargetPlatform.android: ZoomPageTransitionsBuilder(),
            TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
          },
        ),
      ),
        initialRoute: '/',
        routes: {
          '/': (context) => const AuthWrapper(),
          '/login': (context) => const TelaLogin(),
          '/registro': (context) => const TelaRegistro(),
          '/home': (context) => const TelaInicial(),
          '/veiculos': (context) => TelaListarVeiculos(),
          '/novo-veiculo': (context) => TelaCadastroVeiculo(),
          '/editar-veiculo': (context) {
            final veiculo = ModalRoute.of(context)?.settings.arguments as Veiculo?;
            return TelaCadastroVeiculo(veiculo: veiculo);
          },
          '/abastecimentos': (context) {
            final veiculoId = ModalRoute.of(context)!.settings.arguments as String;
            return TelaListarAbastecimento(veiculoId: veiculoId);
          },
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