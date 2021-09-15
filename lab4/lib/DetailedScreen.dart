import 'dart:io';
import 'package:flutter/material.dart';
import 'package:laba3/GaleryScreen.dart';
import 'package:laba3/VideoScreen.dart';
import 'package:laba3/models/locale.modal.dart';
import 'package:laba3/utils/firebase.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:laba3/CPU.dart';

class DetailedScreen extends StatefulWidget {
  final CPU cpu;
  final void Function() rerender;

  DetailedScreen({@required this.cpu, @required this.rerender}) : super();

  @override
  _CPUSceenState createState() => _CPUSceenState();
}

class _CPUSceenState extends State<DetailedScreen> {
 // DateTime currentDate = DateTime.now();
  TextEditingController _modelController;
  TextEditingController _manufacturerController;
  TextEditingController _frequencyController;
  TextEditingController _numcoresController;
  TextEditingController _latitudeController;
  TextEditingController _longitudeController;
  String result = "";
  Color resultColor;

  @override
  void initState() {
    super.initState();
    _latitudeController = TextEditingController(text: widget.cpu.latitude);
    _longitudeController =
        TextEditingController(text: widget.cpu.longitude);
    _modelController =
        TextEditingController(text: widget.cpu.model);
    _manufacturerController = TextEditingController(text: widget.cpu.manufacturer);
    _frequencyController =
        TextEditingController(text: widget.cpu.frequency);
    _numcoresController = TextEditingController(
        text: widget.cpu.numcores);
    result = "";
    resultColor = Colors.transparent;
    //currentDate = widget.cpu.numcores;
  }

  @override
  void dispose() {
    _latitudeController.dispose();
    _longitudeController.dispose();
    _modelController.dispose();
    _manufacturerController.dispose();
    _frequencyController.dispose();
    _numcoresController.dispose();
    super.dispose();
  }

  void setError(String message) {
    setState(() {
      result = message;
      resultColor = Colors.red;
    });
  }

  void setSuccess() {
    setState(() {
      result = context.read<LocaleModel>().getString("cpu_edit_success");
      resultColor = Colors.green;
    });
  }

  Future _selectVideo() async {
    final pickedFile = await ImagePicker.pickVideo(source: ImageSource.gallery);

    if (pickedFile != null) {
      File _video = File(pickedFile.path);
      String url = await FirebaseHelper.uploadVideo(_video);
      widget.cpu.videoUrl = url;
      FirebaseHelper.updateCPU(widget.cpu);
    }
  }



  void _onSubmit() async {
    try {
      setError("");

      if (_longitudeController.text.isEmpty ||
          _latitudeController.text.isEmpty ||
          _modelController.text.isEmpty ||
          _manufacturerController.text.isEmpty ||
          _frequencyController.text.isEmpty ||
          _numcoresController.text.isEmpty) {
        setError(context.read<LocaleModel>().getString("err_empty"));
        return;
      }

      widget.cpu.model = _modelController.text;
      widget.cpu.manufacturer = _manufacturerController.text;
      widget.cpu.frequency = _frequencyController.text;
      widget.cpu.latitude = _latitudeController.text;
      widget.cpu.longitude = _longitudeController.text;
      widget.cpu.numcores = _numcoresController.text;

      await FirebaseHelper.updateCPU(widget.cpu);
      setSuccess();
      widget.rerender();
    } catch (e) {
      setError(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("${widget.cpu.model}"),
        ),

        body: Padding(
          padding: EdgeInsets.all(24),
          child: ListView(
            children: [
              TextField(
                controller: _modelController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText:
                  Provider.of<LocaleModel>(context).getString("model"),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _manufacturerController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText:
                  Provider.of<LocaleModel>(context).getString("manufacturer"),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _frequencyController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText:
                  Provider.of<LocaleModel>(context).getString("frequency"),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _numcoresController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText:
                  Provider.of<LocaleModel>(context).getString("numcores"),
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Flexible(
                    child: TextField(
                      controller: _latitudeController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: Provider.of<LocaleModel>(context)
                            .getString("latitude"),
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Flexible(
                    child: TextField(
                      controller: _longitudeController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: Provider.of<LocaleModel>(context)
                            .getString("longitude"),
                      ),
                    ),
                  )
                ],
              ),

              SizedBox(height: 20),
            SizedBox(
            width: double.infinity,
            child:  ElevatedButton(
                onPressed: () => widget.cpu.videoUrl.isEmpty
                    ? null
                    : Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            VideoScreen(
                                videoUrl:
                                widget.cpu.videoUrl))),
                child: Text(Provider.of<LocaleModel>(context)
                    .getString("watch_video"))),

          ),

              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child:   ElevatedButton(
                    onPressed: _selectVideo,
                    child: Text(Provider.of<LocaleModel>(context)
                        .getString("select_video"))),

              ),


              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                GaleryScreen(cpu: widget.cpu))),
                    child: Text(
                        Provider.of<LocaleModel>(context).getString("galery"))),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child:   ElevatedButton(
                onPressed: _onSubmit,
                child: Text( Provider.of<LocaleModel>(context).getString("save")),
              ),

              ),
              SizedBox(height: 20),
              Text(result, style: TextStyle(color: resultColor)),
            ],
          ),
        ));
  }
}
