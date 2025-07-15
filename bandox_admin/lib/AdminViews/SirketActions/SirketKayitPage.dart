import 'package:admin_paneli/data/cubit/yonetici_cubit/yoneticiKayit_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/cubit/yonetici_cubit/MailKayitCubit.dart';

class SirketKayitPage extends StatefulWidget {
  const SirketKayitPage({super.key});

  @override
  State<SirketKayitPage> createState() => _SirketKayitPageState();
}

class _SirketKayitPageState extends State<SirketKayitPage> {
  var fNameController = TextEditingController();
  var lNameController = TextEditingController();
  var sirketAdiController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: const Icon(Icons.close)),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(28.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextField(
                controller: fNameController,
                decoration: const InputDecoration(
                    label: Text(
                      "Manager First Name",
                    ),
                ),
              ),
              TextField(
                controller: lNameController,
                decoration: const InputDecoration(
                    label: Text("Manager Last Name",
                    ),
                ),
              ),
              TextField(
                controller: sirketAdiController,
                decoration: const InputDecoration(
                    label: Text("Sirket Adi",
                    ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        elevation: 20.0,
        onPressed: () async {
          var sirketAd =
              sirketAdiController.text.toLowerCase().trim().replaceAll(" ", "");
          var fName = fNameController.text.toLowerCase().trim();
          var lName = lNameController.text.toLowerCase().trim();
          await context
              .read<MailKayitCubit>()
              .mailOlustur(sirketAd, fName, lName);
          var yonetici_mail = context.read<MailKayitCubit>().state;
          await context.read<YoneticiKayitCubit>().managerEkle(
                sirketAdiController.text,
                fNameController.text,
                lNameController.text,
                yonetici_mail,
              );
          Navigator.pop(context);
        },
        label: const Text(
          "Save",
        ),
        tooltip: "Save",
        icon: const Icon(Icons.save, size: 33),
      ),
    );
  }
}
