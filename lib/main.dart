import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_app/screens/home_screen/home_screen.dart';
import 'package:media_app/shared/cubit/app_cubit/app_cubit.dart';
import 'package:media_app/shared/network/local/db_helper/dp_helper.dart';
import 'package:media_app/shared/network/remote/dio_helper/dio_helper.dart';
import 'package:media_app/shared/style/colors/colors.dart';
import 'package:media_app/shared/style/swatch/primary_swatch.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  DioHelper.init();
  MyDatabase.initializeDatabase().then((value){}).catchError((error){});
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()..getFavourite(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Pixels App',
        theme: ThemeData(
          scaffoldBackgroundColor: AppColors.kScaffoldBackgroundColor,
          primaryColor: AppColors.kPrimaryColor,
          primarySwatch: Palette.kPrimarySwatch,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}