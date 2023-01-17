import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallpaper_app/presentation/cubit/app_cubit.dart';
import 'package:wallpaper_app/presentation/cubit/app_states.dart';
import 'package:wallpaper_app/presentation/screens/photo_details.dart';
import 'package:wallpaper_app/presentation/screens/search.dart';

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
          cubit.state is! LoadingGetWallpaper &&
          mounted) {
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
            appBar: AppBar(
              title: const Text('Wallpapers'),
              actions: [
                IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SearchScreen()));
                    },
                    icon: const Icon(Icons.search))
              ],
            ),
            body: (AppCubit.get(context).wallpaperList.isNotEmpty)
                ? Container(
                    color: const Color.fromARGB(255, 144, 185, 255),
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 10, left: 5, right: 5),
                      child: Column(
                        children: [
                          Expanded(
                            child: GridView.builder(
                              controller: scrollController,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10,
                                      crossAxisCount: 2),
                              itemCount:
                                  AppCubit.get(context).wallpaperList.length,
                              itemBuilder: (context, index) => InkWell(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PhotoDetails(
                                          model: cubit.wallpaperList[index]!),
                                    )),
                                child: Image.network(
                                  AppCubit.get(context)
                                      .wallpaperList[index]!
                                      .src!
                                      .medium!,
                                  fit: BoxFit.fitWidth,
                                ),
                              ),
                            ),
                          ),
                          if (state is LoadingGetWallpaper)
                            const CircularProgressIndicator()
                        ],
                      ),
                    ),
                  )
                : const Center(child: CircularProgressIndicator())));
  }
}
