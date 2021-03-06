import 'package:flutter/material.dart';
import 'package:flutter_camera_x/CameraXController.dart';
import 'package:flutter_camera_x/flutter_cameraX.dart';
import 'package:flutter_camera_x/CameraXDescriptor.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_camera_x/models/enums.dart';
void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  bool torchEnabled = false;
  @override
  void initState() {
    initializeCamera();
    super.initState();
  }

  initializeCamera() async {
    var cameras = await CameraXDescriptor.getAvailableCameras();
    print(cameras);
    _cameraXController = CameraXController(cameras[0]);
    void callback(){
      print("Perform Action Here");
    }
    _cameraXController.listenForPictureClick(callback);
    if (mounted) {
      setState(() {});
    }
  }

  CameraXController _cameraXController;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Container(
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: _cameraXController != null
                        ? CameraXPreview(
                            cameraXController: _cameraXController,
                          )
                        : Text("Loading"),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    children: <Widget>[
                      InkWell(
                        onTap: () async {
                          setState(() {
                            torchEnabled = !torchEnabled;
                          });

                          await _cameraXController.setFlashMode(torchEnabled?FlashModeX.Torch:FlashModeX.Auto);
                        },
                        child: Container(
                          height: 50,
                          child: Text(torchEnabled?"Disable Torch":"Enable Torch"),
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          final path = join((await getTemporaryDirectory()).path,
                              '${DateTime.now()}.png');
                          await _cameraXController.takePicture(path);
                        },
                        child: Container(
                          height: 50,
                          child: Text("Take Picture"),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
