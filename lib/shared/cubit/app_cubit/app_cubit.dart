import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_app/models/video_model/video_model.dart';
import 'package:media_app/shared/constants/constants.dart';
import 'package:media_app/shared/network/local/db_helper/dp_helper.dart';
import 'package:media_app/shared/network/remote/dio_helper/dio_helper.dart';
import 'package:media_app/shared/network/remote/end_points/end_points.dart';
import 'package:meta/meta.dart';
import 'package:path_provider/path_provider.dart';

import '../../../models/favourite_model/favourite_model.dart';
import '../../../models/image_model/image_model.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppInitial());
  static AppCubit get(context) => BlocProvider.of(context);

  List<ImageModel> images = [];
  List<VideoModel> videos = [];

  Map<int,bool> favouriteMap = {};
  List<FavouriteModel> favourites = [];

  void getImages({
    required String text,
  }) {
    images = [];
    emit(GetImagesLoading());
    DioHelper.getData(url: PHOTO_SEARCH, token: API_KEY, query: {
      'query': text,
    }).then((value) {
      if (value.statusCode == 200) {
        value.data['photos'].forEach((element) {
          var image = ImageModel.fromJson(element);
          images.add(image);
        });
        emit(GetImagesSuccessfully());
      } else {
        if (kDebugMode) {
          print(value.data);
        }
        emit(GetImagesError());
      }
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(GetImagesError());
    });
  }

  void getVideos({
    required String text,
  }) {
    videos = [];
    emit(GetVideosLoading());
    DioHelper.getData(url: VIDEO_SEARCH, token: API_KEY, query: {
      'query': text,
    }).then((value) {
      if (value.statusCode == 200) {
        value.data['videos'].forEach((element) {
          var video = VideoModel.fromJson(element);
          videos.add(video);
        });
        emit(GetVideosSuccessfully());
      } else {
        if (kDebugMode) {
          print(value.data);
        }
        emit(GetVideosError());
      }
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(GetVideosError());
    });
  }

  void changeFavourite({
  required int mediaId,
  required ProgressCallback fn,
    ImageModel? imageModel,
  VideoModel? videoModel,
}){
    emit(ChangeFavourite());
    if(favouriteMap[mediaId] == null){
      favouriteMap[mediaId] = true;
    }
    else{
      favouriteMap[mediaId] = !favouriteMap[mediaId]!;
    }
    if(favouriteMap[mediaId]!){
      getApplicationDocumentsDirectory().then((value){
        if(imageModel != null) {
          DioHelper.download(
              directory: value.path,
              file: imageModel.id.toString(),
              extension: "png",
              url: imageModel.originalUrl,
            fn: fn,
          ).then((response){
            MyDatabase.insertToDatabase(
              id: imageModel.id,
              title: imageModel.alt,
              path: "${value.path}/${imageModel.id}.png",
              type: "image",
            ).then((value){
              if(value != 0){
                emit(ChangeSuccessfully());
              }
              else{
                favouriteMap[mediaId] = !favouriteMap[mediaId]!;
                if (kDebugMode) {
                  print("Insertion Error");
                }
                emit(ChangeError());
              }
            }).catchError((error){
              if(kDebugMode){
                print(error.toString());
              }
              favouriteMap[mediaId] = !favouriteMap[mediaId]!;
              emit(ChangeError());
            });
          }).catchError((error){
            if(kDebugMode){
              print(error.toString());
            }
            emit(ChangeError());
          });

        }
        else{
          DioHelper.download(
              directory: value.path,
              file: videoModel!.id.toString(),
              extension: "mp4",
              url: videoModel.url,
              fn:fn,

          ).then((response){
            DioHelper.download(
                directory: value.path,
                file: "${videoModel.id}_thumbnail",
                extension: "png",
                url: videoModel.thumbnail,
                  fn: fn,
            ).then((response2) {
              MyDatabase.insertToDatabase(
                id: videoModel.id,
                title: videoModel.userName,
                path: "${value.path}/${videoModel.id}.mp4",
                type: "video",
                thumbnail: "${value.path}/${videoModel.id}_thumbnail.png",
              ).then((value){
                if(value != 0) {
                  emit(ChangeSuccessfully());
                }
                else{
                  favouriteMap[mediaId] = !favouriteMap[mediaId]!;
                  emit(ChangeError());
                }
              }).catchError((error){
                if(kDebugMode){
                  print(error.toString());
                }
                emit(ChangeError());
              });
            }).catchError((error){
              if(kDebugMode){
                print(error.toString());
              }
              emit(ChangeError());
            });
          }).catchError((error){
            if(kDebugMode){
              print(error.toString());
            }
            emit(ChangeError());
          });

        }
      });

    }
    else{
      getApplicationDocumentsDirectory().then((value){
        if(imageModel != null){
          File("${value.path}/${imageModel.id}.png").delete().then((value) {
            MyDatabase.deleteRowFromDatabase(id: mediaId).then((value) {
              if(value == 1){
                getFavourite();
                emit(ChangeSuccessfully());
              }
            }).catchError((error){
              if(kDebugMode){
                print(error.toString());
              }
              favouriteMap[mediaId] = !favouriteMap[mediaId]!;
              emit(ChangeError());
            });
          }).catchError((error){
            if(kDebugMode){
              print(error.toString());
            }
            favouriteMap[mediaId] = !favouriteMap[mediaId]!;
            emit(ChangeError());
          });
        }
        else{
          File("${value.path}/${videoModel!.id}.mp4").delete().then((value) {
            MyDatabase.deleteRowFromDatabase(id: mediaId).then((value) {
              if(value == 1){
                getFavourite();
                emit(ChangeSuccessfully());
              }
            }).catchError((error){
              favouriteMap[mediaId] = !favouriteMap[mediaId]!;
              emit(ChangeError());
            });
          }).catchError((error){
            favouriteMap[mediaId] = !favouriteMap[mediaId]!;
            emit(ChangeError());
          });
        }
      }).catchError((error){
        favouriteMap[mediaId] = !favouriteMap[mediaId]!;
        emit(ChangeError());
      });
    }

  }

  void getFavourite(){
    favourites = [];
    emit(GetFavouriteLoading());
    MyDatabase.getAllImages().then((images) {
      for (var element in images) {
        favourites.add(FavouriteModel.fromJson(element));
        favouriteMap[element['id']] = true;
      }
      MyDatabase.getAllVideos().then((videos){
        for (var element in videos) {
          FavouriteModel fav = FavouriteModel.fromJson(element);
          favourites.add(fav);
        }
        emit(GetFavouriteSuccessfully());
      }).catchError((error){
        emit(GetFavouriteError());
      });
    }).catchError((error){
      emit(GetFavouriteError());
    });


  }


}
