import 'package:flutter/material.dart';
import 'package:laba3/PhotoScreen.dart';
import 'package:laba3/models/locale.modal.dart';
import 'package:laba3/utils/firebase.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

import 'package:laba3/CPU.dart';
//import 'package:flutter_group_journal/models/locale.modal.dart';

class GaleryScreen extends StatefulWidget {
  final CPU cpu;

  GaleryScreen({@required this.cpu}) : super();

  @override
  _GaleryScreenState createState() => _GaleryScreenState();
}

class _GaleryScreenState extends State<GaleryScreen> {
  void _addPhoto() async {
    final pickedFile = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      var url = await FirebaseHelper.uploadImage(pickedFile);
      widget.cpu.images.add(url);
      FirebaseHelper.updateCPU(widget.cpu);

      setState(() {});
    }
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

          onTap: _addPhoto,
          child: const Icon(Icons.add),/*Icon(
                  Icons.logout,
                ),*/
        ),
        ),
        ]),
        body: GridView.count(
          crossAxisCount: 1,
          children: List.generate(widget.cpu.images.length, (index) {
            return Center(
              child: InkWell(
                child:Image.network(
                  widget.cpu.images[index],
                ),
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            PhotoScreen(cpu: widget.cpu, index: index,))),
              ),
            );
          }),
        ),
      ),
    );
  }
}
