import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decode/jwt_decode.dart';
import 'package:modulo_a2/widgets/toast.dart';

class App {
  static Map user = {};
  static String token = '';
  static String motd = '';
  static List escolas = [];
  static List comentarios = [];
  static String base = 'https://workspace.dinizeotecnologia.com.br/worldskills';
  static bool lembrar = false;

  static logar(String email, String senha, BuildContext context) async {
    try {
      final url = Uri.parse('$base/jwt/generate_token');
      final req = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': senha}),
      );

      final res = jsonDecode(utf8.decode(req.bodyBytes));
      if (req.statusCode == 200) {
        token = res['token'];
        user = Jwt.parseJwt(token);
        user['senha'] = senha;
        await getMOTD();

        MyToast.get('Login realizado com sucesso!');
        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
      } else {
        print(req.statusCode);
        MyToast.get(res['error'].toString());
      }
    } catch (e) {
      MyToast.get('Erro ao realizar login');
    }
  }

  static validar(BuildContext context) async {
    try {
      final url = Uri.parse('$base/jwt/validate_token');
      final req = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'token': token}),
      );

      final res = jsonDecode(utf8.decode(req.bodyBytes));
      if (req.statusCode == 200) {
        MyToast.get('Token válidado com sucesso!');
      } else {
        MyToast.get(res['error']);
      }
    } catch (e) {
      MyToast.get('Erro ao validar token');
    }
  }

  static postComentario(id, String comentario) async {
    try {
      final url = Uri.parse('$base/A2/comments');
      final req = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'id_escola': id, 'comentario': comentario}),
      );

      final res = jsonDecode(utf8.decode(req.bodyBytes));
      if (req.statusCode == 200) {
        await getComentarios();
        MyToast.get('Comentário adicionado com sucesso!');
      } else {
        MyToast.get(res['error']);
      }
    } catch (e) {
      MyToast.get('Erro ao adicionar comentário');
    }
  }

  static getMOTD() async {
    try {
      final url = Uri.parse('$base/A2/motd');
      final req = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      final res = jsonDecode(utf8.decode(req.bodyBytes));
      if (req.statusCode == 200) {
        motd = res['MOTD'];
        MyToast.get('MOTD buscado com sucesso!');
      } else {
        MyToast.get(res['error']);
      }
    } catch (e) {
      MyToast.get('Erro ao buscar MOTD');
    }
  }

  static getEscolas(BuildContext context) async {
    try {
      final url = Uri.parse('$base/A2/school_list');
      final req = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      final res = jsonDecode(utf8.decode(req.bodyBytes));
      if (req.statusCode == 200) {
        escolas = res['escolas'];
        MyToast.get('Escolas buscadas com sucesso!');
      } else {
        MyToast.modal(res['error'], context);
      }
    } catch (e) {
      MyToast.modal('Erro ao buscar escolas', context);
    }
  }

  static getComentarios() async {
    try {
      final url = Uri.parse('$base/A2/comments');
      final req = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      final res = jsonDecode(utf8.decode(req.bodyBytes));
      if (req.statusCode == 200) {
        comentarios = res['comentarios'];
        MyToast.get('Comentários buscados com sucesso!');
      } else {
        MyToast.get(res['error']);
      }
    } catch (e) {
      MyToast.get('Erro ao buscar comentários');
    }
  }
}
