import 'package:flutter/material.dart';
import 'package:modulo_a2/controllers/app.dart';

class Detalhes extends StatefulWidget {
  const Detalhes({super.key});

  @override
  State<Detalhes> createState() => _DetalhesState();
}

class _DetalhesState extends State<Detalhes> {
  startApp() async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await App.validar(context);
      await App.getComentarios();

      setState(() {});
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

    return Scaffold(body: Container());
  }
}
