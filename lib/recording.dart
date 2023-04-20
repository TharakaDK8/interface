/////////////////////////////////////
// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:gallery_saver/gallery_saver.dart';
// import 'package:image_picker/image_picker.dart';

// void main() => runApp(MyApp());

// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   String firstButtonText = 'Take photo';
//   String secondButtonText = 'Record video';
//   double textSize = 20;

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//         home: Scaffold(
//           body: Container(
            
//             color: Colors.white,
//             child: Column(
//               children: <Widget>[
//                 Flexible(
//                   flex: 1,
//                   child: Container(
//                     child: SizedBox.expand(

//                     ),
//                   ),
//                 ),
//                 Flexible(
//                   child: Container(
//                       child: SizedBox.expand(
//                         child: ElevatedButton(
//                           onPressed: _recordVideo,
//                           child: Text(secondButtonText,
//                               style: TextStyle(
//                                   fontSize: textSize, color: Colors.blueGrey)),
//                         ),
//                       )),
//                   flex: 1,
//                 )
//               ],
//             ),
//           ),
//         ));
//   }



  // void _recordVideo() async {
  //   final ImagePicker picker = ImagePicker();
  //   picker.pickVideo(source: ImageSource.camera)
  //       .then((recordedVideo) {
  //     if (recordedVideo != null && recordedVideo.path != null) {
  //       setState(() {
  //         secondButtonText = 'saving in progress...';
  //       });
  //       GallerySaver.saveVideo(recordedVideo.path).then((path) {
  //         setState(() {
  //           secondButtonText = 'video saved!';
  //         });
  //       });
  //     }
  //   });
  // }

// }



////////////////////////////////////////////////////////






import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';
import 'button.dart';
import 'dart:async';

List<CameraDescription> cameras = [];

Route _createRoute(page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      final tween = Tween(begin: begin, end: end);
      final offsetAnimation = animation.drive(tween);

      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
  );
}

class RecordingPage extends StatefulWidget {
  // const LoginPage({super.key});

  @override
  _RecordingPageState createState() => _RecordingPageState();
}

class _RecordingPageState extends State<RecordingPage> {
  bool isWorking = false;

  String result = "";

  CameraController? cameraController;
  CameraController? controller;

  CameraImage? imgCamera;

  void _recordVideo() async {
    final ImagePicker picker = ImagePicker();
    picker.pickVideo(source: ImageSource.camera)
        .then((recordedVideo) {
      if (recordedVideo != null && recordedVideo.path != null) {
        setState(() {
          print('saving in progress...');
         // secondButtonText = 'saving in progress...';
        });
        GallerySaver.saveVideo(recordedVideo.path).then((path) {
          setState(() {
            print('video saved!');
            //secondButtonText = 'video saved!';
          });
        });
      }
    });
  }

  Future<void> startVideoRecording() async {
    final CameraController? cameraController = controller;
    if (controller!.value.isRecordingVideo) {
      // A recording has already started, do nothing.
      return;
    }
    try {
      await cameraController!.startVideoRecording();
      setState(() {
        // _isRecordingInProgress = true;
        // print(_isRecordingInProgress);
      });
    } on CameraException catch (e) {
      print('Error starting to record video: $e');
    }
  }


  Future<XFile?> stopVideoRecording() async {
    if (!controller!.value.isRecordingVideo) {
      // Recording is already is stopped state
      return null;
    }
    try {
      XFile file = await controller!.stopVideoRecording();
      await GallerySaver.saveVideo(file.path);
      File(file.path).deleteSync();
      setState(() {
      });
      return file;
    } on CameraException catch (e) {
      print('Error stopping video recording: $e');
      return null;
    }
  }

 
  

  loadModel() async {
    await Tflite.loadModel(
      model: 'assets/mobilenet_v1_1.0_224.tflite',
      labels: 'assets/mobilenet_v1_1.0_224.txt',
    );
  }

  initCamera() {
    cameraController = CameraController(cameras[0], ResolutionPreset.medium);
    cameraController!.startVideoRecording();
    cameraController?.initialize().then((value) {
      if (!mounted) {
        return;
      }
      setState(() {
        cameraController?.startImageStream((imageFromStream) => {
              if (!isWorking)
                {
                  isWorking = true,
                  imgCamera = imageFromStream,
                  runModelOnStreamFrames(),
                }
            });


      });
    });
  }

