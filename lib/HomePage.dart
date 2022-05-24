import 'package:camera/camera.dart';

import 'package:flutter/material.dart';

import 'package:tflite/tflite.dart';
import './main.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isWorking = false;
  String result = "";
  CameraImage? imgCamera;
  late CameraController cameraController;

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
      model: "assets/mobilenet_v1_1.0_224.tflite",
      labels: "assets/mobilenet_v1_1.0_224.txt",
    );
  }

  runModelOnFrame() async {
    if (imgCamera != null) {
      var recognitions = await Tflite.runModelOnFrame(
        bytesList: imgCamera!.planes.map((plane) {
          return plane.bytes;
        }).toList(),
        imageHeight: imgCamera!.height,
        imageWidth: imgCamera!.width,
        imageMean: 127.5,
        imageStd: 127.5,
        rotation: 90,
        numResults: 2,
        threshold: 0.1,
        asynch: true,
      );
      result = "";
      recognitions!.forEach((response) {
        result += response['label'] +
            " " +
            (response['confidence'] as double).toStringAsFixed(2) +
            "\n\n";
      });
      setState(() {
        result;
      });
      isWorking = false;
    }
  }

  @override
  void dispose() async {
    super.dispose();
    cameraController.dispose();
  }

  @override
  void initState() {
    super.initState();
    initCamera();
    loadModel();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.black,
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/jarvis.jpg'),
              ),
            ),
            child: Column(
              children: [
                Stack(
                  children: [
                    Center(
                      child: Container(
                        height: 320,
                        width: 360,
                        color: Colors.black,
                        child: Image.asset('assets/camera.jpg'),
                      ),
                    ),
                    Center(
                      child: FlatButton(
                        onPressed: () {
                          initCamera();
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 35),
                          height: 270,
                          width: 360,
                          child: imgCamera == null
                              ? Container(
                                  height: 270,
                                  width: 360,
                                  child: Icon(
                                    Icons.photo_camera_front,
                                    color: Colors.blue,
                                    size: 40,
                                  ),
                                )
                              : AspectRatio(
                                  aspectRatio:
                                      cameraController.value.aspectRatio,
                                  child: CameraPreview(cameraController),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
                Center(
                    child: Container(
                        margin: EdgeInsets.only(top: 55),
                        child: SingleChildScrollView(
                          child: Text(
                            result,
                            style: TextStyle(
                                backgroundColor: Colors.black87,
                                fontSize: 30,
                                color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        )))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
