// ignore_for_file: file_names

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class SoundService {
  static playLocalSound(String localPath) async {
    final soundPlayer = AudioCache();
    try {
      soundPlayer.play(localPath);
    } catch (t) {
      if (kDebugMode) {
        print("sound error! $t");
      }
    }
  }
}
