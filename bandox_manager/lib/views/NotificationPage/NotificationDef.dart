
/*class NotificationDef extends StatefulWidget {
  const NotificationDef({super.key});

  @override
  State<NotificationDef> createState() => _NotificationDefState();
}

class _NotificationDefState extends State<NotificationDef> {

  var flp = FlutterLocalNotificationsPlugin();
  var baslik = "Yuz Tarama Sonucu";
  var icerik = "Yuz Hatali";

  @override
  void initState() {
    kurulum();
    super.initState();
  }

  Future<void> kurulum() async{
    var androidSetting = const AndroidInitializationSettings("@mipmap/ic_launcher");
    var iosSettings = const DarwinInitializationSettings();
    var settings = InitializationSettings(android: androidSetting,iOS: iosSettings);
    await flp.initialize(settings,onDidReceiveNotificationResponse: bildirimOlusturma);


  }

  Future<void> bildirimOlusturma(NotificationResponse response) async{
    var payload = response.payload;
    if(payload != null){
      print("Bildirim Secildi -> ${payload}");
    }
  }

  Future<void> bildirimGoster() async{
    var androidDetails = const AndroidNotificationDetails(
      "kanal-id",
      "kanal-adi",
      channelDescription: "my description",
      priority: Priority.high,
      importance: Importance.max,
    );
    var iosDetails = const DarwinNotificationDetails();
    var details = NotificationDetails(android: androidDetails,iOS: iosDetails);
    await flp.show(0, baslik, icerik, details,payload: "Payload Icerik");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Bildirim Sayfasi"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: (){
              bildirimGoster();
            },
                child: const Text("Show Notification"),
            ),
          ],
        ),
      ),
    );
  }
}


 */