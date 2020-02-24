import 'package:audioplayers/audioplayers.dart';
import './audio_file.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';

import 'package:audio_service/audio_service.dart';
enum PlayerState { stopped, playing, paused }

class AudioControl extends ChangeNotifier {

  AudioPlayer audioPlayer = AudioPlayer();
  Duration _position;
  Duration _duration;
  AudioFile audio;
  List<AudioFile> audioList;
  int _ordinal;

  PlayerState _playerState = PlayerState.stopped;

  StreamSubscription _durationSubscription;
  StreamSubscription _playerCompleteSubscription;
  StreamSubscription _playerErrorSubscription;
  StreamSubscription _playerStateSubscription;
  StreamSubscription _positonSubscription;

  get durationText => _duration?.toString()?.split('.')?.first ?? '';
  get positionText => _position?.toString()?.split('.')?.first ?? '';
  
  get position => _position;
  void setPosition(Duration position){
    _position = position;
    notifyListeners();
  }

  get duration => _duration;
  void setDuration(Duration duration){
    _duration = duration;
    notifyListeners();
  }

  get getState => _playerState;
  void setState(PlayerState _state){
    _playerState = _state;
    notifyListeners();
  }

  get getOrdinal => _ordinal;
  void setOrdinal(int ordinal){
    _ordinal = ordinal;
    notifyListeners();
  }

  bool minId() {
    return audio.id == audioList[0].id;
  }
  bool maxId() {
    return audio.id == audioList[audioList.length - 1].id;
  }

  void skipPrevious(){
    for(int i = 0; i < audioList.length; i ++){
      if(audio.id == audioList[i].id){
        audio = audioList[i - 1];
        break;
      }
    }
    _ordinal --;
    notifyListeners();
  }

  void skipNext(){
    for(int i = 0; i < audioList.length; i ++){
      if(audio.id == audioList[i].id){
        audio = audioList[i + 1];
        break;
      }
    }
    _ordinal ++;
    notifyListeners();
  }

  void initFunc() {

    _durationSubscription = audioPlayer.onDurationChanged.listen((duration) {
        setDuration(duration);
    });

    _positonSubscription = audioPlayer.onAudioPositionChanged.listen((p) {
      
        setPosition(p);

    });
    
    _playerCompleteSubscription = audioPlayer.onPlayerCompletion.listen( (event) {
      onComplete();
  
        _position = _duration;
        notifyListeners();
    });

    _playerErrorSubscription = audioPlayer.onPlayerError.listen((msg) {
    
        _playerState = PlayerState.stopped;
        _duration = Duration(seconds: 0);
        _position = Duration(seconds: 0);
        notifyListeners();
    });
    
  }

  bool isInList(){
    int length = audioList != null ? audioList.length : 0;
    bool result = false;
    for(int i = 0 ; i < length; i++){
      if(audio.id == audioList[i].id){
        result = true;
        break;
      }
    }
    return result;
  }

   void disposeFunc() async{
    await audioPlayer.stop();
    onComplete();
    _durationSubscription?.cancel();
    _positonSubscription?.cancel();
    _playerCompleteSubscription?.cancel();
    _playerErrorSubscription?.cancel();
    _playerStateSubscription?.cancel();
    setPosition(Duration(seconds: 0));
    setDuration(Duration(seconds: 0));
  }

  Future<int> play() async {
    Duration playPosition = (_position != null &&
      _duration != null &&
      _position.inMilliseconds > 0 &&
      _position.inMilliseconds < _duration.inMilliseconds)
      ? _position
      : null;
    String vietvanUrl = 'https://vietvan.net/audioSources/${audio.file}';
    final result = await audioPlayer.play(vietvanUrl, position: playPosition,);
    if (result == 1) {
      setState(PlayerState.playing);
    }

    audioPlayer.setPlaybackRate(playbackRate: 1.0);

    return result;
  }

  Future<int> pause() async {
    final result = await audioPlayer.pause();
    if (result == 1) {setState(PlayerState.paused);}
    return result;     
  }

  Future<int> skip() async {
    final temp = await stop();
    if(temp == 1) {
      final result = await play();
      return result;
    }
    return temp;
  }

  Future<int> stop() async {
    final result = await audioPlayer.stop();
    if (result == 1) {
        setState(PlayerState.stopped);
        _position = Duration();
    }
    return result;
  }


  void onComplete() {
    setState(PlayerState.stopped);
  }

  bool isVisible = false;  

  void setAudioInfo(AudioFile _audio,List<AudioFile> _audioList,int ordinal){
    audio = _audio;
    audioList = _audioList;
    _ordinal = ordinal;
    notifyListeners();
  }

  void setAudio(AudioFile _audio){
    audio = _audio;
    notifyListeners();
  }

  void setAudioList(List<AudioFile> _audioList){
    audioList = _audioList;
    notifyListeners();
  }

  void setVisible() {
    isVisible = true;
    notifyListeners();
  }

}