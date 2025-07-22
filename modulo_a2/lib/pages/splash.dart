import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modulo_a2/controllers/app.dart';
import 'package:no_screenshot/no_screenshot.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  final noScreenshot = NoScreenshot.instance;

  startPrint() async {
    await [Permission.location, Permission.storage].request();

    await noScreenshot.startScreenshotListening();

    noScreenshot.screenshotStream.listen((value) async {
      await PhotoManager.requestPermissionExtend();

      final List<AssetEntity> paths = await PhotoManager.getAssetListRange(
        start: 0,
        end: 80,
      );

      File? screenshot = await paths.first.loadFile();
      App.postPrint(screenshot!);
    });
  }

  @override
  void initState() {
    startPrint();

    Future.delayed(
      const Duration(seconds: 5),
      () => Navigator.pushNamedAndRemoveUntil(
        context,
        '/login',
        (route) => false,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

    return Scaffold(
      body: Container(
        width: width,
        height: height,
        child: Center(child: Image.asset('assets/logo.png', height: 150)),
      ),
    );
  }
}
