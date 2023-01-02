import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallpaper_app/presentation/cubit/app_cubit.dart';
import 'package:wallpaper_app/presentation/cubit/app_states.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

ScrollController scrollController = ScrollController();

class _HomeState extends State<Home> {
  late AppCubit cubit;

  int page = 1;

  @override
  void initState() {
    cubit = AppCubit.get(context);
    cubit.getWallpaper(page);
    handleNext();
    super.initState();
  }

  void handleNext() {
    scrollController.addListener(() async {
      if (scrollController.position.maxScrollExtent ==
              scrollController.position.pixels &&
          cubit.state is! LoadingGetWallpaper) {
        page++;
        AppCubit.get(context).getWallpaper(page);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {
          if (state is ErrorGetWallpaper) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.data)));
          }
        },
        builder: (context, state) => Scaffold(
            body: (AppCubit.get(context).list.isNotEmpty)
                ? Column(
                    children: [
                      Expanded(
                        child: GridView.builder(
                          controller: scrollController,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                  crossAxisCount: 2),
                          itemCount: AppCubit.get(context).list.length,
                          itemBuilder: (context, index) => Center(
                            child: Image.network(
                              AppCubit.get(context).list[index]!.src!.medium!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      if (state is LoadingGetWallpaper)
                        CircularProgressIndicator()
                    ],
                  )
                : Center(child: CircularProgressIndicator())));
  }
}
