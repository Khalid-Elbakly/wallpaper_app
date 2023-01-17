import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:wallpaper_app/data/local/cache_helper.dart';
import 'package:wallpaper_app/data/remote/dio_helper.dart';
import 'package:wallpaper_app/presentation/cubit/app_cubit.dart';
import 'package:wallpaper_app/presentation/screens/home_layout.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DioHelper.initDio();
  await Hive.initFlutter();
  await CacheHelper.initCache();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()..getData('favList'),
      child: const MaterialApp(
        home: HomeLayout(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
