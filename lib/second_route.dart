
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'third_route.dart';

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

Future<Grade> fetchGrade(String folderPath) async {
  // String body = json.encode({'folderPath': folderPath});
  final response = await http.get('http://localhost:3000/data?folderpath='+folderPath);
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
  final String folderPath;

  SecondRoute({this.folderPath}) {
    // print('secondRoute constructor');
  }
  @override
  _SecondRoute createState() => _SecondRoute({this.folderPath});
}

class _SecondRoute extends State<SecondRoute> {
  //const になっていたためソート出来ていなかった（sortが使えていなかった）
  Future<Grade> grade;
  List data;
  String folderPath;

  _SecondRoute(Set<String> set, {this.folderPath}) {
    // print('_secondRoute constructor');
    // this.folderPath = folderPath;
  }

  @override
  void initState() {
    super.initState();
    folderPath = widget.folderPath;
    print('folderPath'+folderPath);
    grade = fetchGrade(folderPath);
    // print('initState:' + grade.toString());
  }

  void _reload() {
    grade = fetchGrade(folderPath);
    setState(() {});
  }

  bool _sort = true;
  int _sortColumnIndex = 1;

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
                onPressed: () async {
                  // print(data);
                  Map<String, String> headers = {
                    'content-type': 'application/json'
                  };
                  String body = json.encode({'data': data});
                  final response = await http.put('http://localhost:3000/data?folderpath='+folderPath,
                      headers: headers, body: body);
                  if (response.statusCode == 200) {
                    print("success!");
                    _reload();
                  } else {
                    throw Exception('Failed to post data');
                  }
                },
              ),
            ),
            Container(
              child: IconButton(
                icon: Icon(Icons.autorenew),
                onPressed: () => _reload(),
              ),
            ),
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