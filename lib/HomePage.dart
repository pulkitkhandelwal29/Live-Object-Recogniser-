import 'package:camera/camera.dart';

import 'package:flutter/material.dart';

import 'package:camera/camera.dart';

import 'package:tflite/tflite.dart';
import './main.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late CameraController cameraController;
  late CameraImage imgCamera;
  bool isWorking = false;
  String result = "";

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
            runModelOnFrame();
          }
        });
      });
    });
  }

  loadModel() async {
    await Tflite.loadModel(
      model: "assets/model.tflite",
      labels: "assets/labels.txt",
    );
  }

  runModelOnFrame() async {
    if (imgCamera != null) {
      var recognitions = await Tflite.runModelOnFrame(
        bytesList: imgCamera.planes.map((plane) {
          return plane.bytes;
        }).toList(),
        imageHeight: imgCamera.height,
        imageWidth: imgCamera.width,
        imageMean: 127.5,
        imageStd: 127.5,
        rotation: 90,
        numResults: 1,
        threshold: 0.4,
        asynch: true,
      );
      result = "";
      recognitions!.forEach((response) {
        result += response['label'] + "\n";
      });
      setState(() {
        result;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadModel();
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
