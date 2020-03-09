import 'dart:async';
import 'dart:html';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:photo_view/photo_view.dart';
import 'package:flutter/cupertino.dart';

import 'second_route.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Form',
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Row(
            // mainAxisAlignment: MainAxisAlignment.start,特になくても動く？なにこれ
            children: <Widget>[
              Image.asset(
                'images/Thinkoutlogo.png',
                fit: BoxFit.cover,
                height: 35.0,
              ),
              Container(
                padding: const EdgeInsets.only(left: 50.0),
                margin: const EdgeInsets.all(4.0),
                child: Column(
                  children: <Widget>[
                    Text(
                      'Optos Annotation Application',
                      style: TextStyle(color: Colors.white, fontSize: 13.0),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: Center(
          child: ChangeForm(),
          // child:SecondRoute(),
        ),
      ),
    );
  }
}

class ChangeForm extends StatefulWidget {
  @override
  _ChangeFormState createState() => _ChangeFormState();
}

class _ChangeFormState extends State<ChangeForm> {
  final _formKey = GlobalKey<FormState>();
  String _targetDirectory = "";

  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Container(
            padding: const EdgeInsets.all(50.0),
            child: Column(
              children: <Widget>[
                // Text(
                //   "$_count",
                //   style: TextStyle(
                //     color:Colors.grey,
                //     fontSize: 30.0,
                //     fontWeight: FontWeight.w500
                //   ),
                // ),
                // RaisedButton(
                //   onPressed: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //           builder: (context) =>
                //               SecondRoute(folderPath: _targetDirectory)),
                //     );
                //   },
                //   color: Colors.grey,
                //   shape: OutlineInputBorder(
                //     borderRadius: BorderRadius.all(Radius.circular(0.0)),
                //   ),
                //   child: Container(
                //     padding: const EdgeInsets.only(
                //         top: 40.0, left: 15.0, right: 15.0),
                //     margin: const EdgeInsets.all(4.0),
                //     height: 100,
                //     width: 200,
                //     child: const Text(
                //       'フォルダ選択',
                //       style: TextStyle(color: Colors.black, fontSize: 15.0),
                //     ),
                //   ),
                // ),
                new TextFormField(
                    onFieldSubmitted: (String value) {
                      _targetDirectory = value;
                      setState(() {});
                    },
                    validator: (String value) {
                      return value.isEmpty ? '必須入力です' : null;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "絶対パス(例: C:¥Users¥...)",
                      labelText: "認識させたいディレクトリを絶対パスで入力",
                    )),
                RaisedButton(
                  onPressed: _submission,
                  child: Text('送信'),
                )
              ],
            )));
  }

  void _submission() {
    if (this._formKey.currentState.validate()) {
      this._formKey.currentState.save();
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SecondRoute(folderPath: _targetDirectory)),
      );
      // Scaffold.of(context)
      //     .showSnackBar(SnackBar(content: Text('Processing Data')));
      // var uri = Uri.http('localhost:8080', '/suitable_link',
      //     {"dir": _targetDirectory}); // TODO: 適当なポート/リンクに変更
      // http.get(uri).then((value) => {
      //       // サーバーからレスポンスがあったあとの処理
      //       null
      //     });
    }
  }
}
