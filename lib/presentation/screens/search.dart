import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallpaper_app/presentation/cubit/app_cubit.dart';
import 'package:wallpaper_app/presentation/cubit/app_states.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController controller = TextEditingController();

  ScrollController scrollController = ScrollController();

  late AppCubit cubit;

  int page = 1;

  @override
  void initState() {
    cubit = AppCubit.get(context);
    handleNext();
    super.initState();
  }

  void handleNext() {
    scrollController.addListener(() async {
      if (scrollController.position.maxScrollExtent ==
              scrollController.position.pixels &&
          cubit.state is! SearchLoadingState) {
        page++;
        AppCubit.get(context).searchPhoto(search: controller.text,page: page);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: ((context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Search'),
            ),
            body: Column(
              children: [
                TextFormField(
                  controller: controller,
                  onFieldSubmitted: (value) =>
                      AppCubit.get(context).searchPhoto(search: value,page: 1),
                ),
                ConditionalBuilder(
                  condition: AppCubit.get(context).searchList.isNotEmpty,
                  fallback: (context) => const CircularProgressIndicator(),
                  builder: (context) => Flexible(
                    child: GridView.builder(
                      controller: scrollController,
                            itemCount: AppCubit.get(context).searchList.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2),
                            itemBuilder: (context, index) {
                              return Image.network(
                                  AppCubit.get(context)
                                      .searchList[index]
                                      .src!
                                      .small!,
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                );
                              });
                            })
                  ),
                ),
                if (state is SearchLoadingState)
                  const CircularProgressIndicator()
              ],
            ),
          );
        }));
  }
}
