import 'package:dio/dio.dart';

class DioHelper {
  static Dio? dio;

  static initDio() {
    dio = Dio(BaseOptions(baseUrl: 'https://api.pexels.com/'));
  }

  static Future getData(
  { required int page }
      ) async {
    Response response = await dio!.get('https://api.pexels.com/v1/curated?per_page=10&page=$page',
        options: Options(headers: {
          'Authorization':
              '563492ad6f91700001000001d7e424fe99a14449b8df580cc6f35efc'
        }));
    return response.data['photos'];
  }
}
