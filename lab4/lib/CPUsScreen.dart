import 'package:flutter/material.dart';
import 'package:laba3/DetailedScreen.dart';
import 'package:laba3/models/locale.modal.dart';
import 'package:laba3/utils/firebase.dart';
import 'package:provider/provider.dart';
import 'package:laba3/CPU.dart';


class CPUsScreen extends StatefulWidget {
  CPUsScreen({Key key}) : super(key: key);

  @override
  _CPUScreenState createState() => _CPUScreenState();
}

class _CPUScreenState extends State<CPUsScreen> {
  List<CPU> cpus = [];
  List<CPU> duplicateCPUs = [];


  @override
  void initState() {
    loadCPUs();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  loadCPUs() async {
    var cpus = await FirebaseHelper.getAllCPUs();
    setCPUs(cpus);
  }

  setCPUs(List<CPU> loaded) {
    setState(() {
      cpus.addAll(loaded);
      duplicateCPUs.addAll(loaded);
    });
  }

  void rerender() {
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Provider.of<LocaleModel>(context).getString("users")),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
              child: ListView.builder(
                itemCount: cpus.length,
                itemBuilder: (context, index) => InkWell(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => DetailedScreen(
                                cpu: cpus[index],
                                rerender: this.rerender))),
                    child: Container(
                        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        width: double.maxFinite,
                        child: Card(
                            clipBehavior: Clip.antiAlias,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  height: 100,
                                  child: AspectRatio(
                                    aspectRatio: 1,
                                    child: Image(
                                      image: cpus[index].images.isNotEmpty?
                                      NetworkImage(cpus[index].images[0]):NetworkImage("https://picsum.photos/250?image=9"),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          cpus[index].model,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          cpus[index].manufacturer,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          cpus[index].frequency,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          cpus[index].numcores,
                                          overflow: TextOverflow.ellipsis,
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            )))),
              ))
        ],
      ),
    );
  }
}
