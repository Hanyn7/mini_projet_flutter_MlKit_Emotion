import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mini_p/features/home/controller/home_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeController _homeController = HomeController();

  @override
  void initState() {
    super.initState();
    _initializeController();
  }

  Future<void> _initializeController() async {
    await _homeController.loadCamera();
    _homeController.startImageStream();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Camera App'),
        centerTitle: true,
      ),
      body: GetBuilder<HomeController>(
        init: _homeController,
        builder: (_) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 4,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey.shade400,
                      width: 2.0,
                    ),
                  ),
                  child: _.cameraController?.value.isInitialized ?? false
                      ? AspectRatio(
                          aspectRatio: _.cameraController!.value.aspectRatio,
                          child: CameraPreview(_.cameraController!),
                        )
                      : Center(child: CircularProgressIndicator()),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blueGrey.withOpacity(0.1),
                      ),
                      child: _.getLottieAnimationWidget(
                        Size(100, 100),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      '${_.label ?? ''}',
                      style: TextStyle(
                        fontSize: 25,
                        color: const Color.fromARGB(255, 5, 4, 4),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
