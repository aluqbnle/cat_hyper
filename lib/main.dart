import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:photo_view/photo_view.dart';

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
                RaisedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SecondRoute()),
                    );
                  },
                  color: Colors.grey,
                  shape: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(0.0)),
                  ),
                  child: Container(
                    padding: const EdgeInsets.only(
                        top: 40.0, left: 15.0, right: 15.0),
                    margin: const EdgeInsets.all(4.0),
                    height: 100,
                    width: 200,
                    child: const Text(
                      'フォルダ選択',
                      style: TextStyle(color: Colors.black, fontSize: 15.0),
                    ),
                  ),
                ),
                new TextFormField(
                    onSaved: (String value) {
                      _targetDirectory = value;
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
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text('Processing Data')));
      var uri = Uri.http('localhost:8080', '/suitable_link',
          {"dir": _targetDirectory}); // TODO: 適当なポート/リンクに変更
      http.get(uri).then((value) => {
            // サーバーからレスポンスがあったあとの処理
            null
          });
    }
  }
}

class Data {
  final String name;
  final int cataractScoreAI;
  final int hypertensionScoreAI;
  final int cataractScoreDr;
  final int hypertensionScoreDr;

  const Data(this.name, this.cataractScoreAI, this.hypertensionScoreAI,
      this.cataractScoreDr, this.hypertensionScoreDr);
}

class Grade {
  final List<dynamic> data;

  const Grade({this.data});

  factory Grade.fromJson(Map<String, dynamic> json) {
    return Grade(
      data: json['data'],
    );
  }
}

Future<Grade> fetchGrade() async {
  final response = await http.get('http://localhost:3000/data');
  // final response = await http.get('https://dev-test.fujiya228.com/flutter/cat_hyper/sample.json');

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response, then parse the JSON.
    // print(response.body);
    return Grade.fromJson(json.decode(utf8.decode(response.bodyBytes)));
  } else {
    // If the server did not return a 200 OK response, then throw an exception.
    throw Exception('Failed to load data');
  }
}

class SecondRoute extends StatefulWidget {
  @override
  _SecondRoute createState() => _SecondRoute();
}

class _SecondRoute extends State<SecondRoute> {
  //const になっていたためソート出来ていなかった（sortが使えていなかった）
  Future<Grade> grade;
  List data;

  @override
  void initState() {
    super.initState();
    grade = fetchGrade();
    // print('initState:' + grade.toString());
  }

  void _reload() {
    grade = fetchGrade();
    setState(() {});
  }

