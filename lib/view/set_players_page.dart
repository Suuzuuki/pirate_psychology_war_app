// パッケージ
import '/util/importer.dart';

/*
プレイヤー設定
*/
class SetPlayersPage extends StatefulWidget {
  SetPlayersPage(this.players);
  final List<Player> players;
  @override
  _SetPlayersPageState createState() => _SetPlayersPageState(this.players);
}

class _SetPlayersPageState extends State<SetPlayersPage> {
  _SetPlayersPageState(this.players);
  List<Player> players;

  // 初期表示プレイヤー数
  int playerNum = 3;
  // プレイヤー名入力フォーム
  List<Item> items = [];
  // プレイヤー番号
  int num = 1;

  // 画面起動時処理
  @override
  void initState() {
    super.initState();

    // 初回と再設定の場合で処理を分ける
    if (players.isEmpty) {
      // 初回
      playerNum = 3;
      for (var i = 0; i < playerNum; i++) {
        add();
      }
    } else {
      // 再設定
      playerNum = players.length;
      int index = 1;
      // プレイヤー名が初期設定の場合、空白に戻す
      players.forEach((player) {
        if (player.name == 'プレイヤー${index.toString()}') {
          player.name = "";
        }
        index++;
        items.add(Item.takeOver(player.id, player.name));
      });
      players.clear();
    }
  }

  @override
  void dispose() {
    items.forEach((element) {
      element.dispose();
    });
    super.dispose();
  }

  void add() {
    setState(() {
      items.add(Item.create(""));
    });
  }

  void remove(int id) {
    final removedItem = items.firstWhere((element) => element.id == id);
    setState(() {
      items.removeWhere((element) => element.id == id);
    });
    // itemのcontrollerをすぐdisposeすると怒られるので少し時間をおいてからdipose()
    Future.delayed(Duration(seconds: 1)).then((value) {
      removedItem.dispose();
    });
  }

