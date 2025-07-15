import 'package:admin_paneli/data/cubit/yonetici_cubit/MailKayitCubit.dart';
import 'package:admin_paneli/data/cubit/yonetici_cubit/yoneticiDetay_cubit.dart';
import 'package:admin_paneli/data/cubit/yonetici_cubit/yoneticiList_cubit.dart';
import 'package:admin_paneli/data/entities/SirketYoneticileri/SirketYoneticileri.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SirketUpdatePage extends StatefulWidget {
  final Yoneticiler yonetici;

  const SirketUpdatePage(this.yonetici, {super.key});

  @override
  State<SirketUpdatePage> createState() => _SirketUpdatePageState();
}

class _SirketUpdatePageState extends State<SirketUpdatePage> {
  var fNameController = TextEditingController();
  var lNameController = TextEditingController();
  var sirketAdiController = TextEditingController();
  var yonetici_mailController = TextEditingController();

  @override
  void initState() {
    var sirket = widget.yonetici;
    fNameController.text = sirket.yonetici_fName;
    lNameController.text = sirket.yonetici_lName;
    sirketAdiController.text = sirket.sirket_ad;
    yonetici_mailController.text = sirket.yonetici_mail;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: const Icon(Icons.close)),
        actions: [
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  context
                      .read<YoneticiListCubit>()
                      .managerDelete(widget.yonetici.sirket_id);
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.delete,
                  size: 35,
                ),
              ),
            ],
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
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
                TextField(
                  controller: yonetici_mailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                      label: Text("Yonetici Mail",
                      ),

                  ),
                ),
              ],
            ),
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
          await context.read<YoneticiDetayCubit>().managerGuncelle(
                widget.yonetici.sirket_id,
                sirketAdiController.text,
                fNameController.text,
                lNameController.text,
                yonetici_mail,
              );
          Navigator.pop(context);
        },
        label: const Text(
          "Update",
        ),
        tooltip: "Update",
        icon: const Icon(
          Icons.update,
          size: 33,
        ),
      ),
    );
  }
}
