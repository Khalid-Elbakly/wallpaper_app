abstract class AppStates{}

class InitialState extends AppStates{}

class LoadingGetWallpaper extends AppStates{}

class SuccessGetWallpaper extends AppStates{}

class ErrorGetWallpaper extends AppStates{
  dynamic data;
  ErrorGetWallpaper(this.data);
}
