import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_language_identification/flutter_language_identification.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FlutterLanguageIdentification languageIdentification;

  TextEditingController languageController = TextEditingController();

  String _text;
  dynamic _result = '';

  @override
  void initState() {
    super.initState();
    initLanguageIdentification();
  }

  Future<void> initLanguageIdentification() async {
    languageIdentification = FlutterLanguageIdentification();

    languageIdentification.setSuccessHandler((message) {
      setState(() {
        print(message);
        _result = message;
      });
    });

    languageIdentification.setErrorHandler((message) {
      setState(() {
        print(message);
      });
    });

    languageIdentification.setFailedHandler((message) {
      setState(() {
        print(message);
        _result = message;
      });
    });
  }

  Future _identifyLanguage() async {
    if (_text != null && _text.isNotEmpty) {
      await languageIdentification.identifyLanguage(_text);
    }
  }

  void _onChange(String text) {
    setState(() {
      _text = text;
    });
  }

  void _resetFields() {
    languageController.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: Text(
                "Projeto IFSP ML KIT",
                style: TextStyle(color: Colors.amber),
              ),
              centerTitle: true,
              backgroundColor: Colors.black,
              actions: <Widget>[
                IconButton(icon: Icon(Icons.refresh), onPressed: _resetFields),
              ],
            ),
            body: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(children: [
                  _inputSection(),
                  _btnSection(),
                  _resultSection()
                ]))));
  }

  Widget _resultSection() => Container(
      alignment: Alignment.bottomCenter,
      padding: EdgeInsets.only(top: 25.0, left: 25.0, right: 25.0),
      child: Text(
        _result.toString(),
        style: TextStyle(color: Colors.black, fontSize: 25.0),
      ));

  Widget _inputSection() => Container(
      alignment: Alignment.topCenter,
      padding: EdgeInsets.only(top: 25.0, left: 25.0, right: 25.0),
      child: TextField(
        decoration: InputDecoration(
          labelText: "Digite uma palavra em qualquer idioma",
          labelStyle: TextStyle(color: Colors.green),
        ),
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20.0),
        onChanged: (String value) {
          _onChange(value);
        },
        controller: languageController,
      ));

  Widget _btnSection() {
    return Container(
        padding: EdgeInsets.only(top: 20.0),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          _buildButtonColumn(Colors.blue, Colors.blueAccent, Icons.search,
              'Verificar', _identifyLanguage),
        ]));
  }

  Column _buildButtonColumn(Color color, Color splashColor, IconData icon,
      String label, Function func) {
    return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
              icon: Icon(icon),
              iconSize: 70.0,
              color: color,
              splashColor: splashColor,
              onPressed: () => func()),
          Container(
              margin: const EdgeInsets.only(top: 1.0),
              child: Text(label,
                  style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.w400,
                      color: color)))
        ]);
  }
}
