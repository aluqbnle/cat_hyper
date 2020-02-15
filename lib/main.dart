import 'package:flutter/material.dart';
import 'dart:async';
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
  final int cataractScore_AI;
  final int hypertensionScore_AI;
  final int cataractScore_Dr;
  final int hypertensionScore_Dr;

  const Grade(this.name, this.cataractScore_AI, this.hypertensionScore_AI,
      this.cataractScore_Dr, this.hypertensionScore_Dr);
}

class SecondRoute extends StatefulWidget {
  @override
  _SecondRoute createState() => _SecondRoute();
}

class _SecondRoute extends State<SecondRoute> {
  //const になっていたためソート出来ていな買った（sortが使えていなかった）
  List<Grade> grades = [
    Grade('0001.png', 1, 1, 0, 1),
    Grade('0002.png', 1, 1, 1, 0),
    Grade('0003.png', 0, 1, 0, 1),
    Grade('0004.png', 1, 0, 1, 1),
    Grade('0005.png', 1, 1, 0, 0),
    Grade('0006.png', 0, 0, 0, 1),
  ];

  List<String> _selected = [];
  bool _sort = true;
  int _sortColumnIndex = 2;

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
                  Navigator.pop(context); //ナビゲーションをもどる
                },
              ),
            ),
            Container(
              // padding: const EdgeInsets.only(right:5.0),
              // margin: const EdgeInsets.all(4.0),
              child: IconButton(
                icon: Icon(Icons.save),
                onPressed: () {
                  Navigator.pop(context); //ナビゲーションをもどる
                },
              ),
            ),
          ],
        ),
      ),
      body: DataTable(
        sortAscending: _sort,
        sortColumnIndex: _sortColumnIndex,
        columns: [
          const DataColumn(
            label: Text("画像"),
          ),
          const DataColumn(
            label: Text("ファイル名"),
          ),
          DataColumn(
            label: const Text("白内障診断（AI）"),
            numeric: true,
            onSort: (int columnIndex, bool ascending) {
              if (columnIndex != _sortColumnIndex) {
                _sortColumnIndex = 2;
                // ascending = !ascending;
                // print("change!");
              }
              print("cataractScore_AI:" + ascending.toString());
              if (ascending) {
                grades.sort(
                    (a, b) => a.cataractScore_AI.compareTo(b.cataractScore_AI));
              } else {
                grades.sort(
                    (a, b) => b.cataractScore_AI.compareTo(a.cataractScore_AI));
              }
              setState(() {
                _sort = !_sort; //これがないと繰り返しソート出来ない？
              });
            },
          ),
          DataColumn(
            label: const Text("高血圧診断（AI）"),
            numeric: true,
            onSort: (int columnIndex, bool ascending) {
              _sortColumnIndex = 3;
              if (columnIndex == 3) {
                print("hypertensionScore_AI:" + ascending.toString());
                if (ascending) {
                  grades.sort((a, b) =>
                      a.hypertensionScore_AI.compareTo(b.hypertensionScore_AI));
                } else {
                  grades.sort((a, b) =>
                      b.hypertensionScore_AI.compareTo(a.hypertensionScore_AI));
                }
                setState(() {
                  _sort = !_sort; //これがないと繰り返しソート出来ない？
                });
              }
            },
          ),
          DataColumn(
            label: const Text("白内障診断（Dr）"),
            numeric: true,
            onSort: (int columnIndex, bool ascending) {
              _sortColumnIndex = 4;
              if (columnIndex == 4) {
                print("cataractScore_Dr:" + ascending.toString());
                if (ascending) {
                  grades.sort((a, b) =>
                      a.cataractScore_Dr.compareTo(b.cataractScore_Dr));
                } else {
                  grades.sort((a, b) =>
                      b.cataractScore_Dr.compareTo(a.cataractScore_Dr));
                }
                setState(() {
                  _sort = !_sort; //これがないと繰り返しソート出来ない？
                });
              }
            },
          ),
          DataColumn(
            label: const Text("高血圧診断（Dr）"),
            numeric: true,
            onSort: (int columnIndex, bool ascending) {
              _sortColumnIndex = 5;
              if (columnIndex == 5) {
                print("hypertensionScore_Dr:" + ascending.toString());
                if (ascending) {
                  grades.sort((a, b) =>
                      a.hypertensionScore_Dr.compareTo(b.hypertensionScore_Dr));
                } else {
                  grades.sort((a, b) =>
                      b.hypertensionScore_Dr.compareTo(a.hypertensionScore_Dr));
                }
                setState(() {
                  _sort = !_sort; //これがないと繰り返しソート出来ない？
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
                  Text(grade.cataractScore_AI.toString()),
                ),
                DataCell(
                  Text(grade.hypertensionScore_AI.toString()),
                ),
                DataCell(
                  Text(grade.cataractScore_Dr.toString()),
                ),
                DataCell(
                  Text(grade.hypertensionScore_Dr.toString()),
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
        body: Container(
            child: PhotoView(
          imageProvider: AssetImage('images/Thinkoutlogo.png'),
        )));
  }
}

class Memo {
  final int id;
  final String text;
  final int priority;

  Memo({this.id, this.text, this.priority});
}
