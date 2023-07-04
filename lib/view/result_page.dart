// パッケージ
import '/util/importer.dart';

// 広告読み込み許容上限
const int maxFailedLoadAttempts = 3;

/*
結果画面
*/
class ResultPage extends StatefulWidget {
  ResultPage(this.playerList, this.goalConditions);
  final List<Player> playerList;
  final bool goalConditions;

  @override
  _ResultPageState createState() =>
      _ResultPageState(this.playerList, this.goalConditions);
}

class _ResultPageState extends State<ResultPage> {
  _ResultPageState(this.playerList, this.goalConditions);
  List<Player> playerList;
  bool goalConditions;

  String infoMessage = '';

  // 今までの絵が保存されたリスト
  late List<String> imageList;

  // Shared Preferenceに値を保存されているデータを読み込んで値にセットする。
  _getPrefItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // 以下の「get〇〇()の中」がキー名。見つからなければ??の後ろを返す
    setState(() {
      imageList = prefs.getStringList('imageList') ?? <String>[];
    });
  }

  // 端末を判定し、広告IDを設定
  String getTestAdInterstitialUnitId() {
    String testBannerUnitId = "";
    if (Platform.isAndroid) {
      // Android のとき
      testBannerUnitId = "ca-app-pub-8405809605713115/8109007423";
    } else if (Platform.isIOS) {
      // iOSのとき
      testBannerUnitId = "ca-app-pub-8405809605713115/6188054118";
    }
    return testBannerUnitId;
  }

  // Shared Preferenceのデータをけす
  _deletePrefItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('themehistoryList');
  }

  @override
  void initState() {
    super.initState();
    _deletePrefItems();
    _getPrefItems();
    if (goalConditions) {
      playerList.sort((a, b) => b.goal.compareTo(a.goal));
    } else {
      playerList.sort((a, b) => b.score.compareTo(a.score));
    }
  }

  @override
  void dispose() {
    // 毎回処理される場所　なにかリソース開放等があれば。
    super.dispose();
  }

  // ランキング画像
  late Widget rankingImage;

  // ポイント
  late int point;

  // プレイヤーリストリセット
  void playerListReset() {
    // 結果順になったものを戻す
    playerList.sort((a, b) => a.player_order.compareTo(b.player_order));
    // 得点リセット
    playerList.forEach((player) {
      player.score = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return WillPopScope(
      //Androidの戻るボタン無効化
      onWillPop: () async => false,
      child: Scaffold(
          body: Container(
              width: double.infinity,
              child: Column(
                children: <Widget>[
                  SpaceBox(height: SizeConfig.blockSizeVertical * 5),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Column(children: <Widget>[
                          Container(
                            width: SizeConfig.blockSizeHorizontal * 27,
                            height: SizeConfig.blockSizeVertical * 1,
                            margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                            child: Divider(color: Colors.black),
                          ),
                          Container(
                            width: SizeConfig.blockSizeHorizontal * 27,
                            height: SizeConfig.blockSizeVertical * 1,
                            margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                            child: Divider(color: Colors.black),
                          ),
                        ]),
                        Text('結果発表',
                            style: TextStyle(
                              fontSize: 24,
                            )),
                        Column(children: <Widget>[
                          Container(
                            width: SizeConfig.blockSizeHorizontal * 27,
                            height: SizeConfig.blockSizeVertical * 1,
                            margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                            child: Divider(color: Colors.black),
                          ),
                          Container(
                            width: SizeConfig.blockSizeHorizontal * 27,
                            height: SizeConfig.blockSizeVertical * 1,
                            margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                            child: Divider(color: Colors.black),
                          ),
                        ]),
                      ]),
                  SpaceBox(
                    height: SizeConfig.blockSizeVertical * 5,
                  ),
                  Container(
                    width: SizeConfig.blockSizeHorizontal * 80,
                    height: SizeConfig.blockSizeVertical * 53,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 1.5),
                    ),
                    child: Column(children: <Widget>[
                      SpaceBox(height: SizeConfig.blockSizeVertical * 3),
                      Container(
                        height: SizeConfig.blockSizeVertical *
                            (playerList.length * 7),
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          // スクロールしないように設定
                          physics: const NeverScrollableScrollPhysics(),
                          // Listの数をプレイヤー数にする
                          itemCount: playerList.length,
                          //プレイヤー数分のWidgetを作る
                          itemBuilder: (BuildContext context, int index) {
                            return Row(children: <Widget>[
                              SpaceBox(
                                  width: SizeConfig.blockSizeHorizontal * 6),
                              branchRankingImage(index),
                              SpaceBox(
                                  width: SizeConfig.blockSizeHorizontal * 5),
                              Container(
                                  width: SizeConfig.blockSizeHorizontal * 45,
                                  child: Text(
                                    playerList[index].name,
                                    style: TextStyle(fontSize: 16),
                                  )),
                              Text('${playerList[index].goal}個',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  )),
                              Text('${playerList[index].score}pt',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  )),
                              SpaceBox(
                                  height: SizeConfig.blockSizeVertical * 7),
                            ]);
                          },
                        ),
                      ),
                    ]),
                  ),
                  SpaceBox(height: SizeConfig.blockSizeVertical * 5),
                  SizedBox(
                    height: SizeConfig.blockSizeVertical * 6, // Widgetの高さを指定
                    width: SizeConfig.blockSizeHorizontal * 75, // Widgetの幅を指定
                    child: TextButton(
                      child: const Text(
                        '同じ設定でもう一度',
                        style: TextStyle(fontSize: 20),
                      ),
                      onPressed: () {
                        playerListReset();
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) {
                              return SetPlayersPage(playerList);
                            },
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              final Offset begin = Offset(-1.0, 0.0); // 左から右
                              final Offset end = Offset.zero;
                              final Animatable<Offset> tween = Tween(
                                      begin: begin, end: end)
                                  .chain(CurveTween(curve: Curves.easeInOut));
                              final Animation<Offset> offsetAnimation =
                                  animation.drive(tween);
                              return SlideTransition(
                                position: offsetAnimation,
                                child: child,
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  SpaceBox(height: SizeConfig.blockSizeVertical * 3),
                  SizedBox(
                    height: SizeConfig.blockSizeVertical * 6, // Widgetの高さを指定
                    width: SizeConfig.blockSizeHorizontal * 75, // Widgetの幅を指定
                    child: TextButton(
                      child: const Text(
                        'タイトルに戻る',
                        style: TextStyle(fontSize: 20),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) {
                              return MyHomePage(
                                title: '',
                              );
                            },
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              final Offset begin = Offset(-1.0, 0.0); // 左から右
                              final Offset end = Offset.zero;
                              final Animatable<Offset> tween = Tween(
                                      begin: begin, end: end)
                                  .chain(CurveTween(curve: Curves.easeInOut));
                              final Animation<Offset> offsetAnimation =
                                  animation.drive(tween);
                              return SlideTransition(
                                position: offsetAnimation,
                                child: child,
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  SpaceBox(height: SizeConfig.blockSizeVertical * 3),
                ],
              ))),
    );
  }

  // 前の人の順位
  int previousPersonRank = 0;
  // 前の人の点数
  int previousPersonScore = 0;

  Widget branchRankingImage(int value) {
    if (playerList[value].score == previousPersonScore) {
      value = previousPersonRank;
    } else {
      previousPersonScore = playerList[value].score;
      previousPersonRank = value;
    }
    if (value == 0) {
      rankingImage = Image.asset('images/first.png',
          width: SizeConfig.blockSizeHorizontal * 7);
    } else if (value == 1) {
      rankingImage = Image.asset('images/second.png',
          width: SizeConfig.blockSizeHorizontal * 7);
    } else {
      rankingImage = Text('  ' + (value + 1).toString() + ' ',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold));
    }
    return rankingImage;
  }
}
