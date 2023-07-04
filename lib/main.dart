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
    _initSharedPreferences();

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
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
          body: SizedBox(
        width: double.infinity,
        child: SizedBox(
            width: SizeConfig.blockSizeHorizontal * 96,
            child: Container(
              margin: EdgeInsets.fromLTRB(20, 40, 20, 20),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
              ),
              child: Column(
                children: <Widget>[
                  SpaceBox.height(SizeConfig.blockSizeVertical * 6),
                  Image.asset('images/title.png',
                      height: SizeConfig.blockSizeVertical * 47,
                      width: SizeConfig.blockSizeHorizontal * 25),
                  SpaceBox.height(SizeConfig.blockSizeVertical * 2),
                  Container(
                    margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Divider(color: Colors.black),
                  ),
                  SizedBox(
                    height: SizeConfig.blockSizeVertical * 7, // Widgetの高さを指定
                    width: SizeConfig.blockSizeHorizontal * 72, // Widgetの幅を指定
                    child: TextButton(
                      child: const Text(
                        'ゲームを始める',
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    SetPlayersPage(const [])));
                      },
                    ),
                  ),
                  SpaceBox.height(SizeConfig.blockSizeVertical * 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height:
                            SizeConfig.blockSizeVertical * 7, // Widgetの高さを指定
                        width:
                            SizeConfig.blockSizeHorizontal * 33, // Widgetの幅を指定
                        child: OutlinedButton(
                          child: const Text(
                            '遊び方',
                            style: TextStyle(fontSize: 18),
                          ),
                          onPressed: () async {},
                        ),
                      ),
                      SpaceBox.width(SizeConfig.blockSizeHorizontal * 6),
                      SizedBox(
                        height:
                            SizeConfig.blockSizeVertical * 7, // Widgetの高さを指定
                        width:
                            SizeConfig.blockSizeHorizontal * 33, // Widgetの幅を指定
                        child: OutlinedButton(
                          child: const Text(
                            '他のゲーム',
                            style: TextStyle(fontSize: 18),
                          ),
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Divider(color: Colors.black),
                  ),
                  SpaceBox.height(SizeConfig.blockSizeVertical * 5),
                ],
              ),
            )),
      )),
    );
  }
}
