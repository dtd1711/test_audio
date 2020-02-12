
import 'package:audio_service/audio_service.dart';

import './audio_file.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';


import 'dart:async';

enum PlayerState { stopped, playing, pause }

class AudioPlaying extends StatefulWidget {
  
  final String title;
  final String url;
  final PlayerMode mode;
  final int id;
  final List<AudioFile> audioFiles;
  final int ordinal; 
  final AudioPlayer audioPlayer;

  AudioPlaying({this.url,this.mode = PlayerMode.MEDIA_PLAYER,this.id,this.audioFiles,this.title,this.ordinal,this.audioPlayer});

  @override
  State<StatefulWidget> createState() {
    return _AudioPlayingState(url:url,mode:mode,id: id,audioFiles: audioFiles,ordinal: ordinal);
  }
}

class _AudioPlayingState extends State<AudioPlaying> {

  String url;
  PlayerMode mode;
  int id;
  int ordinal;
  double volumn;
  List<AudioFile> audioFiles;
 
  AudioPlayer audioPlayer ;
  AudioPlayerState _audioPlayerState;
  Duration _duration ;
  Duration _position ;

  PlayerState _playerState = PlayerState.stopped;
  StreamSubscription _durationSubscription;
  StreamSubscription _playerCompleteSubscription;
  StreamSubscription _playerErrorSubscription;
  StreamSubscription _playerStateSubscription;
  StreamSubscription _positonSubscription;

  get _isPlaying => _playerState == PlayerState.playing;
  get _durationText => _duration?.toString()?.split('.')?.first ?? '';
  get _positionText => _position?.toString()?.split('.')?.first ?? '';
  get _isMinId => id == AudioFile.minId(audioFiles);
  get _isMaxId => id == AudioFile.maxId(audioFiles);
  

  _AudioPlayingState({this.url,this.mode,this.id,this.audioFiles,this.ordinal});
  @override
  void initState() {
    super.initState();
    inintPlayer();
  }

  inintPlayer(){
    
    audioPlayer = AudioPlayer(mode: widget.mode);
    volumn = 1.0;

    _durationSubscription = audioPlayer.onDurationChanged.listen((duration) {
      setState(() {
        _duration = duration;
      });
    });

    _positonSubscription = audioPlayer.onAudioPositionChanged.listen((p) {
      setState(() {
        _position = p;
      });
    });
    
    _playerCompleteSubscription = audioPlayer.onPlayerCompletion.listen( (event) {
      onComplete();
      setState(() {
        _position = _duration;
      });
    });

    _playerErrorSubscription = audioPlayer.onPlayerError.listen((msg) {
      print('audioPlayer error : $msg');
      setState(() {
        _playerState = PlayerState.stopped;
        _duration = Duration(seconds: 0);
        _position = Duration(seconds: 0);
      });
    });
    
    audioPlayer.onPlayerStateChanged.listen( (state) {
      if(!mounted) return;
      setState(() {
        _audioPlayerState = state;
      });
    });

    audioPlayer.onNotificationPlayerStateChanged.listen( (state) {
      if (!mounted) return;
      setState(() {
        _audioPlayerState = state;
      }); 
    });
  }

  void onComplete() {
    setState(() => _playerState = PlayerState.stopped);
  }
  
  @override
  void dispose() {
    audioPlayer.stop();
    _durationSubscription?.cancel();
    _positonSubscription?.cancel();
    _playerCompleteSubscription?.cancel();
    _playerErrorSubscription?.cancel();
    _playerStateSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 16.0,left: 16.0,right: 16.0),
          child:Text(
            "${widget.title} - $ordinal",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24.0,
            ),
          ),
        ),
        seekSlider(screenSize),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                _position != null ? _positionText : '0:00:00',
                style: TextStyle(fontSize: 18.0),
              ),
              Text(
                _duration != null ? _durationText : '0:00:00',
                style: TextStyle(fontSize: 18.0),
              ),    
            ],
          ),
        ),
        button(screenSize),
        volumnSlider(screenSize),
      ],
    );
  }

  Widget seekSlider(Size screenSize) {
    return Container(
      child:Slider(
        onChanged: (v) {
          final position = v * _duration.inMilliseconds;
          audioPlayer
              .seek(Duration(milliseconds: position.round()));
        },
        value: (_position != null &&
          _duration != null &&
          _position.inMilliseconds > 0 &&
          _position.inMilliseconds < _duration.inMilliseconds)
          ? _position.inMilliseconds / _duration.inMilliseconds
          : 0.0,
        activeColor: Colors.white,
        inactiveColor: Colors.white38,
      ),
    );
  }

  Widget button(Size screenSize) {

    var playButton = _isPlaying 
      ? GestureDetector(
        onTap: () => _pause(),
        child: Icon(Icons.pause,size: 48.0,),
      )
      : GestureDetector(
        onTap: () {
            _play();
        },
        child: Icon(Icons.play_arrow,size: 48.0,)
      );

    return Container(
      width: screenSize.width*0.4,
      
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              if(!_isMinId){
                setState(() {
                  ordinal = ordinal - 1;
                  id = id-1;
                  url = AudioFile.idToFile(id, audioFiles);
                });
                _skip();
              }
            },
            child: Icon(
              Icons.skip_previous,size: 32.0,
              color: !_isMinId ? Colors.white : Colors.white54,
            ),
          ),
          
          playButton,
           GestureDetector(
            onTap: () {
              if(!_isMaxId){
                setState(() {
                ordinal = ordinal + 1;
                id = id+1;
                url = AudioFile.idToFile(id , audioFiles);
                });
                _skip();
              }        
            },   
            child: Icon(
              Icons.skip_next,size: 32.0,
              color: !_isMaxId ? Colors.white : Colors.white54,
            ),
          )   
        ],
      ),
    );
  }

  Widget volumnSlider(Size screenSize) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(Icons.volume_down),
        Slider(
          onChanged: (value){
            setState(() {
              volumn = value;
            });
            audioPlayer.setVolume(volumn);
          },
          value: volumn,
          max: 1.0,
          min: 0.0,
        ),
        Icon(Icons.volume_up),
      ],
    );
  }

  Future<int> _play() async {
    Duration playPosition = (_position != null &&
      _duration != null &&
      _position.inMilliseconds > 0 &&
      _position.inMilliseconds < _duration.inMilliseconds)
      ? _position
      : null;
    String vietvanUrl = 'https://vietvan.net/audioSources/$url';
    final result = await audioPlayer.play(vietvanUrl, position: playPosition,volume: volumn);
    if (result == 1) setState(() => _playerState = PlayerState.playing);

    audioPlayer.setPlaybackRate(playbackRate: 1.0);

    return result;
  }

  Future<int> _pause() async {
    final result = await audioPlayer.pause();
    if (result == 1) setState(() {
      _playerState = PlayerState.pause;
    });
    return result;     
  }

  Future<int> _skip() async {
    final temp = await _stop();
    if(temp == 1) {
      final result = await _play();
      return result;
    }
    return temp;
  }

  Future<int> _stop() async {
    final result = await audioPlayer.stop();
    if (result == 1) {
      setState(() {
        _playerState = PlayerState.stopped;
        _position = Duration();
      });
    }
    return result;
  }

}