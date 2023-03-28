import 'dart:io';
import 'package:example/screens/camera_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mrz_scanner/mrz_scanner.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  File? image;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Builder(builder: (context) {
          return Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (image != null) Image.file(image!),
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                        return CameraScreen();
                      }));
                    },
                    child: Text("scan with camera")),
                ElevatedButton(
                    onPressed: () async {
                      var mrzResult = await MrzWithGallery().pickImage();

                      if (mrzResult != null) {
                        showDialog(
                          context: context,
                          builder: (context) => Dialog(
                            insetPadding: const EdgeInsets.symmetric(horizontal: 10),
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Reset Scanning'),
                                  ),
                                  Text('Name : ${mrzResult.givenNames}'),
                                  Text('Gender : ${mrzResult.sex.name}'),
                                  Text('CountryCode : ${mrzResult.countryCode}'),
                                  Text('Date of Birth : ${mrzResult.birthDate}'),
                                  Text('Expiry Date : ${mrzResult.expiryDate}'),
                                  Text('DocNum : ${mrzResult.documentNumber}'),
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                    },
                    child: Text("scan with gallery")),
              ],
            ),
          );
        }),
      ),
    );
  }
}
