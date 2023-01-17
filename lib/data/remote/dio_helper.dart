import 'package:dio/dio.dart';
import 'package:wallpaper_app/domain/model/wallpaper_model.dart';

class DioHelper {
  static Dio? dio;

  static initDio() {
    dio = Dio(BaseOptions(baseUrl: 'https://api.pexels.com/'));
  }

  static Future getData({required int page}) async {
    Response response = await dio!.get(
        'https://api.pexels.com/v1/curated?per_page=10&page=$page',
        options: Options(headers: {
          'Authorization':
              '563492ad6f91700001000001d7e424fe99a14449b8df580cc6f35efc'
        }));
    return response.data['photos'];
  }

  static Future downloadData(WallpaperModel model) async {
    await dio!.download(
        model.src!.small!, '/storage/emulated/0/Download/${model.id}.jpeg');
  }

  static Future search(String search,int page) async {
    Response response = await dio!.get(
        "https://api.pexels.com/v1/search?query=$search&per_page=10&page=$page",
        options: Options(headers: {
          'Authorization' : '563492ad6f91700001000001d7e424fe99a14449b8df580cc6f35efc'
        }));
    return response.data['photos'];
  }
}
