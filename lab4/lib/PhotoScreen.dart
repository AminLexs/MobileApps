import 'package:flutter/material.dart';
import 'package:laba3/models/locale.modal.dart';
import 'package:laba3/utils/firebase.dart';
import 'package:provider/provider.dart';

import 'package:laba3/CPU.dart';

import 'GaleryScreen.dart';

class PhotoScreen extends StatefulWidget {
  final CPU cpu;
  final int index;

  PhotoScreen({@required this.cpu, @required this.index}) : super();

  @override
  _PhotoScreenState createState() => _PhotoScreenState();
}

class _PhotoScreenState extends State<PhotoScreen> {

  void _deletePhoto() async {
    widget.cpu.images.removeAt(widget.index);
    await FirebaseHelper.updateCPU(widget.cpu);
    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) =>
                GaleryScreen(cpu: widget.cpu)));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
          appBar: AppBar(
            title: Text(Provider.of<LocaleModel>(context).getString("galery")),
              actions: [
                Padding(
                  padding: EdgeInsets.only(right: 10.0, top: 10.0),
                  child: InkWell(

                    onTap: _deletePhoto,
                    child: const Icon(Icons.backspace),/*Icon(
                  Icons.logout,
                ),*/
                  ),
                ),
              ]
          ),
          body: Center(child: Image.network(
            widget.cpu.images[widget.index],
          ),)
      ),
    );
  }
}
