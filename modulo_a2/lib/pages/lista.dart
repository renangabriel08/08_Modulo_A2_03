import 'package:flutter/material.dart';
import 'package:modulo_a2/controllers/app.dart';
import 'package:modulo_a2/styles/styles.dart';

class Lista extends StatefulWidget {
  const Lista({super.key});

  @override
  State<Lista> createState() => _ListaState();
}

class _ListaState extends State<Lista> {
  startApp() async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      App.escolas.clear();
      setState(() {});

      await App.validar(context);
      await App.getEscolas(context);

      App.escolas.sort((a, b) => a['nome'].compareTo(b['nome']));

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

    return Scaffold(
      appBar: AppBar(title: Text('Lista de Escolas')),
      body: App.escolas.isEmpty
          ? Center(child: CircularProgressIndicator())
          : SizedBox(
              width: width,
              height: height,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    for (var escola in App.escolas)
                      ListTile(
                        title: Text(
                          escola['nome'].toString(),
                          style: TextStyle(color: Cores.preto),
                        ),
                        trailing: SizedBox(
                          width: 120,
                          child: Row(
                            children: [
                              for (
                                int i = 0;
                                i < escola['avaliacao'].toInt();
                                i++
                              )
                                Icon(Icons.star, color: Colors.yellow),
                              for (
                                int i = escola['avaliacao'].toInt();
                                i < 5;
                                i++
                              )
                                Icon(Icons.star_outline, color: Colors.grey),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
    );
  }
}
