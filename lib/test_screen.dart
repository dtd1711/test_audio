import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:test_audio_service/audio_file.dart';
import 'package:test_audio_service/play_audio_screen.dart';

class TestScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          RaisedButton(
            onPressed: () {
              var route = MaterialPageRoute(builder: (context) => PlayAudioScreen(audioFile: audioFiles[0],audioFiles: audioFiles,title: "test1",ordinal: 1));
              Navigator.push(context, route);
            },
            child: Text('Press to come play screen'),

          ),
          RaisedButton(
            onPressed: () {
              AudioService.stop();
            },
            child: Text('Stop service'),
          )
        ],
      )   
    );
  }
}


List<AudioFile> audioFiles = [
  AudioFile(
    id: 249,
    file: "Bai_Hoc_Cuoc_Song/Nhung_bo_vai_nuong_tua/01-Loi_Gioi_thieu_Nhung_Bo_vai.mp3",
    title: "01-Loi Gioi thieu_Nhung Bo vai",
    audioBookId: 11,
    audioBookTitle: "Những bờ vai nương tựa" 
  ),
  AudioFile(
    id: 250,
    file: "Bai_Hoc_Cuoc_Song/Nhung_bo_vai_nuong_tua/02-dua_con_nuoi_hoan_hao.mp3",
    title: "02-dua_con_nuoi_hoan_hao",
    audioBookId: 11,
    audioBookTitle: "Những bờ vai nương tựa"
  ),
  AudioFile(
    id: 251,
    file: "Bai_Hoc_Cuoc_Song/Nhung_bo_vai_nuong_tua/03-khi_trai_tim.mp3",
    title: "03-khi_trai_tim",
    audioBookId: 11,
    audioBookTitle: "Những bờ vai nương tựa"
  ),
  AudioFile(
    id: 252,
    file: "Bai_Hoc_Cuoc_Song/Nhung_bo_vai_nuong_tua/04-chu_gau_koala.mp3",
    title: "04-chu_gau_koala",
    audioBookId: 11,
    audioBookTitle: "Những bờ vai nương tựa" 
  ),
  AudioFile(
    id: 253,
    file: "Bai_Hoc_Cuoc_Song/Nhung_bo_vai_nuong_tua/05-ten_chau_la_nicolas.mp3",
    title: "05-ten_chau_la_nicolas",
    audioBookId: 11,
    audioBookTitle: "Những bờ vai nương tựa" 
  ),
  AudioFile(
    id: 254,
    file: "Bai_Hoc_Cuoc_Song/Nhung_bo_vai_nuong_tua/06-co_be_toc_xoan.mp3",
    title: "06-co_be_toc_xoan",
    audioBookId: 11,
    audioBookTitle: "Những bờ vai nương tựa"
  ),
];