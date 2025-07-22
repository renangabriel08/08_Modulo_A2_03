import 'package:flutter/material.dart';
import 'package:modulo_a2/controllers/app.dart';
import 'package:modulo_a2/styles/styles.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  startApp() async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await App.validar(context);
    });
  }

  @override
  void initState() {
    startApp();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(title: Text('Bem-vindo, ${App.user['name']}')),
      drawer: Drawer(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Container(height: 40),
              Row(
                children: [
                  Image.asset('assets/icon.png', height: 50),
                  Container(width: 16),
                  Text(
                    'SafeEdu',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Container(height: 16),
              ListTile(
                title: Text(
                  'Home',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Cores.azulEscuro,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Lista de escolas'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/escolas');
                },
              ),
              ListTile(
                title: Text('Mapa'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/mapa');
                },
              ),
              ListTile(
                title: Text('Logout'),
                onTap: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/login',
                    (route) => false,
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: Container(
        width: width,
        height: height,
        child: Center(
          child: Text(
            App.motd,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
