import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_app/shared/cubit/app_cubit/app_cubit.dart';
import 'package:media_app/shared/widgets/adaptive_widgets/loading_widget/loading_widget.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({Key? key}) : super(key: key);

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()..getFavourite(),
      child: BlocConsumer<AppCubit, AppState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is GetFavouriteLoading) {
            return const Scaffold(
              body: Center(
                child: LoadingWidget(),
              ),
            );
          }
          var cubit = AppCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.arrow_back_ios_outlined,
                  color: Colors.black,
                ),
              ),
              title: const Text(
                'GALLERY',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
              elevation: 0.0,
              actions: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                  ),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red
                    ),
                    child: Center(
                      child: Text(
                        cubit.favourites.length.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            body: cubit.favourites.isNotEmpty ? GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 4 / 10,
                crossAxisSpacing: 1.5,
                mainAxisSpacing: 1.0,
              ),
              itemCount: cubit.favourites.length,
              itemBuilder: (context, index) {
                if (cubit.favourites[index].type == "image") {
                  return Image.file(
                    File(
                      cubit.favourites[index].url,
                    ),
                    fit: BoxFit.cover,
                  );
                }
                else {
                  return Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                          image: FileImage(
                              File(
                                cubit.favourites[index].thumbnail!,
                              )
                          ),
                          fit: BoxFit.cover,
                        )
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                            color: Colors.black45,
                            shape: BoxShape.circle
                        ),
                        child: const Icon(
                          Icons.play_arrow_outlined,
                          color: Colors.white,
                          size: 50.0,
                        ),
                      ),
                    ),
                  );
                }
              },
            ) : const Center(
              child: Text(
                'You Doesn\'t have any favourites yet!',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold
                ),
                textAlign: TextAlign.center,
              ),
            ),
          );
        },
      ),
    );
  }


}
