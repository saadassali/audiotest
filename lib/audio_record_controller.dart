import 'dart:async';
import 'dart:io';

import 'package:audiotuto/noise_controller.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:noise_meter/noise_meter.dart';

class AudioRecordController extends GetxController {
  FlutterSoundPlayer? mPlayer = FlutterSoundPlayer();
  FlutterSoundRecorder? mRecorder = FlutterSoundRecorder();
  bool mPlayerIsInited = false;
  bool mRecorderIsInited = false;
  bool mplaybackReady = false;
  String? mPath;
  StreamSubscription? mRecordingDataSubscription;
  bool isRecording = false;
  StreamSubscription<NoiseReading>? _noiseSubscription;
  late NoiseMeter _noiseMeter = NoiseMeter(onError);

  List<double?> deciblelist = [];

  // ignore: cancel_subscriptions
  //noise

  @override
  void onData(NoiseReading noiseReading) {
    if (!isRecording) {
      isRecording = true;
    }
    update();
    print('data');
    // print(noiseReading.toString());
  }

  void onError(Object error) {
    print(error.toString());
    isRecording = false;
  }

  void startNoiseRecorder() async {
    try {
      _noiseSubscription = _noiseMeter.noiseStream.listen(onData);
    } catch (err) {
      print(err);
    }
  }

  void stopNoiseRecorder() async {
    try {
      if (_noiseSubscription != null) {
        _noiseSubscription!.cancel();
        _noiseSubscription = null;
      }
      isRecording = false;
      update();
    } catch (err) {
      print('stopRecorder error: $err');
    }
  }
  //-------------------

  Future<void> _openRecorder() async {
    var status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Microphone permission not granted');
    }
    await mRecorder!.openAudioSession();

    mRecorderIsInited = true;
    update();
  }

  @override
  void onInit() {
    super.onInit();
    mPlayer!.openAudioSession().then((value) {
      mPlayerIsInited = true;
      update();
    });
    _openRecorder();
    _noiseMeter = new NoiseMeter(onError);
  }

  @override
  void onClose() {
    super.onClose();
    stopPlayer();
    mPlayer!.closeAudioSession();
    mPlayer = null;

    stopRecorder();
    mRecorder!.closeAudioSession();
    mRecorder = null;
    stopNoiseRecorder();
  }

  Future<IOSink> createFile() async {
    var tempDir = await getTemporaryDirectory();
    mPath = '${tempDir.path}/flutter_sound_example.pcm';
    var outputFile = File(mPath!);
    if (outputFile.existsSync()) {
      await outputFile.delete();
    }
    return outputFile.openWrite();
  }

  Future<void> record() async {
    assert(mRecorderIsInited && mPlayer!.isStopped);
    var sink = await createFile();

    var recordingDataController = StreamController<Food>();
    startNoiseRecorder();
    mRecordingDataSubscription =
        recordingDataController.stream.listen((buffer) {
      print("recordingDataController.stream");

      // mRecordingDataSubscription!.onData((data) {});

      if (buffer is FoodData) {
        // print(buffer.data);

        sink.add(buffer.data!);
      }
    });
    startNoiseRecorder();
    await mRecorder!.startRecorder(
      toStream: recordingDataController.sink,
      codec: Codec.pcm16,
      numChannels: 1,
      sampleRate: tSampleRate,
    );

    update();
  }

  Future<void> stopRecorder() async {
    print('stopp rec');
    _noiseSubscription!.cancel();
    _noiseSubscription = null;

    await mRecorder!.stopRecorder();
    if (mRecordingDataSubscription != null) {
      await mRecordingDataSubscription!.cancel();
      mRecordingDataSubscription = null;
    }
    mplaybackReady = true;

    update();
  }

  _Fn? getRecorderFn() {
    if (!mRecorderIsInited || !mPlayer!.isStopped) {
      return null;
    }
    return mRecorder!.isStopped
        ? record
        : () {
            stopRecorder().then((value) => update());
          };
  }

  void play() async {
    assert(mPlayerIsInited &&
        mplaybackReady &&
        mRecorder!.isStopped &&
        mPlayer!.isStopped);
    await mPlayer!.startPlayer(
        fromURI: mPath,
        sampleRate: tSampleRate,
        codec: Codec.pcm16,
        numChannels: 1,
        whenFinished: () {
          update();
        }); // The readability of Dart is very special :-(
    update;
  }

  Future<void> stopPlayer() async {
    await mPlayer!.stopPlayer();
  }

  _Fn? getPlaybackFn() {
    if (!mPlayerIsInited || !mplaybackReady || !mRecorder!.isStopped) {
      return null;
    }
    return mPlayer!.isStopped
        ? play
        : () {
            stopPlayer().then((value) => update());
          };
  }
}

const int tSampleRate = 44100;
typedef _Fn = void Function();
