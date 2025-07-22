import 'package:flutter/material.dart';
import 'package:modulo_a2/pages/detalhes.dart';
import 'package:modulo_a2/pages/home.dart';
import 'package:modulo_a2/pages/lista.dart';
import 'package:modulo_a2/pages/login.dart';
import 'package:modulo_a2/pages/mapa.dart';
import 'package:modulo_a2/pages/splash.dart';
import 'package:modulo_a2/styles/styles.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Cores.azulClaro),
      ),
      routes: {
        '/splash': (context) => const Splash(),
        '/login': (context) => const Login(),
        '/home': (context) => const Home(),
        '/escolas': (context) => const Lista(),
        '/mapa': (context) => const Mapa(),
        '/detalhes': (context) => const Detalhes(),
      },
      initialRoute: '/home',
    );
  }
}
