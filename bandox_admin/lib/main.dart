import 'package:admin_paneli/AdminViews/SirketActions/SirketListPage.dart';
import 'package:admin_paneli/data/cubit/yonetici_cubit/MailKayitCubit.dart';
import 'package:admin_paneli/data/cubit/yonetici_cubit/yoneticiDetay_cubit.dart';
import 'package:admin_paneli/data/cubit/yonetici_cubit/yoneticiKayit_cubit.dart';
import 'package:admin_paneli/data/cubit/yonetici_cubit/yoneticiList_cubit.dart';
import 'package:admin_paneli/firebase_options.dart';
import 'package:dep_manager_panel/data/cubit/department_cubit/depList_cubit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_panel/theme/AppTheme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => YoneticiKayitCubit()),
        BlocProvider(create: (context) => YoneticiDetayCubit()),
        BlocProvider(create: (context) => YoneticiListCubit()),
        BlocProvider(create: (context) => MailKayitCubit()),
        BlocProvider(create: (context) => DepListCubit()),
      ],
      child: MaterialApp(
        title: 'Bandox Admin',
        debugShowCheckedModeBanner: false,
        theme: appTheme,
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
            ElevatedButton(

            onPressed: (){
      Navigator.pushReplacement(context,
      MaterialPageRoute(builder: (context) => const SirketListPage()));
      },
        child: const Text("Sirketleri Gor"
        ),
      ),
    ]
    ,
    )
    ,
    )
    ,

    );
  }
}
