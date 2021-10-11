/*
 * Copyright 2018, 2019, 2020, 2021 Dooboolab.
 *
 * This file is part of Flutter-Sound.
 *
 * Flutter-Sound is free software: you can redistribute it and/or modify
 * it under the terms of the Mozilla Public License version 2 (MPL2.0),
 * as published by the Mozilla organization.
 *
 * Flutter-Sound is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * MPL General Public License for more details.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

import 'package:audiotuto/audio_record_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/*
 * This is an example showing how to record to a Dart Stream.
 * It writes all the recorded data from a Stream to a File, which is completely stupid:
 * if an App wants to record something to a File, it must not use Streams.
 *
 * The real interest of recording to a Stream is for example to feed a
 * Speech-to-Text engine, or for processing the Live data in Dart in real time.
 *
 */

///

/// Example app.
class RecordToStreamExample extends StatefulWidget {
  @override
  _RecordToStreamExampleState createState() => _RecordToStreamExampleState();
}

class _RecordToStreamExampleState extends State<RecordToStreamExample> {
  AudioRecordController recController = Get.put(AudioRecordController());

  // ----------------------------------------------------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    Widget makeBody() {
      return GetBuilder<AudioRecordController>(
          // specify type as Controller
          init: AudioRecordController(), // intialize with the Controller
          builder: (value) => Column(
                children: [
                  Container(
                    margin: const EdgeInsets.all(3),
                    padding: const EdgeInsets.all(3),
                    height: 80,
                    width: double.infinity,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Color(0xFFFAF0E6),
                      border: Border.all(
                        color: Colors.indigo,
                        width: 3,
                      ),
                    ),
                    child: Row(children: [
                      ElevatedButton(
                          onPressed: recController.getRecorderFn(),
                          //color: Colors.white,
                          //disabledColor: Colors.grey,
                          child: recIcon()),
                      SizedBox(
                        width: 20,
                      ),
                      Text(recController.mRecorder!.isRecording
                          ? 'Recording in progress'
                          : 'Recorder is stopped'),
                    ]),
                  ),
                  Container(
                    margin: const EdgeInsets.all(3),
                    padding: const EdgeInsets.all(3),
                    height: 80,
                    width: double.infinity,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Color(0xFFFAF0E6),
                      border: Border.all(
                        color: Colors.indigo,
                        width: 3,
                      ),
                    ),
                    child: Row(children: [
                      ElevatedButton(
                        onPressed: recController.getPlaybackFn(),
                        //color: Colors.white,
                        //disabledColor: Colors.grey,
                        child: Text(
                            recController.mPlayer!.isPlaying ? 'Stop' : 'Play'),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(recController.mPlayer!.isPlaying
                          ? 'Playback in progress'
                          : 'Player is stopped'),
                    ]),
                  ),
                  // Container(
                  //   color: Colors.white,
                  //   child: StreamBuilder(stream: getDecibleStream, builder: builder),
                  // )
                ],
              ));
    }

    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: const Text('Record to Stream ex.'),
      ),
      body: makeBody(),
    );
  }

  Widget recIcon() {
    return Container(
      height: 48,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(30),
        ),
        gradient: LinearGradient(
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
            colors: [
              Color(
                0xff1312FA,
              ),
              Color(
                0xff1312FA,
              ),
              Color(
                0xff6900eb,
              )
            ]),
      ),
      child: AspectRatio(
        aspectRatio: 1,
        child: Center(
            child: recController.mRecorder!.isRecording
                ?
                //SvgPicture.asset(
                Icon(Icons.pause)
                : Icon(Icons.mic)
            // ? "assets/svg/audio_trash.svg"
            // : "assets/svg/micro.svg",
            //  ),
            //),
            // ),
            // ),
            ),
      ),
    );
  }
}
