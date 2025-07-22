import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decode/jwt_decode.dart';
import 'package:modulo_a2/widgets/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class App {
  static Map user = {};
  static Map escola = {};
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
        await salvarDados();

        int tempo = DateTime.fromMillisecondsSinceEpoch(
          user['exp'] * 1000,
        ).difference(DateTime.now()).inMinutes;

        Future.delayed(
          Duration(minutes: tempo),
          () => renovar(user['email'], user['senha'], context),
        );

        MyToast.get('Login realizado com sucesso!');
        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
      } else {
        MyToast.get(res['error'].toString());
      }
    } catch (e) {
      MyToast.get('Erro ao realizar login');
    }
  }

  static renovar(String email, String senha, BuildContext context) async {
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

        MyToast.get('Token renovado com sucesso!');
        int tempo = DateTime.fromMillisecondsSinceEpoch(
          user['exp'] * 1000,
        ).difference(DateTime.now()).inMinutes;

        Future.delayed(
          Duration(minutes: tempo),
          () => renovar(user['email'], user['senha'], context),
        );
      } else {
        MyToast.get(res['error'].toString());
      }
    } catch (e) {
      MyToast.get('Erro ao renovar token');
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

      if (req.statusCode == 200) {
        MyToast.get('Token válidado com sucesso!');
      } else {
        MyToast.get('Erro ao validar token, entre novamente');
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      }
    } catch (e) {
      MyToast.get('Erro ao validar token, entre novamente');
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
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

  static postPrint(File print) async {
    try {
      final url = Uri.parse('$base/A2/prints');
      final req = http.MultipartRequest('POST', url);

      req.files.add(
        http.MultipartFile(
          'imagem',
          print.openRead(),
          print.lengthSync(),
          filename: print.path,
        ),
      );
      req.fields['id_user'] = user['id'] ?? '1';
      final request = await req.send();

      if (request.statusCode == 200) {
        MyToast.get('Print enviado para nossa base de dados com sucesso!');
      } else {
        MyToast.get(
          'Erro ${request.statusCode} ao enviar print para nossa base de dados',
        );
      }
    } catch (e) {
      MyToast.get('Erro ao enviar print para nossa base de dados');
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

  static salvarDados() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('user', jsonEncode(user));
      await prefs.setBool('lembrar', lembrar);
    } catch (e) {
      MyToast.get('Erro ao salvar dados');
    }
  }

  static apagarDados() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('user');
      await prefs.remove('lembrar');
    } catch (e) {
      MyToast.get('Erro ao apagar dados');
    }
  }

  static getDados() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? userJson = prefs.getString('user');
      final bool? lembrarJson = prefs.getBool('lembrar');

      if (lembrarJson != null && userJson != null) {
        user = jsonDecode(userJson);
        lembrar = lembrarJson;
      } else {
        lembrar = false;
        user = {};
      }
    } catch (e) {
      MyToast.get('Erro ao buscar dados');
    }
  }
}
