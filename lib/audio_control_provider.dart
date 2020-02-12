
import 'package:audioplayers/audioplayers.dart';

import 'package:flutter/cupertino.dart';

enum PlayerState { stopped, playing, pause }
class AudioProvider extends ChangeNotifier {
  AudioPlayer audioPlayer = AudioPlayer();
  bool isDisplay = false;
}