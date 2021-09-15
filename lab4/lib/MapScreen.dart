import 'dart:async';

import 'package:flutter/material.dart';
import 'package:laba3/DetailedScreen.dart';
import 'package:laba3/CPU.dart';
import 'package:laba3/models/locale.modal.dart';
import 'package:laba3/models/theme.model.dart';
import 'package:laba3/utils/firebase.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;


class MapScreen extends StatefulWidget {
  MapScreen({Key key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Completer<GoogleMapController> _controller = Completer();
  List<CPU> cpus = [];
  String _mapStyle;

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(53.9006, 27.5590),
    zoom: 8,
  );

  @override
  void initState() {
    loadCPUs();
    super.initState();
    rootBundle.loadString('assets/map/dark.json').then((string) {
      _mapStyle = string;
    });
  }

  loadCPUs() async {
    var loaded = await FirebaseHelper.getAllCPUs();
    setState(() {
      cpus = loaded;
    });
  }

  LatLng _getLatLng(CPU cpu) {
    try {
      double lat = double.parse(cpu.latitude);
      double lng = double.parse(cpu.longitude);
      return new LatLng(lat, lng);
    } catch (e) {
      return new LatLng(0, 0);
    }
  }

  void rerender() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Provider.of<LocaleModel>(context).getString("map")),
      ),
      body: GoogleMap(
        // mapType: MapType.normal,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          if (Provider.of<ThemeModel>(context, listen: false).isDark) {
            controller.setMapStyle(_mapStyle);
          }
          _controller.complete(controller);
        },
        markers: cpus
            .map((cpu) => Marker(
          markerId: new MarkerId(cpu.id),
          position: _getLatLng(cpu),
          infoWindow: InfoWindow(
              title: "${cpu.model} ${cpu.manufacturer}",
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => DetailedScreen(
                        cpu: cpu,
                        rerender: this.rerender,
                      )))),
        ))
            .toSet(),
      ),
    );
  }
}