  List _orderSetShuffle(List players) {
    // シャッフル前のプレイヤー登録順をセット
    int orderNum = 0;
    players.forEach((player) {
      player.player_order = orderNum++;
    });

    // 順番をシャッフル
    var random = new Random();
    for (var i = players.length - 1; i > 0; i--) {
      var n = random.nextInt(i + 1);
      var temp = players[i];
      players[i] = players[n];
      players[n] = temp;
    }

    // シャッフル後のペイント順をセット
    orderNum = 0;
    players.forEach((player) {
      player.paint_order = orderNum++;
    });
    return players;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return WillPopScope(
      //Androidの戻るボタン無効化
      onWillPop: () async => false,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                SpaceBox(height: SizeConfig.blockSizeVertical * 5),
                Container(
                  height: SizeConfig.blockSizeVertical * 90,
                  child: Column(
                    children: <Widget>[
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Column(children: <Widget>[
                              Container(
                                width: SizeConfig.blockSizeHorizontal * 18,
                                height: SizeConfig.blockSizeVertical * 1,
                                margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                child: Divider(color: Colors.black),
                              ),
                              Container(
                                width: SizeConfig.blockSizeHorizontal * 18,
                                height: SizeConfig.blockSizeVertical * 1,
                                margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                child: Divider(color: Colors.black),
                              ),
                            ]),
                            Text('プレイヤー設定',
                                style: TextStyle(
                                  fontSize: 24,
                                )),
                            Column(children: <Widget>[
                              Container(
                                width: SizeConfig.blockSizeHorizontal * 18,
                                height: SizeConfig.blockSizeVertical * 1,
                                margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                child: Divider(color: Colors.black),
                              ),
                              Container(
                                width: SizeConfig.blockSizeHorizontal * 18,
                                height: SizeConfig.blockSizeVertical * 1,
                                margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                child: Divider(color: Colors.black),
                              ),
                            ]),
                          ]),
                      SpaceBox(height: SizeConfig.blockSizeVertical * 5),
                      // 人数設定（ボタンで増減）
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Visibility(
                            visible: playerNum > 3,
                            maintainSize: true, // 非表示時も領域を確保
                            maintainAnimation: true,
                            maintainState: true,
                            child: TextButton.icon(
                              onPressed: () {
                                if (playerNum > 3) {
                                  //人数減
                                  setState(() {
                                    playerNum--;
                                  });
                                  remove(items[items.length - 1].id);
                                }
                              },
                              icon: Icon(
                                Icons.arrow_left,
                                size: SizeConfig.blockSizeHorizontal * 14,
                                color: Colors.grey[800],
                              ),
                              label: Text(''),
                              style: TextButton.styleFrom(
                                backgroundColor: HexColor('ffffff'),
                              ),
                            ),
                          ),
                          Text(playerNum.toString() + '人',
                              style: TextStyle(
                                fontSize: 24,
                              )),
                          Visibility(
                            visible: playerNum < 4,
                            maintainSize: true, // 非表示時も領域を確保
                            maintainAnimation: true,
                            maintainState: true,
                            child: TextButton.icon(
                              onPressed: () {
                                if (playerNum < 4) {
                                  //人数増
                                  setState(() {
                                    playerNum++;
                                  });
                                  add();
                                }
                              },
                              icon: Icon(
                                Icons.arrow_right,
                                size: SizeConfig.blockSizeHorizontal * 14,
                                color: Colors.grey[800],
                              ),
                              label: Text(''),
                              style: TextButton.styleFrom(
                                backgroundColor: HexColor('ffffff'),
                              ),
                            ),
                          ),
                        ],
                      ),
                      // プレイヤー名設定（人数と連動してフォーム数増減）
                      Container(
                        padding: EdgeInsets.only(
                            top: SizeConfig.blockSizeVertical * 2,
                            right: SizeConfig.blockSizeHorizontal * 1,
                            bottom: SizeConfig.blockSizeVertical * 2,
                            left: SizeConfig.blockSizeHorizontal * 6),
                        width: SizeConfig.blockSizeHorizontal * 85,
                        height: SizeConfig.blockSizeVertical * 60,
                        //color: Colors.grey[200],
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 1.5),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            //...items.map((item) => textFieldItem(item)),
                            ...items
                                .asMap()
                                .map((index, item) =>
                                    MapEntry(index, textFieldItem(index, item)))
                                .values
                                .toList(),
                          ],
                        ),
                      ),
                      SpaceBox(height: SizeConfig.blockSizeVertical * 5),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            // 戻る
                            OutlinedButton.icon(
                                icon: const Icon(
                                  Icons.navigate_before_rounded,
                                  color: Colors.black,
                                ),
                                label: const Text('戻る'),
                                style: OutlinedButton.styleFrom(
                                  textStyle: TextStyle(
                                    fontFamily: 'Mintyou',
                                    fontSize: 15,
                                  ),
                                  padding: EdgeInsets.only(
                                      top: SizeConfig.blockSizeVertical * 1.3,
                                      right:
                                          SizeConfig.blockSizeHorizontal * 10,
                                      bottom:
                                          SizeConfig.blockSizeVertical * 1.3,
                                      left: SizeConfig.blockSizeHorizontal * 8),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation,
                                          secondaryAnimation) {
                                        return MyHomePage(
                                            title: 'Flutter Demo Home Page');
                                      },
                                      transitionsBuilder: (context, animation,
                                          secondaryAnimation, child) {
                                        final Offset begin =
                                            Offset(-1.0, 0.0); // 左から右
                                        final Offset end = Offset.zero;
                                        final Animatable<Offset> tween =
                                            Tween(begin: begin, end: end).chain(
                                                CurveTween(
                                                    curve: Curves.easeInOut));
                                        final Animation<Offset>
                                            offsetAnimation =
                                            animation.drive(tween);
                                        return SlideTransition(
                                          position: offsetAnimation,
                                          child: child,
                                        );
                                      },
                                    ),
                                  );
                                }),
                            // 次の設定へ
                            TextButton.icon(
                              icon: const Icon(
                                Icons.navigate_next_rounded,
                              ),
                              label: const Text('次の設定'),
                              style: TextButton.styleFrom(
                                textStyle: TextStyle(
                                  fontFamily: 'Mintyou',
                                  fontSize: 15,
                                ),
                                padding: EdgeInsets.only(
                                    top: SizeConfig.blockSizeVertical * 1.3,
                                    right: SizeConfig.blockSizeHorizontal * 10,
                                    bottom: SizeConfig.blockSizeVertical * 1.3,
                                    left: SizeConfig.blockSizeHorizontal * 8),
                              ),
                              onPressed: () {
                                items.forEach((item) {
                                  players.add(new Player(item.id, item.text, 0,
                                      1, 0, 0, 0, 0, 'images/player$num.png'));
                                  num = num + 1;
                                });
                                players.forEach((player) {
                                  if (player.name == "") {
                                    player.name = "プレイヤー" +
                                        (players.indexOf(player) + 1)
                                            .toString();
                                  }
                                });
                                _orderSetShuffle(players);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            GamePage(players)));
                              },
                            ),
                          ])
                    ],
                  ),
                ),
              ]),
        ),
      ),
    );
  }

  // プレイヤー名入力フォーム
  Widget textFieldItem(
    int index,
    Item item,
  ) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            decoration:
                InputDecoration(hintText: "プレイヤー" + (index + 1).toString()),
            keyboardType: TextInputType.name,
            maxLength: 10,
            controller: item.controller,
            onChanged: (text) {
              setState(() {
                items = items
                    .map((e) => e.id == item.id ? item.change(text) : e)
                    .toList();
              });
            },
          ),
        ),
        IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            if (playerNum > 3) {
              setState(() {
                playerNum--;
              });
              remove(item.id);
            }
          },
        )
      ],
    );
  }
}
