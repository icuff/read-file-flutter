import 'dart:io';

import 'package:flutter/material.dart';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(
          storage: Storage(),
          title: 'Flutter Demo Home Page'
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final Storage storage;
  final String title;

  MyHomePage({Key key, this.title, @required this.storage}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String fileContent;

  @override
  void initState() {
    super.initState();
    setState(() {
      fileContent = '';
    });
  }

  void askPermission() {
    PermissionHandler().requestPermissions([PermissionGroup.storage]);
  }

  void readData() {
    askPermission();

    widget.storage.readData().then((String value) {
      setState(() {
        fileContent = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Read File'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(fileContent),
            RaisedButton(
              onPressed: readData,
              child: Text('Read File'),
            ),
          ],
        ),
      ),
    );
  }
}

class Storage {
  Future<String> get localPath async {
    final dir = await getExternalStorageDirectory();
    return dir.path + '/Download';
  }

  Future<File> get localFile async {
    final path = await localPath;
    return File('$path/hello.txt');
  }

  Future<String> readData() async {
    try {
      final file = await localFile;
      String body = await file.readAsString();

      return body;
    } catch (e) {
      return e.toString();
    }
  }
}
