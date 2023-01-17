import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallpaper_app/data/remote/dio_helper.dart';
import 'package:wallpaper_app/domain/model/wallpaper_model.dart';
import 'package:wallpaper_app/presentation/cubit/app_cubit.dart';
import 'package:wallpaper_app/presentation/cubit/app_states.dart';

class PhotoDetails extends StatelessWidget {
  const PhotoDetails({super.key, required this.model});

  final WallpaperModel model;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppStates>(
      builder: (context, state) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            Image.network(model.src!.original!,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                ),
              );
            }),
            const SizedBox(
              height: 10,
            ),
            Text(model.photographer!),
            ElevatedButton(
                onPressed: () {
                  DioHelper.downloadData(model);
                },
                child: const Text('Download')),
            IconButton(
                onPressed: () {
                  if (AppCubit.get(context)
                      .favouriteList
                      .contains(model.src!.medium)) {
                    AppCubit.get(context).deleteDataFromList(model.src!.medium);
                  } else {
                    AppCubit.get(context).putDataToList(model.src!.medium);
                  }
                },
                icon: (AppCubit.get(context)
                        .favouriteList
                        .contains(model.src!.medium))
                    ? const Icon(Icons.favorite)
                    : const Icon(Icons.favorite_outline)),
          ]),
        ),
      ),
    );
  }
}
