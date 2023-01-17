import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallpaper_app/data/local/cache_helper.dart';
import 'package:wallpaper_app/data/remote/dio_helper.dart';
import 'package:wallpaper_app/domain/model/wallpaper_model.dart';
import 'package:wallpaper_app/presentation/cubit/app_states.dart';
import 'package:wallpaper_app/presentation/screens/favourite_screen.dart';
import 'package:wallpaper_app/presentation/screens/home_screen.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(InitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentPage = 0;

  changeScreen(index) {
    currentPage = index;
    emit(ChangeBottomNavState());
  }

  List pageList = [
    const Home(),
    const FavouriteScreen(),
  ];

  WallpaperModel? model;

  List<WallpaperModel?> wallpaperList = [];

  Future getWallpaper(int page) async {
    emit(LoadingGetWallpaper());
    try {
      List data = await DioHelper.getData(page: page);
      data.shuffle();
      for (var element in data) {
        model = WallpaperModel.fromJson(element);
        wallpaperList.add(model);
      }
      emit(SuccessGetWallpaper());
    } on DioError catch (error) {
      error.toString();
      emit(ErrorGetWallpaper(error.response!.data['error']));
    }
  }

  List favouriteList = [];

  void putDataToList(value) {
    favouriteList.add(value);
    CacheHelper.putData('favList', favouriteList);
    emit(PutDataState());
  }

  void deleteDataFromList(value) {
    favouriteList.remove(value);
    CacheHelper.putData('favList', favouriteList);
    emit(DeleteDataState());
  }

  getData(var name) {
    favouriteList = CacheHelper.getData(name);
  }

  clearData() {
    CacheHelper.clearData();
    favouriteList = [];
  }

  WallpaperModel? searchModel;

  List<WallpaperModel> searchList = [];

  searchPhoto({search, page}) async {
    emit(SearchLoadingState());
    if(page == 1) {
      searchList = [];
    }
    List data = await DioHelper.search(search, page);
    if (data.isEmpty) {
      data = [
        {
          "id": 10161802,
          "width": 4896,
          "height": 3264,
          "url":
              "https://www.pexels.com/photo/blue-and-white-balloons-on-white-surface-10161802/",
          "photographer": "Dosio Dosev",
          "photographer_url": "https://www.pexels.com/@dosio-dosev-710786",
          "photographer_id": 710786,
          "avg_color": "#BBBCC1",
          "src": {
            "original":
                "https://images.pexels.com/photos/10161802/pexels-photo-10161802.jpeg",
            "large2x":
                "https://images.pexels.com/photos/10161802/pexels-photo-10161802.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
            "large":
                "https://images.pexels.com/photos/10161802/pexels-photo-10161802.jpeg?auto=compress&cs=tinysrgb&h=650&w=940",
            "medium":
                "https://images.pexels.com/photos/10161802/pexels-photo-10161802.jpeg?auto=compress&cs=tinysrgb&h=350",
            "small": "https://wallpaper.dog/large/5543069.jpg",
            "portrait":
                "https://images.pexels.com/photos/10161802/pexels-photo-10161802.jpeg?auto=compress&cs=tinysrgb&fit=crop&h=1200&w=800",
            "landscape":
                "https://images.pexels.com/photos/10161802/pexels-photo-10161802.jpeg?auto=compress&cs=tinysrgb&fit=crop&h=627&w=1200",
            "tiny":
                "https://images.pexels.com/photos/10161802/pexels-photo-10161802.jpeg?auto=compress&cs=tinysrgb&dpr=1&fit=crop&h=200&w=280"
          },
          "liked": false,
          "alt": "Blue and White Balloons on White Surface"
        }
      ];
    }
    for (var element in data) {
      searchModel = WallpaperModel.fromJson(element);
      searchList.add(searchModel!);
    }
    emit(SearchSuccessState());
  }
}
