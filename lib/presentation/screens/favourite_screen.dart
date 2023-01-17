import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallpaper_app/presentation/cubit/app_cubit.dart';
import 'package:wallpaper_app/presentation/cubit/app_states.dart';

class FavouriteScreen extends StatelessWidget {
  const FavouriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit,AppStates>(builder: (context, state) {
      return Scaffold(
          body: GridView.builder(
        itemCount: AppCubit.get(context).favouriteList.length,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,),
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.only(top: 8.0,right: 5,left: 5),
          child: InkWell(
            onTap: () => AppCubit.get(context)
                .deleteDataFromList(AppCubit.get(context).favouriteList[index]),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Image.network(
                    AppCubit.get(context).favouriteList[index],
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ],
            ),
          ),
        ),
      ));
    });
  }
}