  bool _sort = true;
  int _sortColumnIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // mainAxisAlignment: MainAxisAlignment.start,特になくても動く？なにこれ
          children: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Image.asset(
                'images/Thinkoutlogo.png',
                fit: BoxFit.cover,
                height: 35.0,
              ),
            ),
            Container(
//              padding: const EdgeInsets.only(left: 300.0),
                // margin: const EdgeInsets.all(4.0),
                child: Row(children: [
              IconButton(
                icon: Icon(Icons.clear),
                onPressed: () {
                  Navigator.pop(context); //ナビゲーションをもどる
                },
              ),
              IconButton(
                icon: Icon(Icons.save),
                onPressed: () async {
                  // print(data);
                  Map<String, String> headers = {
                    'content-type': 'application/json'
                  };
                  String body = json.encode({'data': data});
                  final response = await http.post('http://localhost:3000/data',
                      headers: headers, body: body);
                  if (response.statusCode == 200) {
                    print("success!");
                  } else {
                    throw Exception('Failed to post data');
                  }
                },
              ),
              IconButton(
                icon: Icon(Icons.autorenew),
                onPressed: () => _reload(),
              )
            ])),
          ],
        ),
      ),
      body: SingleChildScrollView(
          child: Container(
        width: 1920,
        child: FutureBuilder<Grade>(
          future: grade,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              // print(snapshot.data.data);
              data = snapshot.data.data;
              // print(data);
              return DataTable(
                sortAscending: _sort,
                sortColumnIndex: _sortColumnIndex,
                horizontalMargin: 0,
                columns: [
                  const DataColumn(
                    label: Text("画像"),
                  ),
                  DataColumn(
                    label: Text("ファイル名"),
                    numeric: true,
                    onSort: (int columnIndex, bool ascending) {
                      // print("cataractScoreAI:" + ascending.toString());
                      if (columnIndex != _sortColumnIndex) {
                        _sortColumnIndex = 1;
                        setState(() {
                          _sort = false; //ここで変更しておかないと
                        });
                      }
                      if (ascending) {
                        data.sort((a, b) => a['name'].compareTo(b['name']));
                      } else {
                        data.sort((a, b) => b['name'].compareTo(a['name']));
                      }
                      setState(() {
                        _sort = !_sort; //これがないと繰り返しソート出来ない？
                        // print("_sort:" + _sort.toString());
                      });
                    },
                  ),
                  DataColumn(
                    label: const Text("白内障診断（AI）"),
                    numeric: true,
                    onSort: (int columnIndex, bool ascending) {
                      // print("cataractScoreAI:" + ascending.toString());
                      if (columnIndex != _sortColumnIndex) {
                        _sortColumnIndex = 2;
                        setState(() {
                          _sort = false; //ここで変更しておかないと
                        });
                      }
                      if (ascending) {
                        data.sort((a, b) => a['cataractScoreAI']
                            .compareTo(b['cataractScoreAI']));
                      } else {
                        data.sort((a, b) => b['cataractScoreAI']
                            .compareTo(a['cataractScoreAI']));
                      }
                      setState(() {
                        _sort = !_sort; //これがないと繰り返しソート出来ない？
                        // print("_sort:" + _sort.toString());
                      });
                    },
                  ),
                  DataColumn(
                    label: const Text("高血圧診断（AI）"),
                    numeric: true,
                    onSort: (int columnIndex, bool ascending) {
                      // print("hypertensionScoreAI:" + ascending.toString());
                      if (columnIndex != _sortColumnIndex) {
                        _sortColumnIndex = 3;
                        setState(() {
                          _sort = false; //ここで変更しておかないと
                        });
                      }
                      if (ascending) {
                        data.sort((a, b) => a['hypertensionScoreAI']
                            .compareTo(b['hypertensionScoreAI']));
                      } else {
                        data.sort((a, b) => b['hypertensionScoreAI']
                            .compareTo(a['hypertensionScoreAI']));
                      }
                      setState(() {
                        _sort = !_sort; //これがないと繰り返しソート出来ない？
                        // print("_sort:" + _sort.toString());
                      });
                    },
                  ),
                  DataColumn(
                    label: const Text("白内障診断（Dr）"),
                    numeric: true,
                    onSort: (int columnIndex, bool ascending) {
                      // print("cataractScoreDr:" + ascending.toString());
                      if (columnIndex != _sortColumnIndex) {
                        _sortColumnIndex = 4;
                        setState(() {
                          _sort = false; //ここで変更しておかないと
                        });
                      }
                      if (ascending) {
                        data.sort((a, b) => a['cataractScoreDr']
                            .compareTo(b['cataractScoreDr']));
                      } else {
                        data.sort((a, b) => b['cataractScoreDr']
                            .compareTo(a['cataractScoreDr']));
                      }
                      setState(() {
                        _sort = !_sort; //これがないと繰り返しソート出来ない？
                        // print("_sort:" + _sort.toString());
                      });
                    },
                  ),
                  DataColumn(
                    label: const Text("高血圧診断（Dr）"),
                    numeric: true,
                    onSort: (int columnIndex, bool ascending) {
                      // print("hypertensionScoreDr:" + ascending.toString());
                      if (columnIndex != _sortColumnIndex) {
                        _sortColumnIndex = 5;
                        setState(() {
                          _sort = false; //ここで変更しておかないと
                        });
                      }
                      if (ascending) {
                        data.sort((a, b) => a['hypertensionScoreDr']
                            .compareTo(b['hypertensionScoreDr']));
                      } else {
                        data.sort((a, b) => b['hypertensionScoreDr']
                            .compareTo(a['hypertensionScoreDr']));
                      }
                      setState(() {
                        _sort = !_sort; //これがないと繰り返しソート出来ない？
                        // print("_sort:" + _sort.toString());
                      });
                    },
                  ),
                  DataColumn(
                    label: const Text(
                      "備考",
                    ),
                  )
                ],
                rows: [
                  for (var grade in data)
                    DataRow(
                      cells: [
                        DataCell(
                          FlatButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ThirdRoute()),
                              );
                            },
                            child: Image.asset(
                              'images/Thinkoutlogo.png',
                              fit: BoxFit.cover,
                              height: 20.0,
                            ),
                          ),
                        ),
                        DataCell(
                          Text(grade['image']),
                        ),
                        DataCell(
                          Text(grade['cataractScoreAI'].toString()),
                        ),
                        DataCell(
                          Text(grade['hypertensionScoreAI'].toString()),
                        ),
                        DataCell(TextField(
                          controller: TextEditingController.fromValue(
                              TextEditingValue(
                                  text: grade['cataractScoreDr'].toString())),
                          onSubmitted: (value) {
                            grade['cataractScoreDr'] = int.tryParse(value);
                            print('catDr:' + grade['cataractScoreDr']); // 確認用
                            setState(() {});
                          },
                        )),
                        DataCell(
                          // Text(grade['hypertensionScoreDr'].toString()),
                          TextField(
                            controller: TextEditingController.fromValue(
                                TextEditingValue(
                                    text: grade['hypertensionScoreDr']
                                        .toString())),
                            onSubmitted: (value) {
                              grade['hypertensionScoreDr'] =
                                  int.tryParse(value);
                              print('hyperDr:' +
                                  grade['hypertensionScoreDr']); // 確認用
                              setState(() {});
                            },
                          ),
                        ),
                        DataCell(
                          Container(
                              width: 800,
                              // height: 100,
                              child: TextField(
                                controller: TextEditingController.fromValue(
                                    TextEditingValue(
                                        text: grade['note'].toString())),
                                onSubmitted: (value) {
                                  grade['note'] = value;
                                  print('note:' + grade['note']); // 確認用
                                  setState(() {});
                                },
                              )),
                          placeholder: true,
                        )
                      ],
                    ),
                ],
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }

            return Center();
            // By default, show a loading spinner.
            // return Center(
            //   child: Column(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     mainAxisSize: MainAxisSize.max,
            //     children: <Widget>[
            //       CircularProgressIndicator()
            //     ],
            //   ),
            // );
          },
        ),
      )),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.autorenew),
        onPressed: () => _reload(),
      ),
    );
  }
}

