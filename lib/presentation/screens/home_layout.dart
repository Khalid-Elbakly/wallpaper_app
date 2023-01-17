import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallpaper_app/presentation/cubit/app_cubit.dart';
import 'package:wallpaper_app/presentation/cubit/app_states.dart';

class HomeLayout extends StatelessWidget {
  const HomeLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit,AppStates>(
      builder: (context, state) =>  Scaffold(
        body: AppCubit.get(context).pageList[AppCubit.get(context).currentPage],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: AppCubit.get(context).currentPage,
          onTap: (index) => AppCubit.get(context).changeScreen(index),
          items: const [
           BottomNavigationBarItem(icon: Icon(Icons.home),label: 'home'),
           BottomNavigationBarItem(icon: Icon(Icons.favorite_outline),label: 'favourite')
        ]),
      ),
    );
  }
}