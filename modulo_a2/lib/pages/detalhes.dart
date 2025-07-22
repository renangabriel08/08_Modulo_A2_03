import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:modulo_a2/controllers/app.dart';
import 'package:modulo_a2/styles/styles.dart';
import 'package:modulo_a2/widgets/toast.dart';

class Detalhes extends StatefulWidget {
  const Detalhes({super.key});

  @override
  State<Detalhes> createState() => _DetalhesState();
}

class _DetalhesState extends State<Detalhes> {
  TextEditingController comentario = TextEditingController();

  startApp() async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await App.validar(context);
      await App.getComentarios();

      setState(() {});
    });
  }

  modal() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Adionar um comentário'),
        content: SingleChildScrollView(
          child: TextFormField(
            controller: comentario,
            decoration: InputDecoration(
              labelText: 'Comentário',
              prefixIcon: Icon(Icons.description),
              border: OutlineInputBorder(),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              if (comentario.text.isEmpty) {
                MyToast.get('Campo inválido');
              } else {
                await App.postComentario(App.escola['id'], comentario.text);
                Navigator.pop(context);
                setState(() {});
              }
            },
            child: Text('Salvar'),
          ),
        ],
      ),
    );
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
      appBar: AppBar(title: Text('Detalhes da escola')),
      body: Container(
        width: width,
        height: height,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  App.escola['nome'],
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Cores.azulEscuro,
                  ),
                ),
                Container(height: 16),
                Container(
                  width: width * .5,
                  height: width * .25,
                  decoration: BoxDecoration(
                    border: Border.all(width: 2, color: Cores.preto),
                  ),
                  child: Image.memory(
                    base64Decode(
                      App.escola['image'].toString().substring(
                        App.escola['image'].toString().indexOf(',') + 1,
                      ),
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                Container(height: 16),
                SizedBox(
                  width: width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (int i = 0; i < App.escola['avaliacao'].toInt(); i++)
                        Icon(Icons.star, color: Colors.yellow, size: 40),
                      for (int i = App.escola['avaliacao'].toInt(); i < 5; i++)
                        Icon(Icons.star_outline, color: Colors.grey, size: 40),
                    ],
                  ),
                ),
                Container(height: 16),
                Row(
                  children: [
                    Text(
                      'Comentários',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Cores.preto,
                      ),
                    ),
                  ],
                ),
                Container(height: 16),
                Column(
                  children: [
                    for (var comentario in App.comentarios)
                      if (comentario['id_escola'].toString() ==
                          App.escola['id'].toString())
                        ListTile(
                          title: Text(comentario['comentario']),
                          subtitle: Text(comentario['data_hora']),
                        ),
                  ],
                ),
                Container(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () => modal(),
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(width * .4, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(10),
                        ),
                        backgroundColor: Cores.azulClaro,
                      ),
                      child: Text(
                        'Fazer comentário',
                        style: TextStyle(color: Cores.branco),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.pushNamed(context, '/mapa'),
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(width * .4, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(10),
                        ),
                        backgroundColor: Cores.azulClaro,
                      ),
                      child: Text(
                        'Mapa',
                        style: TextStyle(color: Cores.branco),
                      ),
                    ),
                  ],
                ),
                Container(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
