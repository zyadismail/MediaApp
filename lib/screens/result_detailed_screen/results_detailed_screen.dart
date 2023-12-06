import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_app/models/image_model/image_model.dart';
import 'package:media_app/models/video_model/video_model.dart';
import 'package:media_app/shared/cubit/app_cubit/app_cubit.dart';
import 'package:media_app/shared/widgets/adaptive_widgets/loading_widget/loading_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:appinio_video_player/appinio_video_player.dart';

class ResultsDetailedScreen extends StatefulWidget {
  final ImageModel? image;
  final VideoModel? videoModel;
  const ResultsDetailedScreen({Key? key, this.image, this.videoModel})
      : super(key: key);

  @override
  State<ResultsDetailedScreen> createState() => _ResultsDetailedScreenState();
}

class _ResultsDetailedScreenState extends State<ResultsDetailedScreen> {
  late VideoPlayerController videoPlayerController;
  late CustomVideoPlayerController _customVideoPlayerController;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    if (widget.videoModel != null) {
      setState(() {
        isLoading = true;
      });
      if (kDebugMode) {
        print(widget.videoModel!.url);
      }
      videoPlayerController =
          VideoPlayerController.networkUrl(Uri.parse(widget.videoModel!.url))
            ..initialize().then((value) => setState(() {
                  isLoading = false;
                }));
      _customVideoPlayerController = CustomVideoPlayerController(
        context: context,
        videoPlayerController: videoPlayerController,
      );
    }
  }

  @override
  void dispose() {
    _customVideoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.image != null) {
      return BlocConsumer<AppCubit, AppState>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = AppCubit.get(context);
          return Scaffold(
            body: SafeArea(
              child: Stack(
                children: [
                  Image.network(
                    widget.image!.originalUrl,
                    height: MediaQuery.of(context).size.height,
                    fit: BoxFit.cover,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
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
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                          colors: [
                            Colors.black45,
                            Colors.black26,
                            Colors.black12,
                            Colors.transparent,
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {
                                cubit.changeFavourite(
                                  mediaId: widget.image!.id,
                                  fn: (rec, total) {
                                    print("Rec: $rec, Total:$total");
                                    setState(() {
                                      //just to save completion in percentage
                                      String progressString =
                                          ((rec / total) * 100)
                                                  .toStringAsFixed(0) +
                                              "%";
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                                  'reciving $progressString')));
                                    });
                                  },
                                  imageModel: widget.image,
                                );
                              },
                              child: Container(
                                width: 50.0,
                                height: 50.0,
                                decoration: BoxDecoration(
                                  color: cubit.favouriteMap[widget.image!.id] !=
                                          null
                                      ? cubit.favouriteMap[widget.image!.id]!
                                          ? Colors.red
                                          : Colors.white24
                                      : Colors.white24,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.save_alt,
                                  color: cubit.favouriteMap[widget.image!.id] !=
                                          null
                                      ? cubit.favouriteMap[widget.image!.id]!
                                          ? Colors.white
                                          : Colors.blueGrey
                                      : Colors.blueGrey,
                                  size: 32.0,
                                ),
                              ),
                            )
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () {
                                Uri url = Uri.parse(
                                    widget.image!.photographerProfile);
                                launchUrl(url).then((value) {
                                  if (!value) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Cannot launch photographer profile'),
                                      ),
                                    );
                                  }
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14.0, vertical: 8.0),
                                  child: Text(
                                    widget.image!.photographerName,
                                    style: const TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            Center(
                              child: Text(
                                widget.image!.alt,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14.0),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    } else {
      return BlocConsumer<AppCubit, AppState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          var cubit = AppCubit.get(context);
          return Scaffold(
            body: SafeArea(
              child: isLoading
                  ? const Center(
                      child: LoadingWidget(),
                    )
                  : Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Center(
                            child: Container(
                              height: MediaQuery.of(context).size.height / 2,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16.0),
                                child: CustomVideoPlayer(
                                  customVideoPlayerController:
                                      _customVideoPlayerController,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      cubit.changeFavourite(
                                        mediaId: widget.videoModel!.id,
                                        videoModel: widget.videoModel,
                                        fn: (rec, total) {
                                         /* setState(() {
                                            //just to save completion in percentage
                                            if (rec == total) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                      "downloaded Successfully"),
                                                ),
                                              );
                                            }
                                            String  progressString = ((rec/total)*100).toStringAsFixed(0)+"%";
                                            if(int.parse(((rec/total)*100).toStringAsFixed(0)) % 25 == 0 && rec!=total){
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                      "$progressString downloaded"),
                                                ),
                                              );
                                            }
                                          });*/
                                          if(rec != total) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: StatefulBuilder(
                                                  builder: (context, setState) {
                                                    String progressString = "${((rec /
                                                        total) * 100)
                                                        .toStringAsFixed(0)}%";
                                                    setState(() {});
                                                    return Text(
                                                        "$progressString downloaded"
                                                    );
                                                  },
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                      );
                                    },
                                    child: Container(
                                      width: 50.0,
                                      height: 50.0,
                                      decoration: BoxDecoration(
                                        color: cubit.favouriteMap[
                                                    widget.videoModel!.id] !=
                                                null
                                            ? cubit.favouriteMap[
                                                    widget.videoModel!.id]!
                                                ? Colors.red
                                                : Colors.white24
                                            : Colors.white24,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.save_alt,
                                        color: cubit.favouriteMap[
                                                    widget.videoModel!.id] !=
                                                null
                                            ? cubit.favouriteMap[
                                                    widget.videoModel!.id]!
                                                ? Colors.white
                                                : Colors.blueGrey
                                            : Colors.blueGrey,
                                        size: 32.0,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Uri url = Uri.parse(
                                          widget.videoModel!.userProfile);
                                      launchUrl(url).then((value) {
                                        if (!value) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                  'Cannot launch photographer profile'),
                                            ),
                                          );
                                        }
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 14.0, vertical: 8.0),
                                        child: Text(
                                          widget.videoModel!.userName,
                                          style: const TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
            ),
          );
        },
      );
    }
  }
}
