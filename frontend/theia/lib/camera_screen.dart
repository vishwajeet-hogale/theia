import 'dart:io';
import 'package:dio/dio.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './preview_screen.dart';
import 'package:path/path.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:intl/intl.dart';
import 'dart:async';

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State {
  CameraController controller;
  List cameras;
  int selectedCameraIndex;
  String imgPath;
  String mp3Uri = '';

  @override
  void initState() {
    super.initState();
    // var appDir = (await getTemporaryDirectory()).path ;
    // new Directory(appDir).delete(recursive: true);
    // await DefaultCacheManager().emptyCache();
    void _onCapturePressed(context) async {
      try {
        final file = DateTime.now();
        String formattedDate = DateFormat('yyyy-MM-dd-kk-mm-ss').format(file);
        final path =
            join((await getTemporaryDirectory()).path, '${formattedDate}.jpeg');

        final image = await controller.takePicture(path);

        var formData = FormData.fromMap({
          'image': await MultipartFile.fromFile(path,
              filename: '${formattedDate}.jpeg')
        });

        var dio = Dio();

        void getHttp() async {
          try {
            var response = new Response(); //Response from Dioc
            response = await dio.post(
                "https://2e1e-122-167-0-21.ngrok.io/predict",
                data: formData);
            print(response.statusMessage);
            final FlutterTts tts = FlutterTts();
            final TextEditingController controller1 =
                TextEditingController(text: 'Hello world');

            tts.setLanguage('en');
            tts.setSpeechRate(0.4);
            print(response.data["predicted"]);
            tts.speak(response.data["predicted"]);

            print("Success!");
          } catch (e) {
            print(e);
          }
        }

        getHttp();
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //       builder: (context) => PreviewScreen(
        //             imgPath: path,
        //           )),
        // );
      } catch (e) {
        _showCameraException(e);
      }
    }

    super.initState();
    availableCameras().then((availableCameras) {
      cameras = availableCameras;

      if (cameras.length > 0) {
        setState(() {
          selectedCameraIndex = 0;
        });
        _initCameraController(cameras[selectedCameraIndex]).then((void v) {});
      } else {
        print('No camera available');
      }
      bool _isRunning = true;
      Timer.periodic(Duration(seconds: 10), (Timer timer) {
        if (!_isRunning) {
          timer.cancel();
        }
        _onCapturePressed(context);
      });
    }).catchError((err) {
      print('Error :${err.code}Error message : ${err.message}');
    });
  }

  Future _initCameraController(CameraDescription cameraDescription) async {
    if (controller != null) {
      await controller.dispose();
    }
    controller = CameraController(cameraDescription, ResolutionPreset.high);

    controller.addListener(() {
      if (mounted) {
        setState(() {});
      }

      if (controller.value.hasError) {
        print('Camera error ${controller.value.errorDescription}');
      }
    });

    try {
      await controller.initialize();
    } on CameraException catch (e) {
      _showCameraException(e);
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: _cameraPreviewWidget(),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 120,
                  width: double.infinity,
                  padding: EdgeInsets.all(15),
                  color: Colors.black,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      _cameraToggleRowWidget(),
                      _cameraControlWidget(context),
                      Spacer()
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _cameraPreviewWidget() {
    if (controller == null || !controller.value.isInitialized) {
      return const Text(
        'Loading',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
          fontWeight: FontWeight.w900,
        ),
      );
    }

    return AspectRatio(
      aspectRatio: controller.value.aspectRatio,
      child: CameraPreview(controller),
    );
  }

  Widget _cameraControlWidget(context) {
    return Expanded(
      child: Align(
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            FloatingActionButton(
              child: Icon(
                Icons.camera,
                color: Colors.black,
              ),
              backgroundColor: Colors.white,
              // nPressed: () {
              //   o_onCapturePressed(context);
              // },
            )
          ],
        ),
      ),
    );
  }

  Widget _cameraToggleRowWidget() {
    if (cameras == null || cameras.isEmpty) {
      return Spacer();
    }
    CameraDescription selectedCamera = cameras[selectedCameraIndex];
    CameraLensDirection lensDirection = selectedCamera.lensDirection;

    return Expanded(
      child: Align(
        alignment: Alignment.centerLeft,
        child: FlatButton.icon(
          onPressed: _onSwitchCamera,
          icon: Icon(
            _getCameraLensIcon(lensDirection),
            color: Colors.white,
            size: 24,
          ),
          label: Text(
            '${lensDirection.toString().substring(lensDirection.toString().indexOf('.') + 1).toUpperCase()}',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }

  IconData _getCameraLensIcon(CameraLensDirection direction) {
    switch (direction) {
      case CameraLensDirection.back:
        return CupertinoIcons.switch_camera;
      case CameraLensDirection.front:
        return CupertinoIcons.switch_camera_solid;
      case CameraLensDirection.external:
        return Icons.camera;
      default:
        return Icons.device_unknown;
    }
  }

  void _showCameraException(CameraException e) {
    String errorText = 'Error:${e.code}\nError message : ${e.description}';
    print(errorText);
  }

  // void _onCapturePressed(context) async {
  //   try {
  //     final file = DateTime.now();
  //     String formattedDate = DateFormat('yyyy-MM-dd-kk-mm-ss').format(file);
  //     final path =
  //         join((await getTemporaryDirectory()).path, '${formattedDate}.jpeg');

  //     final image = await controller.takePicture(path);

  //     var formData = FormData.fromMap({
  //       'image': await MultipartFile.fromFile(path,
  //           filename: '${formattedDate}.jpeg')
  //     });

  //     var dio = Dio();

  //     void getHttp() async {
  //       try {
  //         var response = new Response(); //Response from Dioc
  //         response = await dio.post(
  //             "https://31d3-122-179-110-225.ngrok.io/predict",
  //             data: formData);
  //         print(response.statusMessage);
  //         final FlutterTts tts = FlutterTts();
  //         final TextEditingController controller1 =
  //             TextEditingController(text: 'Hello world');

  //         tts.setLanguage('en');
  //         tts.setSpeechRate(0.4);
  //         print(response.data["predicted"]);
  //         tts.speak(response.data["predicted"]);

  //         print("Success!");
  //       } catch (e) {
  //         print(e);
  //       }
  //     }

  //     getHttp();
  //     // Navigator.push(
  //     //   context,
  //     //   MaterialPageRoute(
  //     //       builder: (context) => PreviewScreen(
  //     //             imgPath: path,
  //     //           )),
  //     // );
  //   } catch (e) {
  //     _showCameraException(e);
  //   }
  // }

  void _onSwitchCamera() {
    selectedCameraIndex =
        selectedCameraIndex < cameras.length - 1 ? selectedCameraIndex + 1 : 0;
    CameraDescription selectedCamera = cameras[selectedCameraIndex];
    _initCameraController(selectedCamera);
  }
}
