// パッケージ
import '/util/importer.dart';
import '/util/arrow.dart';

class RandomUnion {
  // ランダムな数値 例：最大値＝6 の場合 0.0 <= randomValue < 6.0
  double randomValue = 0.0;
  // ランダムな数値の整数部のみ
  int randomValueInt = 0;
  // ランダムな数値の小数点以下
  double randomValueUnderPoint = 0.0;

  /// コンストラクター
  /// 最大値を渡す。例：最大値＝6 の場合 0.0 <= randomValue < 6.0
  RandomUnion(int lessThanValue) {
    randomValue = ((lessThanValue) * Random().nextDouble());
    randomValueInt = randomValue.toInt();
    randomValueUnderPoint = randomValue - randomValueInt;
  }
}

class GamePage extends StatefulWidget {
  GamePage(this.playerList);
  final List<Player> playerList;
  @override
  _GamePageState createState() => _GamePageState(this.playerList);
}

class _GamePageState extends State<GamePage>
    with SingleTickerProviderStateMixin {
  _GamePageState(this.playerList);
  // プレイヤーリスト
  List<Player> playerList;
  // サイコロの結果
  int diceResult = 100;
  // サイコロの結果画面出力用
  String diceResultForDisplay = '';
  // 直近のプレイヤー
  int currentPlayer = 0;
  // 嘘のサイコロの結果
  int lieNumber = 0;
  // 嘘をついたか
  bool isTellingLie = false;
  // 直近のプレイヤー
  bool hitLie = false;
  // 直近のプレイヤー
  bool selectHitLieStatus = false;
  // サイコロの結果がどくろだったステータス
  bool skull = false;
  // サイコロの結果がどくろだったステータス
  bool rouletteStatus = false;
  // 現在のポジション
  List<int> currentPositions = [0, 0, 0, 0];
  // 直近のプレイヤー
  List<int> dicePipList = [1, 2, 3, 4];
  // 直近のプレイヤー
  int goalScore = 1;
  // 現在のプレーヤー
  int currentPlayerNum = 0;
  // 直近のプレイヤー
  int goalhantei = 0;
  // 直近のプレイヤー
  late Player tempPlayer;
  // 直近のプレイヤー
  late List<Player> tempPlayerList;
  // サイコロの目を格納する変数の初期化
  var DiceNumber = 1;
  // ルーレット用のコントローラー
  late RouletteController _controller;
  bool _clockwise = true;

  /// クラスが呼び出された時に起動するメソッド
  ///
  /// [getTable]と[initGetAttendant]を呼ぶ。
  @override
  void initState() {
    // プレイヤーをペイント順に並び変える
    playerList.sort((a, b) => a.paint_order.compareTo(b.paint_order));
    tempPlayerList = List.of(playerList);
    final group = RouletteGroup.uniform(
      6,
      colorBuilder: (index) {
        switch (index) {
          case 0:
            return Colors.red.withAlpha(200);
          case 1:
            return Colors.green.withAlpha(200);
          case 2:
            return Colors.blue.withAlpha(200);
          case 3:
            return Colors.yellow.withAlpha(200);
          case 4:
            return Colors.amber.withAlpha(200);
          default:
            return Colors.indigo.withAlpha(200);
        }
      },
      textBuilder: (index) {
        switch (index) {
          case 0:
            return "1";
          case 1:
            return "2";
          case 2:
            return "3";
          case 3:
            return "4";
          case 4:
            return "💀";
          default:
            return "💀";
        }
      },
      textStyleBuilder: (index) {
        // Set the text style here!
      },
    );
    _controller = RouletteController(vsync: this, group: group);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        //Androidの戻るボタン無効化
        onWillPop: () async => false,
        child: Scaffold(
            body: Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage('images/nami.jpg'),
                  fit: BoxFit.cover,
                )),
                child: Stack(
                    fit: StackFit.expand, // これを設定すると画面いっぱいに画像が描画されます。
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            //Containerでも同じ
                            height: 50,
                          ),
                          for (Player player in playerList)
                            Text(
                              '${player.name}： 現在の場所: ${player.current_position}, 残りのストック: ${player.remaining_stock}, 点数: ${player.score}, ゴール: ${player.goal}',
                              style: const TextStyle(fontSize: 24),
                            ),
                          SizedBox(
                              //Containerでも同じ
                              height: 500,
                              child: Column(children: [
                                SizedBox(
                                  //Containerでも同じ
                                  height: 400,
                                  child: Container(
                                    child: Column(children: [
                                      for (Player player in playerList)
                                        Row(children: [
                                          SizedBox(
                                              width: SizeConfig
                                                      .blockSizeHorizontal *
                                                  (5 +
                                                      player.current_position *
                                                          10)),
                                          SizedBox(
                                            width:
                                                SizeConfig.blockSizeHorizontal *
                                                    13,
                                            height:
                                                SizeConfig.blockSizeHorizontal *
                                                    13,
                                            child:
                                                Image.asset(player.image_path),
                                          ),
                                        ]),
                                    ]),
                                  ),
                                ),
                              ])),
                          Text(
                            'Current Player: Player ${playerList[currentPlayerNum].name}',
                            style: const TextStyle(fontSize: 24),
                          ),
                          Text(
                            'Dice Result: $diceResultForDisplay',
                            style: const TextStyle(fontSize: 24),
                          ),
                          if (diceResult != 100 &&
                              !isTellingLie) // ダイスが振られたら嘘をつくか選ぶボタンを表示
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 300,
                                      height: 300,
                                      child:
                                          Image.asset('images/$DiceNumber.png'),
                                    ),
                                    const Text(
                                      'Choose Lie Number:',
                                      style: TextStyle(fontSize: 24),
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        if (skull == false)
                                          ElevatedButton(
                                            child: const Text('嘘をつかない'),
                                            onPressed: () {
                                              setState(() {
                                                isTellingLie = true;
                                                hitLie = true;
                                              });
                                            },
                                          ),
                                        for (int dicePip in dicePipList)
                                          ElevatedButton(
                                            child: Text(dicePip.toString()),
                                            onPressed: () =>
                                                selectLieNumber(dicePip),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          if (hitLie) // 嘘をつくか選ぶボタンが押された後の当てる時間
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      '嘘だと思いますか？',
                                      style: TextStyle(fontSize: 24),
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ElevatedButton(
                                          child: const Text('嘘ではない'),
                                          onPressed: () => selectHitLie(0),
                                        ),
                                        ElevatedButton(
                                          child: const Text('嘘'),
                                          onPressed: () => selectHitLie(1),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          if (selectHitLieStatus) // 嘘をつくか選ぶボタンが押された後の当てる時間
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      '当てたのは誰ですか？',
                                      style: TextStyle(fontSize: 24),
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        for (Player player in tempPlayerList)
                                          ElevatedButton(
                                            child: Text(player.name),
                                            onPressed: () => selectHitPlayer(
                                                player.paint_order),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                      Positioned(
                        // 左上からどれだけ右にあるか
                        left: SizeConfig.blockSizeHorizontal * 3,
                        // 左上からどれだけ下にあるか
                        top: SizeConfig.blockSizeVertical * 65,
                        child: // ダイスが振られたら嘘をつくか選ぶボタンを表示
                            Column(
                          children: [
                            if (diceResult == 100)
                              GestureDetector(
                                onTap: () {
                                  if (!rouletteStatus) {
                                    rouletteStatus = true;
                                    // 結果を先に生成する 0.0 <= result < 6.0
                                    var result = RandomUnion(6);
                                    diceResult = result.randomValueInt + 1;
                                    // 結果を仕込んでルーレットを回す
                                    _controller
                                        .rollTo(
                                          result
                                              .randomValueInt, // ランダム値の整数部を結果とする
                                          clockwise: _clockwise,
                                          offset: result
                                              .randomValueUnderPoint, // ランダム値の小数点以下をオフセットとする
                                        )
                                        .then((_) => {
                                              // ルーレットが止まった時の処理
                                              setState(() {
                                                rouletteStatus = false;
                                                if (diceResult == 6 ||
                                                    diceResult == 0) {
                                                  diceResult = 5;
                                                }
                                                DiceNumber = diceResult;
                                                if (diceResult == 5) {
                                                  skull = true;
                                                  diceResultForDisplay = '💀';
                                                } else {
                                                  dicePipList
                                                      .remove(diceResult);
                                                  diceResultForDisplay =
                                                      diceResult.toString();
                                                }
                                                isTellingLie =
                                                    false; // ダイスを振るたびに嘘をつくか選ぶ状態をリセット
                                              }),
                                            });
                                  }
                                },
                                child: Stack(
                                  alignment: Alignment.topCenter,
                                  children: [
                                    SizedBox(
                                      width:
                                          SizeConfig.blockSizeHorizontal * 96,
                                      height:
                                          SizeConfig.blockSizeHorizontal * 96,
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 30),
                                        child: Roulette(
                                          // Provide controller to update its state
                                          controller: _controller,
                                          // Configure roulette's appearance
                                          style: const RouletteStyle(
                                            dividerThickness: 4,
                                            textLayoutBias: .8,
                                            centerStickerColor:
                                                Color(0xFF45A3FA),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const Arrow(),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      )
                    ]))));
  }

  /// 取得したすべてのテーブル情報からと選択中のテーブルアイテムを作成するメソッド
  ///
  /// * tableItemListからポジションをもとにテーブルアイテムを作成
  void selectLieNumber(int number) {
    setState(() {
      lieNumber = number;
      isTellingLie = true;
      hitLie = true;
    });
  }

  /// 取得したすべてのテーブル情報からと選択中のテーブルアイテムを作成するメソッド
  ///
  /// * tableItemListからポジションをもとにテーブルアイテムを作成
  void selectHitLie(int number) {
    setState(() {
      hitLie = false;
      if (number == 1) {
        selectHitLieStatus = true;
        tempPlayerList = List.of(playerList);
        tempPlayer = tempPlayerList.removeAt(currentPlayerNum);
      } else {
        if (lieNumber != 0) {
          playerList[currentPlayerNum].current_position += lieNumber; // 嘘の数字を加算
        } else {
          playerList[currentPlayerNum].current_position +=
              diceResult; // 嘘の数字を加算
        }
        reset();
      }
    });
  }

  /// 取得したすべてのテーブル情報からと選択中のテーブルアイテムを作成するメソッド
  ///
  /// * tableItemListからポジションをもとにテーブルアイテムを作成
  void selectHitPlayer(int number) {
    setState(() {
      if (lieNumber != 0) {
        for (Player player in playerList) {
          if (player.paint_order == number) {
            player.current_position += 1;
          }
        }
        playerList[currentPlayerNum].remaining_stock -= 1; // 嘘の数字を加算
        playerList[currentPlayerNum].current_position = 0; // 嘘の数字を加算
      } else {
        for (Player player in playerList) {
          if (player.paint_order == number) {
            player.remaining_stock -= 1;
            player.current_position = 0;
          }
        }
        if (lieNumber != 0) {
          playerList[currentPlayerNum].current_position += lieNumber; // 嘘の数字を加算
        } else {
          playerList[currentPlayerNum].current_position +=
              diceResult; // 嘘の数字を加算
        }
      }
      selectHitLieStatus = false;
      reset();
    });
  }

  /// 取得したすべてのテーブル情報からと選択中のテーブルアイテムを作成するメソッド
  ///
  /// * tableItemListからポジションをもとにテーブルアイテムを作成
  void reset() {
    for (Player player in playerList) {
      if (player.current_position >= 7) {
        player.current_position = 0;
        player.score += goalScore;
        player.goal += 1;
        goalScore += 1;
      }
      if (player.goal >= 1) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ResultPage(playerList, true)));
      }
      if (player.remaining_stock != 0) {
        goalhantei = 1;
      }
    }
    if (goalhantei == 0) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ResultPage(playerList, false)));
    }
    setState(() {
      diceResult = 100;
      lieNumber = 0;
      skull = false;
      goalhantei = 0;
      dicePipList = [1, 2, 3, 4];
      if (currentPlayerNum != playerList.length - 1) {
        currentPlayerNum += 1;
      } else {
        currentPlayerNum = 0;
      }
    });
  }
}
