import 'dart:io';

import 'package:flutter/material.dart';
import 'package:laba3/models/locale.modal.dart';
import 'package:provider/provider.dart';

import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:laba3/utils/firebase.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({Key key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  //DateTime currentDate = DateTime.now();
  File _image;
  FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController _passwordController;
  TextEditingController _emailController;
  TextEditingController _modelController;
  TextEditingController _manufacturerController;
  TextEditingController _frequencyController;
  TextEditingController _numcoresController;
  String result;
  Color resultColor;

  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController();
    _emailController = TextEditingController();
    _modelController = TextEditingController();
    _manufacturerController = TextEditingController();
    _frequencyController = TextEditingController();
    _numcoresController = TextEditingController();
    result = "";
    resultColor = Colors.transparent;
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _emailController.dispose();
    _modelController.dispose();
    _manufacturerController.dispose();
    _frequencyController.dispose();
    _numcoresController.dispose();
    super.dispose();
  }


  Future getImage() async {
    final pickedFile = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  void setError(String message) {
    setState(() {
      result = message;
      resultColor = Colors.red;
    });
  }

  void setSuccess() {
    setState(() {
      result = context.read<LocaleModel>().getString("cpuAddSuccess");
      resultColor = Colors.green;
    });
  }

  void clearFields() {
    _passwordController.text = "";
    _emailController.text = "";
    _modelController.text = "";
    _manufacturerController.text = "";
    _frequencyController.text = "";
    _numcoresController.text = "";

    setState(() {
      _image = null;
    });
  }

  void _onSubmit() async {
    try {
      setError("");

      if (_emailController.text.isEmpty ||
          _passwordController.text.isEmpty ||
          _modelController.text.isEmpty ||
          _manufacturerController.text.isEmpty ||
          _frequencyController.text.isEmpty ||
          _numcoresController.text.isEmpty ||
          _image == null) {
        setError(context.read<LocaleModel>().getString("err_empty"));
        return;
      }

      var url = await FirebaseHelper.uploadImage(_image);
      await FirebaseHelper.addCPU(
          _modelController.text,
          _manufacturerController.text,
          _frequencyController.text,
          [url],
          _numcoresController.text);
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text);
      clearFields();
      setSuccess();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        setError(context.read<LocaleModel>().getString("err_week_password"));
      } else if (e.code == 'email-already-in-use') {
        setError(context.read<LocaleModel>().getString("err_email_in_use"));
      } else {
        setError(e.message);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:
          Text(Provider.of<LocaleModel>(context).getString("addCPU")),
        ),
        body: Padding(
          padding: EdgeInsets.all(24),
          child: ListView(
            children: [
              Column(
                children: [
                  InkWell(
                    child: Container(
                      width: 100,
                      height: 100,
                      alignment: Alignment.center,
                      decoration: _image != null
                          ? BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.cover, image: FileImage(_image)),
                        borderRadius:
                        BorderRadius.all(Radius.circular(8.0)),
                      )
                          : null,
                      child: _image == null
                          ? Icon(
                        Icons.computer,
                        size: 90,
                      )
                          : null,
                    ),
                    onTap: getImage,
                  ),
                  SizedBox(height: 20),

                  TextField(
                    controller: _modelController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: Provider.of<LocaleModel>(context)
                          .getString("model"),
                    ),
                  ),
                  SizedBox(height: 20),

                  TextField(
                    controller: _manufacturerController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: Provider.of<LocaleModel>(context)
                          .getString("manufacturer"),
                    ),
                  ),
                  SizedBox(height: 20),

                  TextField(
                    controller: _frequencyController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: Provider.of<LocaleModel>(context)
                          .getString("frequency"),
                    ),
                  ),
                  SizedBox(height: 20),

                  TextField(
                    controller: _numcoresController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: Provider.of<LocaleModel>(context)
                          .getString("numcores"),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText:
                      Provider.of<LocaleModel>(context).getString("email"),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: Provider.of<LocaleModel>(context)
                          .getString("password"),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  ElevatedButton(
                      onPressed: _onSubmit,
                      child: Text(
                          Provider.of<LocaleModel>(context).getString("addCPU"))),
                  SizedBox(height: 20),
                  Text(result, style: TextStyle(color: resultColor))
                ],
              )
            ],
          ),
        ));
  }
}