class ThirdRoute extends StatefulWidget {
  @override
  _ThirdRoute createState() => _ThirdRoute();
}

class _ThirdRoute extends State<ThirdRoute> {
  PhotoViewScaleStateController scaleStateController;
  PhotoViewControllerBase controller;

  @override
  void initState() {
    super.initState();
    controller = PhotoViewController();
    scaleStateController = PhotoViewScaleStateController();
    mouseEventListener();
  }

  // マウスホイールの動きを検知する
  void mouseEventListener() {
    document.body.onMouseWheel.listen((event) {
      if (controller.scale + event.deltaY * -0.01 > 1) {
        controller.scale += event.deltaY * -0.01;
      }
    });
  }

  @override
  void dispose() {
    scaleStateController.dispose();
    super.dispose();
  }

  void goBack() {
    scaleStateController.scaleState = PhotoViewScaleState.initial;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            // mainAxisAlignment: MainAxisAlignment.start,特になくても動く？なにこれ
            children: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Image.asset(
                  'images/Thinkoutlogo.png',
                  fit: BoxFit.cover,
                  height: 35.0,
                ),
              ),
            ],
          ),
        ),
        body: Stack(
          children: <Widget>[
            PhotoView(
                imageProvider: AssetImage("images/Thinkoutlogo.png"),
                scaleStateController: scaleStateController,
                controller: controller,
                minScale: 1),
            FlatButton(
              child: Text("サイズを戻す"),
              onPressed: goBack,
            )
          ],
        ));
  }
}

class Memo {
  final int id;
  final String text;
  final int priority;

  Memo({this.id, this.text, this.priority});
}
