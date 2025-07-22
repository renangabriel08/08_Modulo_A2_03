import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:modulo_a2/controllers/app.dart';
import 'package:modulo_a2/styles/styles.dart';

class Mapa extends StatefulWidget {
  const Mapa({super.key});

  @override
  State<Mapa> createState() => _MapaState();
}

class _MapaState extends State<Mapa> {
  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }

    return await Geolocator.getCurrentPosition();
  }

  LatLng pos = LatLng(0, 0);

  startApp() async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      App.escolas.clear();
      setState(() {});

      await App.validar(context);
      await App.getEscolas(context);

      Position position = await determinePosition();
      pos = LatLng(position.latitude, position.longitude);

      if (App.escola['nome'] != null) {
        double dis = Geolocator.distanceBetween(
          pos.latitude,
          pos.longitude,
          App.escola['latitude'],
          App.escola['longitude'],
        );

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(App.escola['nome'].toString()),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * .3,
                    height: MediaQuery.of(context).size.width * .15,
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (
                          int i = 0;
                          i < App.escola['avaliacao'].toInt();
                          i++
                        )
                          Icon(Icons.star, color: Colors.yellow, size: 35),
                        for (
                          int i = App.escola['avaliacao'].toInt();
                          i < 5;
                          i++
                        )
                          Icon(
                            Icons.star_outline,
                            color: Colors.grey,
                            size: 35,
                          ),
                      ],
                    ),
                  ),
                  Container(height: 16),
                  Text(
                    dis < 1000
                        ? 'Distância: ${dis.toStringAsFixed(2)}m'
                        : 'Distância: ${(dis / 1000).toStringAsFixed(2)}Km',
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Fechar'),
              ),

              TextButton(
                onPressed: () {
                  App.escola = App.escola;
                  Navigator.pushNamed(context, '/detalhes');
                },
                child: Text('Detlhes da Escola'),
              ),
            ],
          ),
        );
      }

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
      appBar: AppBar(),
      body: App.escolas.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Container(
              width: width,
              height: height,
              child: GoogleMap(
                myLocationButtonEnabled: true,
                myLocationEnabled: true,
                markers: {
                  for (var escola in App.escolas)
                    Marker(
                      markerId: MarkerId(escola['id'].toString()),
                      onTap: () {
                        double dis = Geolocator.distanceBetween(
                          pos.latitude,
                          pos.longitude,
                          escola['latitude'],
                          escola['longitude'],
                        );

                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text(escola['nome'].toString()),
                            content: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Container(
                                    width: width * .3,
                                    height: width * .15,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 2,
                                        color: Cores.preto,
                                      ),
                                    ),
                                    child: Image.memory(
                                      base64Decode(
                                        escola['image'].toString().substring(
                                          escola['image'].toString().indexOf(
                                                ',',
                                              ) +
                                              1,
                                        ),
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Container(height: 16),
                                  SizedBox(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        for (
                                          int i = 0;
                                          i < escola['avaliacao'].toInt();
                                          i++
                                        )
                                          Icon(
                                            Icons.star,
                                            color: Colors.yellow,
                                            size: 35,
                                          ),
                                        for (
                                          int i = escola['avaliacao'].toInt();
                                          i < 5;
                                          i++
                                        )
                                          Icon(
                                            Icons.star_outline,
                                            color: Colors.grey,
                                            size: 35,
                                          ),
                                      ],
                                    ),
                                  ),
                                  Container(height: 16),
                                  Text(
                                    dis < 1000
                                        ? 'Distância: ${dis.toStringAsFixed(2)}m'
                                        : 'Distância: ${(dis / 1000).toStringAsFixed(2)}Km',
                                  ),
                                ],
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text('Fechar'),
                              ),

                              TextButton(
                                onPressed: () {
                                  App.escola = escola;
                                  Navigator.pushNamed(context, '/detalhes');
                                },
                                child: Text('Detlhes da Escola'),
                              ),
                            ],
                          ),
                        );
                      },
                      position: LatLng(escola['latitude'], escola['longitude']),
                    ),
                },
                initialCameraPosition: CameraPosition(target: pos, zoom: 17),
              ),
            ),
    );
  }
}
