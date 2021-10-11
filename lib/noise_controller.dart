// import 'dart:async';

// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:noise_meter/noise_meter.dart';

// class NoiseController extends GetxController {

//   @override
//   void onInit() {
   
//     super.onInit();
//   }

//   @override
//   void onClose() {
//     _noiseSubscription?.cancel();
//     super.onClose();
//   }

//   void onData(NoiseReading noiseReading) {
//     if (!_isRecording) {
//       _isRecording = true;
//     }
//     update();
//     print("noiseReading.toString()");
//   }

//   void onError(PlatformException e) {
//     print(e.toString());
//     _isRecording = false;
//   }

//   void start() async {
//     try {
//       _noiseSubscription = _noiseMeter.noiseStream.listen(onData);
//     } catch (err) {
//       print(err);
//     }
//   }

//   void stop() async {
//     try {
//       if (_noiseSubscription != null) {
//         _noiseSubscription!.cancel();
//         _noiseSubscription = null;
//       }
//       this._isRecording = false;
//       update();
//     } catch (err) {
//       print('stopRecorder error: $err');
//     }
//   }
// }
