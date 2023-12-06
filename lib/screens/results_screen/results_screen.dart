import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_app/screens/result_detailed_screen/results_detailed_screen.dart';
import 'package:media_app/shared/cubit/app_cubit/app_cubit.dart';
import 'package:media_app/shared/style/colors/colors.dart';

class ResultsScreen extends StatelessWidget {
  final String query;
  final bool isFromImages;
  const ResultsScreen({Key? key, required this.query , required this.isFromImages}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme
            .of(context)
            .scaffoldBackgroundColor,
        title: Text(
          query.toUpperCase(),
          style: const TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: Colors.black
          ),
        ),
        centerTitle: true,
        elevation: 0.0,
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_outlined,
            color: Colors.black,
          ),
        ),
      ),
      body: BlocConsumer<AppCubit, AppState>(
        listener: (context, state) {},
        builder: (context, state) {
          if(state is GetImagesLoading || state is GetVideosLoading){
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.kPrimaryColor,
              ),
            );
          }

          var cubit = AppCubit.get(context);
          if(isFromImages) {
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 7 / 9,
              ),
              itemBuilder: (_, index) =>
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(
                          builder: (_)=>ResultsDetailedScreen(
                            image: cubit.images[index],
                          ),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: cubit.images[index].averageColor,
                                width: 5.0
                            )
                        ),
                        child: Image.network(
                          cubit.images[index].mediumUrl,
                          fit: BoxFit.cover,
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
                          },
                        ),
                      ),
                    ),
                  ),
              itemCount: cubit.images.length,
            );
          }else{
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 16 / 9,
              ),
              itemBuilder: (_, index) =>
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(
                          builder: (_)=>ResultsDetailedScreen(
                            videoModel: cubit.videos[index],
                          ),
                        ),
                        );
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.network(
                            cubit.videos[index].thumbnail,
                            fit: BoxFit.cover,
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
                            },
                          ),
                          Container(
                            width: 40,
                            height: 40,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black54
                            ),
                            child:  const Center(
                              child: Icon(
                                Icons.play_arrow_outlined,
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
              itemCount: cubit.videos.length,
            );

          }
        },
      ),
    );
  }
}
