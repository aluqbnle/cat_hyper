import 'package:flutter/material.dart';

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
              Image.asset('images/Thinkoutlogo.png',
              fit: BoxFit.cover,
              height: 35.0,
              ),
              Container(
                padding: const EdgeInsets.only(left:50.0),
                margin: const EdgeInsets.all(4.0),
                child: Column(
                children: <Widget>[
                  Text(
                      'Optos Annotation Application',
                      style: TextStyle(
                        color:Colors.white,
                        fontSize: 13.0
                      ),
                  ),
                ],
                ),
              ),
            ],
          ),
        ),
        body: Center(
          child: ChangeForm(),
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
  int _count = 0;

  void _handlePressed() {
    setState(() {
      _count++;
    });
  }

  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top:50.0,right:200.0),
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
            onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SecondRoute()),
              );
            },
            color: Colors.grey,
            shape: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(0.0)),
            ),
            child:Container(
              padding: const EdgeInsets.only(top:15.0,left:15.0,right:15.0),
              margin: const EdgeInsets.all(4.0),
              height: 100,
              width: 100,
              child: const Text(
                  'フォルダ選択',
                  style: TextStyle(
                  color:Colors.black,
                  fontSize: 15.0
                ),
              ),
            )
          )
        ],
      )
    );
  }
}

class SecondRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Second Route"),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            // Navigate back to first route when tapped.
          },
          child: Text('Go back!'),
        ),
      ),
    );
  }
}
