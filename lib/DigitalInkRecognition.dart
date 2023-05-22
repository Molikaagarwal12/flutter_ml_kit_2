import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:google_mlkit_digital_ink_recognition/google_mlkit_digital_ink_recognition.dart' as dir;
import 'package:google_mlkit_digital_ink_recognition/google_mlkit_digital_ink_recognition.dart';

void main() {
  runApp(MyHomePage());
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final String _language = 'en-US';
  late dir.Ink _ink;
  List<dir.StrokePoint> _points = [];
  String result = 'recognized text will be shown here';

  //TODO declare detector
   late DigitalInkRecognizerModelManager modelManager;
  @override
  void initState() {
    // TODO: implement initState
     modelManager = DigitalInkRecognizerModelManager();
    super.initState();
    //TODO initialize detector
    checkAndDownloadModel();
    _ink = dir.Ink();
  }

  bool isModelDownloaded = false;
  dynamic digitalInkRecognizer;
  checkAndDownloadModel() async {
    print("check model start");

    //TODO check if model is downloaded or not
    isModelDownloaded = await modelManager.isModelDownloaded(_language);

    //TODO download models if not downloaded
     if(!isModelDownloaded){
       isModelDownloaded= await modelManager.downloadModel(_language);
     }

    //TODO if models are loaded then create recognizer
    if(isModelDownloaded){
      digitalInkRecognizer = DigitalInkRecognizer(languageCode: _language);
    }
    print("check model end");
  }

  @override
  void dispose() {
    super.dispose();

  }

  //TODO clear the drawing surface
  void _clearPad() {
    setState(() {
      _ink.strokes.clear();
      _points.clear();
      result = '';
    });
  }

  //TODO perform text recognition
  Future<void> _recogniseText() async {
    if(isModelDownloaded){
    final List<RecognitionCandidate> candidates = await digitalInkRecognizer.recognize(_ink);
    result=" ";
    for (final candidate in candidates) {
      final text = candidate.text;
      final score = candidate.score;
      result+=text+"\n";
    }
    setState(() {
      result;
    });}
    else{
      result="model is not downloaded yet";
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      home: Scaffold(
          backgroundColor: Colors.brown,
          body: Column(
            children: [
              Container(margin: const EdgeInsets.only(top: 60),child: const Text('Draw in the white box below',style: TextStyle(color: Colors.white),)),
              Container(
                margin: const EdgeInsets.only(top: 10),
                color: Colors.white,
                width: 370,
                height: 370,
                child: GestureDetector(
                  onPanStart: (DragStartDetails details){
                    _ink.strokes.add(Stroke());
                    print("onPanStart");
                  },
                  onPanUpdate: (DragUpdateDetails details){
                    print("OnPanUpdate");
                    setState(() {
                      final RenderObject? object=context.findRenderObject();
                      final localPosition=(object as RenderBox?)?.globalToLocal(details.localPosition);
                      if(localPosition!=null){
                        _points=List.from(_points)
                            ..add(StrokePoint(x: localPosition.dx, y: localPosition.dy, t: DateTime.now().millisecondsSinceEpoch));
                      }
                      if(_ink.strokes.isNotEmpty){
                        _ink.strokes.last.points=_points.toList();
                      }
                    });
                  },
                  onPanEnd: (DragEndDetails details){
                    print("OnPanEnd");
                    _points.clear();
                    setState(() {

                    });
                  },
                  child: CustomPaint(
                    painter: Signature(ink: _ink),
                    size: Size.infinite,
                  ),
                )
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: _recogniseText,
                      style: ElevatedButton.styleFrom(primary: Colors.black),
                      child: const Text('Read Text'),
                    ),
                    ElevatedButton(
                      onPressed: _clearPad,
                      style: ElevatedButton.styleFrom(primary: Colors.black),
                      child: const Text('Clear Pad'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10,),
              if (result.isNotEmpty)
                Text(
                  result,
                  style: const TextStyle(fontSize: 18,color: Colors.white),
                ),
            ],
          )),
    );
  }
}

class Signature extends CustomPainter{
  dir.Ink ink;
  Signature({required this.ink});
  @override
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.blue
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4.0;
    for (final stroke in ink.strokes) {
      for (int i = 0; i < stroke.points.length - 1; i++) {
        final p1 = stroke.points[i];
        final p2 = stroke.points[i + 1];
        canvas.drawLine(Offset(p1.x.toDouble(), p1.y.toDouble()),
            Offset(p2.x.toDouble(), p2.y.toDouble()), paint);
      }
    }
  }
  bool shouldRepaint(Signature oldDelegate)=>true;
}