  runModelOnStreamFrames() async {
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
      recognitions?.forEach((response) {
        result += response["label"]
            // +
            //     " " +
            //     (response["confidence"] as double).toStringAsFixed(2) +
            //     "\n\n"
            ;
      });
      setState(() {
        result;
      });
      isWorking = false;
    }
  }

  @override
  void initState() {
    loadModel();
    _start();
    startVideoRecording();
    //_recordVideo();
    super.initState();
  }

  @override
  void dispose() async {
    await Tflite.close();
    cameraController!.dispose();
    super.dispose();
  }

    // Initialize an instance of Stopwatch
  final Stopwatch _stopwatch = Stopwatch();

  // Timer
  late Timer _timer;

  // The result which will be displayed on the screen
  String _result = '00:00:00';

  // This function will be called when the user presses the Start button
  void _start() {
    // Timer.periodic() will call the callback function every 100 milliseconds
    _timer = Timer.periodic(const Duration(milliseconds: 30), (Timer t) {
      // Update the UI
      setState(() {
        // result in hh:mm:ss format
        _result =
            '${_stopwatch.elapsed.inMinutes.toString().padLeft(2, '0')}:${(_stopwatch.elapsed.inSeconds % 60).toString().padLeft(2, '0')}:${(_stopwatch.elapsed.inMilliseconds % 100).toString().padLeft(2, '0')}';
      });
    });
    // Start the stopwatch
    _stopwatch.start();
    //start the camera
    initCamera();
  }

  void _saveVideo() async{
    final video = await cameraController!.stopVideoRecording();
    await GallerySaver.saveVideo(video.path);
    File(video.path).deleteSync();
    print("done1");

  }
  // This function will be called when the user presses the Stop button
  Future<void> recoed() async {
    await stopVideoRecording();
  }
  void _stop(){
    _timer.cancel();
    _stopwatch.stop();
    recoed();

    //_saveVideo();
    print("done2");
    Navigator.of(context).push(_createRoute(ButtonPage()));
  }

  // // This function will be called when the user presses the Reset button
  // void _reset() {
  //   _stop();
  //   _stopwatch.reset();

  //   // Update the UI
  //   setState(() {});
  // }

  

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          body: Container(
            // padding: const EdgeInsets.fromLTRB(10, 10, 10, 30),
            color: Colors.black,
            // child: Container(
            //   color: Colors.black,
            // ),
            child: Column(
              children: [
                // Expanded(child: Text('data')),
                Stack(children: [
                  Container(
                    color: Colors.black,
                    height:MediaQuery.of(context).size.height*0.92,
                    child: imgCamera == null
                        ? Expanded(
                            flex: 12,
                            child: Container(
                              // color: Colors.red,
                              height:MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                            ),
                          )
                        : Expanded(
                            flex: 12,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              child: AspectRatio(
                                aspectRatio:
                                    cameraController!.value.aspectRatio,
                                child: CameraPreview(cameraController!),
                              ),
                            ),
                          ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height*0.7,
                    child: Center(
                      child: Text(
                        result,
                        // textAlign: TextAlign.center,
                        // 'Detected Incident : ',
                        style: TextStyle(
                          fontSize: 17,
                          fontFamily: 'RobotoSlab',
                          fontWeight: FontWeight.bold,
                          backgroundColor: Colors.black87,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 20,
                    left: 10,
                    child: Container(

                      child:imgCamera == null
                          ? Text(
                              '',
                            )
                          : Text(
                              'Inference Time     : $_result',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontFamily: 'RobotoSlab',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                  
                   Positioned(
                     top: 10,
                     right: 10,
                     child: SizedBox(
                       width: 130,
                       height: 50,
                       child: imgCamera == null
                           ? Container()
                       // ElevatedButton(
                       //         style: ElevatedButton.styleFrom(
                       //           backgroundColor: Colors.transparent,
                       //           shape: RoundedRectangleBorder(
                       //             borderRadius: BorderRadius.circular(30.0),
                       //           ),
                       //         ),
                       //         onPressed: () {
                       //           _start() ;
                       //         },
                       //         child: Text(
                       //           'Start',
                       //           style: TextStyle(
                       //               color: Colors.transparent, fontSize: 19),
                       //         ),
                       //       )
                           : ElevatedButton(
                               style: ElevatedButton.styleFrom(
                                 backgroundColor: Colors.black,
                                 shape: RoundedRectangleBorder(
                                   borderRadius: BorderRadius.circular(30.0),
                                 ),
                               ),
                               onPressed: () {
                                 _stop();
                               },
                               child: Text(
                                 'Exit',
                                 style: TextStyle(
                                     color: Colors.white, fontSize: 19),
                               ),
                             ),
                     ),
                   ),
                ]),
                // SizedBox(
                //   height: 10,
                // ),
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}
