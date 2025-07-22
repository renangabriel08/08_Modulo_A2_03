import 'package:flutter/material.dart';
import 'package:modulo_a2/controllers/app.dart';
import 'package:modulo_a2/styles/styles.dart';
import 'package:modulo_a2/widgets/toast.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController email = TextEditingController();
  TextEditingController senha = TextEditingController();

  var formKey = GlobalKey<FormState>();

  logar() {
    if (formKey.currentState!.validate()) {
      App.logar(email.text, senha.text, context);
    } else {
      MyToast.get('Preencha todos os campos corretamente');
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        width: width,
        height: height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: email,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Campo obrigatório';
                }

                return null;
              },
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(),
              ),
            ),
            Container(height: 16),
            TextFormField(
              controller: senha,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Campo obrigatório';
                }

                return null;
              },
              decoration: InputDecoration(
                labelText: 'Senha',
                prefixIcon: Icon(Icons.lock),
                border: OutlineInputBorder(),
              ),
            ),
            Container(height: 16),
            Row(
              children: [
                Checkbox(
                  value: App.lembrar,
                  onChanged: (value) {
                    App.lembrar = value!;
                    setState(() {});
                  },
                ),
                Text('mantenha-me conectado'),
              ],
            ),
            Container(height: 16),
            ElevatedButton(
              onPressed: () => logar(),
              style: ElevatedButton.styleFrom(
                fixedSize: Size(width, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(10),
                ),
                backgroundColor: Cores.azulClaro,
              ),
              child: Text('Login', style: TextStyle(color: Cores.branco)),
            ),
          ],
        ),
      ),
    );
  }
}
