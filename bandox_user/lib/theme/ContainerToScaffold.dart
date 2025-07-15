import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:user_panel/theme/AppColors.dart';

Decoration customDecoration(){
  return BoxDecoration(
      gradient: LinearGradient(colors: [
        AppColors.primary.withValues(alpha: 1.0).withBlue(200).withRed(100),
        AppColors.primary.withValues(alpha: 2.4)
      ],begin: Alignment.topLeft,end: Alignment.bottomRight
      ),
    );
}