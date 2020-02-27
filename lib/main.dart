import 'dart:html';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
  // int _count = 0;

  // void _handlePressed() {
  //   setState(() {
  //     _count++;
  //   });
  // }

  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(top: 50.0, right: 200.0),
        margin: const EdgeInsets.all(4.0),
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
                  padding:
                      const EdgeInsets.only(top: 40.0, left: 15.0, right: 15.0),
                  margin: const EdgeInsets.all(4.0),
                  height: 100,
                  width: 200,
                  child: const Text(
                    'フォルダ選択',
                    style: TextStyle(color: Colors.black, fontSize: 15.0),
                  ),
                ))
          ],
        ));
  }
}

class Grade {
  final String name;
  final int score;
  final int aiscore;

  const Grade(this.name, this.score, this.aiscore);
}

class SecondRoute extends StatefulWidget {
  @override
  _SecondRoute createState() => _SecondRoute();
}

class _SecondRoute extends State<SecondRoute> {
  List<Grade> grades = const [
    Grade('0001.png', 1, 1),
    Grade('0002.png', 1, 1),
    Grade('0003.png', 0, 1),
    Grade('0004.png', 1, 1),
    Grade('0005.png', 1, 1),
    Grade('0006.png', 0, 1),
  ];

  bool _sort = true;

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
            Container(
              padding: const EdgeInsets.only(left: 300.0),
              // margin: const EdgeInsets.all(4.0),
              child: IconButton(
                icon: Icon(Icons.clear),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            Container(
              // padding: const EdgeInsets.only(right:5.0),
              // margin: const EdgeInsets.all(4.0),
              child: IconButton(
                icon: Icon(Icons.save),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
      body: DataTable(
        sortAscending: _sort,
        sortColumnIndex: 1,
        columns: [
          const DataColumn(
            label: Text("画像"),
          ),
          const DataColumn(
            label: Text("ファイル名"),
          ),
          DataColumn(
            label: const Text("白内障診断"),
            numeric: true,
            onSort: (int columnIndex, bool ascending) {
              if (columnIndex == 1) {
                if (ascending) {
                  grades.sort((a, b) => a.score.compareTo(b.score));
                } else {
                  grades.sort((a, b) => b.score.compareTo(a.score));
                }
                setState(() {
                  _sort = !_sort;
                });
              }
            },
          ),
          DataColumn(
            label: const Text("白内障診断AI"),
            numeric: true,
            onSort: (int columnIndex, bool ascending) {
              if (columnIndex == 1) {
                if (ascending) {
                  grades.sort((a, b) => a.score.compareTo(b.score));
                } else {
                  grades.sort((a, b) => b.score.compareTo(a.score));
                }
                setState(() {
                  _sort = !_sort;
                });
              }
            },
          ),
        ],
        rows: [
          for (var grade in grades)
            DataRow(
              // selected: _selected.contains(grade.name),
              // onSelectChanged: (bool value){
              //   setState((){
              //     if(value){
              //       _selected.add(grade.name);
              //     }else{
              //       _selected.remove(grade.name);
              //     }
              //   });
              // },
              cells: [
                DataCell(
                  FlatButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ThirdRoute()),
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
                  Text(grade.name),
                ),
                DataCell(
                  Text(grade.score.toString()),
                ),
                DataCell(
                  Text(grade.aiscore.toString()),
                )
              ],
            ),
        ],
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
      if (controller.scale + event.deltaY / 100 > 1) {
        controller.scale += event.deltaY / 100;
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
