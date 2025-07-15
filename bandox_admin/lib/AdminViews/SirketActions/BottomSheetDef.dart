import 'package:admin_paneli/AdminViews/SirketActions/SirketKayitPage.dart';
import 'package:admin_paneli/AdminViews/SirketActions/SirketUpdatePage.dart';
import 'package:admin_paneli/data/entities/SirketYoneticileri/SirketYoneticileri.dart';
import 'package:flutter/material.dart';

class BottomSheetDef {


  final _curve = Curves.easeInOut;
  final _duration = const Duration(milliseconds: 500);

  void showBottomSheet(BuildContext context,int toPage, {Yoneticiler? yonetici}){
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape:  const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10))
      ),
      sheetAnimationStyle: AnimationStyle(curve: _curve,duration: _duration,
      reverseCurve: _curve,reverseDuration: _duration
      ),
      builder: (context) {
      return DraggableScrollableSheet(
        expand: false,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        initialChildSize: 0.9,
        builder: (context, scrollController) {
        return (toPage == 0) ? const SirketKayitPage() : SirketUpdatePage(yonetici!);
      },);
    },
    );
  }

}