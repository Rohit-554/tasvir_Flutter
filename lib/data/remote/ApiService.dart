import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:tasvir/models/remote/CuratedImages.dart';
import 'package:tasvir/models/remote/videos/Videos.dart';

class ApiService {
  static const String _baseUrl = 'https://api.pexels.com/v1/';
  static const String _curated = '/curated';
  static const String _apiKey = '563492ad6f917000010000014e8100909e4648dd90cd22be75af650b';
  late final Dio dio;

  static const String _videosBaseUrl = 'https://api.pexels.com/';
  static const String _videos = '/videos/popular';

  // ApiService() {
  //   dio = Dio();
  //   dio.options.headers["Authorization"] = "Bearer $_apiKey";
  // }

  Future<CuratedImages> getImages(int page) async {
    try{
      dio = Dio();
      dio.options.headers["Authorization"] = "$_apiKey";
      final Response response = await dio.get('$_baseUrl$_curated?page=$page');
      print("response $response");
      CuratedImages curatedImages = CuratedImages.fromJson(response.data);
      return curatedImages;
    }on DioException catch(e){
      if (kDebugMode) {
        print("Error $e");
      }
      rethrow;
    }
  }

  Future<Videos> getVideos(int page) async{
    try{
      dio = Dio();
      dio.options.headers["Authorization"] = "$_apiKey";
      final Response response = await dio.get('$_videosBaseUrl$_videos?page=$page');
      print("response $response");
      Videos videos = Videos.fromJson(response.data);
      return videos;
    }on DioException catch(e){
      if (kDebugMode) {
        print("Error $e");
      }
      rethrow;
    }
  }
}