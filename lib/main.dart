//About All the ML Apps present here......


// DIGITAL INK RECOGNITION......

// 1..The code is written in Dart language and is a Flutter application that uses the google_mlkit_digital_ink_recognition package
// for digital ink recognition.
//
// 2..The code sets up a Flutter application with a white drawing box where users can draw using touch input.
// The drawn strokes are captured using GestureDetector and stored in the _ink object.
//
// 3..The DigitalInkRecognizerModelManager is used to manage the digital ink
// recognition models. It checks if the model for the specified language is downloaded and downloads it if necessary.
//
// 4..The _recogniseText function performs text recognition on the drawn strokes using the downloaded model.
// It uses the digitalInkRecognizer object to recognize the ink and retrieves a list of RecognitionCandidate objects.
// The recognized text is then extracted from the candidates and stored in the result variable.
//
// 5..The UI of the application consists of a brown-colored background with a text instruction,
// a white drawing box, and two buttons for reading text and clearing the drawing surface.
// The recognized text is displayed below the buttons if available.


//OBJECT DETECTION.....

// 1...The code is a Flutter application that utilizes the camera feed to perform object detection
// using the google_mlkit_object_detection package.
//
// 2..The main() function initializes the Flutter application, retrieves the available cameras
// using the camera package, and runs the MyApp widget as the root of the application.
//
// 3...The MyHomePage widget is the main page of the application. It initializes the camera controller and object detector,
//     and sets up the camera feed using the CameraPreview widget.
//
// 4...The doObjectDetectionOnFrame() function processes each frame from the camera feed and performs object detection
// using the objectDetector object. The detected objects are stored in the _scanResults variable and are displayed using
// the ObjectDetectorPainter custom painter.
//
// 5...The ObjectDetectorPainter custom painter is responsible for drawing rectangles around the detected
// objects on the camera feed. It uses the detected objects' bounding boxes and labels to draw the rectangles and display
// the labels on the screen.