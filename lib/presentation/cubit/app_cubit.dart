import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallpaper_app/data/remote/dio_helper.dart';
import 'package:wallpaper_app/domain/model/wallpaper_model.dart';
import 'package:wallpaper_app/presentation/cubit/app_states.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(InitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  WallpaperModel? model;

  List<WallpaperModel?> list = [];

  Future getWallpaper(int page) async {
    emit(LoadingGetWallpaper());
    try {
      List data = await DioHelper.getData(page: page);
      data.forEach((element) {
        model = WallpaperModel.fromJson(element);
        list.add(model);
      });
      emit(SuccessGetWallpaper());
    } on DioError catch (error) {
      error.toString();
      emit(ErrorGetWallpaper(error.response!.data['error']));
    }
  }
}
