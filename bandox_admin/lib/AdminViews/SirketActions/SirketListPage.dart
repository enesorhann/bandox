import 'package:admin_paneli/AdminViews/SirketActions/BottomSheetDef.dart';
import 'package:admin_paneli/AdminViews/SirketActions/SirketKayitPage.dart';
import 'package:admin_paneli/AdminViews/SirketActions/SirketUpdatePage.dart';
import 'package:admin_paneli/data/cubit/yonetici_cubit/yoneticiList_cubit.dart';
import 'package:admin_paneli/data/entities/SirketYoneticileri/SirketYoneticileri.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class SirketListPage extends StatefulWidget {
  const SirketListPage({super.key});


  @override
  State<SirketListPage> createState() => _SirketListPageState();
}

class _SirketListPageState extends State<SirketListPage> {


  @override
  void initState() {
    context.read<YoneticiListCubit>().managerListAll();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          const SizedBox(height: 25,),
          Expanded(
            child: BlocBuilder<YoneticiListCubit,List<Yoneticiler>>(
              builder: (context, sirketListesi) {
                if (sirketListesi.isNotEmpty) {
                  return ListView.builder(
                    itemCount: sirketListesi.length,
                    itemBuilder: (context, index) {
                      var sirket = sirketListesi[index];
                      return GestureDetector(
                        onTap: () {
                          BottomSheetDef().showBottomSheet(context, 1,yonetici: sirket);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: Card(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Sirket adi: ${sirket.sirket_ad}",
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                Text(
                                  "Yonetici: ${sirket.yonetici_fName} ${sirket.yonetici_lName}",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                                Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                sirket.yonetici_mail,
                                style: Theme.of(context).textTheme.titleMedium,
                              )
                              ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return const Center();
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 20.0,
        onPressed: () {
          BottomSheetDef().showBottomSheet(context, 0);
        },
        tooltip: "ADD",
        child: const Icon(Icons.add,size: 33,),
      ),
    );

  }
}
