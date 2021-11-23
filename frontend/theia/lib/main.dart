import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './camera_screen.dart';
// import 'package:dio/dio.dart';
// import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';

void main() => runApp(MyApp());

//welcome page when app opens.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Theia',
      home: Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text("Welcome to Theia!"),
          ),
          body: Center(
            child: Column(
              children: <Widget>[
                //TextField(
                //decoration: InputDecoration(
                //border: OutlineInputBorder(),
                //hintText: 'Enter a search term'
                //),
                //),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    'Theia',
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    textScaleFactor: 4,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Terms of Use',
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 14),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Privacy Page',
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 14),
                  ),
                ),
                Container(
                  child: Text(
                    "Allow the app to have access to Camera, Mic and Speaker.",
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  width: 300,
                  height: 100,
                  padding: EdgeInsets.all(12.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xffD3D3D3),
                    border: Border.all(color: Colors.black, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                ),
                MaterialButton(
                  child: Text("Agree ✔️"),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => nextPage()),
                    );
                  },
                  color: Colors.blue,
                ),
                MaterialButton(
                  child: Text("Disagree ❌"),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => exit(0)),
                    );
                  },
                  color: Colors.blue,
                ),
                Spacer(flex: 1),
                Padding(
                  padding: EdgeInsets.all(2.0),
                  child: Text(
                    'Version Number :0.0.1',
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(2.0),
                  child: Text(
                    'Made with ❤️ by Eshan, Rashaad, Sharika and Vishwajeet.',
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//page with instructions.
class nextPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Instructions"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                'Theia',
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.bold),
                textScaleFactor: 4,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'User Manual',
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 14),
              ),
            ),
            Container(
              child: Text(
                "Take an image and we'll convert the image to text.",
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              width: 300,
              height: 100,
              padding: EdgeInsets.all(12.0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xffD3D3D3),
                border: Border.all(color: Colors.black, width: 2.0),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
            ),
            MaterialButton(
              child: Text("Click image 📷"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CameraApp()),
                );
              },
              color: Colors.red,
            ),
            Spacer(flex: 1),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                'Version Number :0.0.1',
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 12),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                'Made with ❤️ by Eshan, Rashaad, Sharika and Vishwajeet.',
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CameraApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.black));
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.black,
      ),
      debugShowCheckedModeBanner: false,
      home: CameraScreen(),
    );
  }
}
