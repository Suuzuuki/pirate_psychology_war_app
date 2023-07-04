// パッケージ
import '/util/importer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(const MainApp());
}

// SharedPreferencesを初期化
_initSharedPreferences() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.clear();
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  // This widget is the home page of your application.
  final String title;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return WillPopScope(
      //Androidの戻るボタン無効化
      onWillPop: () async => false,
      child: Scaffold(
          body: Container(
        width: double.infinity,
        child: //Row(
            //children: [
            Container(child: Text("a")),
      )),
    );
  }
}
