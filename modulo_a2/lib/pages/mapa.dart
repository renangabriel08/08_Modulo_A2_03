import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:modulo_a2/controllers/app.dart';

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
                      onTap: () => showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Detalhes'),
                          content: SingleChildScrollView(child: Text('')),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('OK'),
                            ),
                          ],
                        ),
                      ),
                      position: LatLng(escola['latitude'], escola['longitude']),
                    ),
                },
                initialCameraPosition: CameraPosition(
                  target: LatLng(0, 0),
                  zoom: 17,
                ),
              ),
            ),
    );
  }
}
