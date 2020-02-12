import 'package:http/io_client.dart';
import 'dart:io';
import 'dart:convert';
class AudioFile {
  int id;
  String file;
  String title;
  int listenCount;
  double rating;
  double ratingCount;
  int audioBookId;
  String audioBookTitle;

  AudioFile({this.id,this.file,this.title,this.listenCount,this.rating,this.ratingCount,this.audioBookId,this.audioBookTitle});

  factory AudioFile.fromJson(Map<String, dynamic> json) {
    return AudioFile(
      id: json['id'],
      file: json['file'],
      title: json['title'],
      listenCount: json['listenCount'],
      rating: json['rating'],
      ratingCount: json['ratingCount'],
      audioBookId: json['audioBookId'],
      audioBookTitle: json['audioBookTitle']       
    );
  }

  static Future<List<AudioFile>> fetchAudioList(int id) async {
    String url = 'https://vietvan.net/api/audioBookParts/byAudioBookId?audioBookId=$id';
    HttpClient httpClient = HttpClient()
    ..badCertificateCallback = ((X509Certificate cert,String host,int port) => true);
    IOClient ioClient = IOClient(httpClient);
    var response = await ioClient.get(url);
    if(response.statusCode == 200) {
      var jsonData = json.decode(response.body) as List;
      List<AudioFile> result = jsonData.map((element) => AudioFile.fromJson(element)).toList();
      return result;
    }else{
      throw Exception('failed to load audio list');
    }
  }

  static String idToFile(int id,List<AudioFile> audioFiles) {
    String result;
    for(int i = 0; i < audioFiles.length; i++) {
      if( id == audioFiles[i].id  ) {
        result = audioFiles[i].file;
      }
    }
    return result;
  }

  static int maxId(List<AudioFile> audioFiles){
    int result = 0;
    for(int i = 0; i < audioFiles.length; i++) {
      if(result < audioFiles[i].id){
        result = audioFiles[i].id;
      }
    }
    return result;
  }
  static int minId(List<AudioFile> audioFiles){
    int result = audioFiles[0].id;
    for(int i = 0; i < audioFiles.length; i++) {
      if(result > audioFiles[i].id){
        result = audioFiles[i].id;
      }
    }
    return result;
  }
}
