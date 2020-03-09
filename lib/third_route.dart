import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'dart:html';

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
