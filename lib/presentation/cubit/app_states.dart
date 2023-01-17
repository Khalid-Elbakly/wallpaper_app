abstract class AppStates {}

class InitialState extends AppStates {}

class LoadingGetWallpaper extends AppStates {}

class SuccessGetWallpaper extends AppStates {}

class ErrorGetWallpaper extends AppStates {
  dynamic data;
  ErrorGetWallpaper(this.data);
}

class PutDataState extends AppStates {}

class DeleteDataState extends AppStates {}

class ChangeBottomNavState extends AppStates {}

class SearchSuccessState extends AppStates {}

class SearchLoadingState extends AppStates{}
