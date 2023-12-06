import 'package:flutter/material.dart';

import '../colors/colors.dart';
class Palette {
  static MaterialColor kPrimarySwatch = MaterialColor(
    AppColors.kPrimaryColor.withOpacity(0.01).value, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    <int, Color>{
      50:  AppColors.kPrimaryColor.withOpacity(0.1),//10%
      100:  AppColors.kPrimaryColor.withOpacity(0.2),//20%
      200:  AppColors.kPrimaryColor.withOpacity(0.3),//30%
      300:  AppColors.kPrimaryColor.withOpacity(0.4),//40%
      400:  AppColors.kPrimaryColor.withOpacity(0.5),//50%
      500:  AppColors.kPrimaryColor.withOpacity(0.6),//60%
      600:  AppColors.kPrimaryColor.withOpacity(0.7),//70%
      700:  AppColors.kPrimaryColor.withOpacity(0.8),//80%
      800:  AppColors.kPrimaryColor.withOpacity(0.9),//90%
      900:  AppColors.kPrimaryColor,//100%
    },
  );
}