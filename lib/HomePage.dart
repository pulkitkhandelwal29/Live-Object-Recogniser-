import 'package:camera/camera.dart';

import 'package:flutter/material.dart';

import 'package:camera/camera.dart';

import './main.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late CameraController cameraController;
  late CameraImage imgCamera;
  bool isWorking = false;

  initCamera() {
    cameraController = CameraController(cameras[0], ResolutionPreset.medium);
    cameraController.initialize().then((value) {
      if (!mounted) {
        return;
      }
      setState(() {
        cameraController.startImageStream((imageFromStream) {
          if (!isWorking) {
            isWorking = true;
            imgCamera = imageFromStream;
          }
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();
    initCamera();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List<Widget> stackChildrenWidgets = [];
    stackChildrenWidgets.add(Positioned(
      top: 0,
      left: 0,
      width: size.width,
      height: size.height - 100,
      child: Container(
        height: size.height - 100,
        child: (!cameraController.value.isInitialized)
            ? new Container()
            : AspectRatio(
                aspectRatio: cameraController.value.aspectRatio,
                child: CameraPreview(cameraController),
              ),
      ),
    ));
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.black,
            body: Container(
              margin: EdgeInsets.only(top: 50),
              color: Colors.black,
              child: Stack(
                children: stackChildrenWidgets,
              ),
            )));
  }
}
