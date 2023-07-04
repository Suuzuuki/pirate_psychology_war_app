class Player {
  // 一意の番号
  int id;
  // プレイヤー名
  String name;
  // 現在の場所
  int current_position;
  // 残りのストック
  int remaining_stock;
  // 点数
  int score;
  // ゴールしたコマ
  int goal;
  // プレイヤー設定順番
  int player_order;
  // 出題順番
  int paint_order;
  // 出題順番
  String image_path;

  Player(
    this.id,
    this.name,
    this.current_position,
    this.remaining_stock,
    this.score,
    this.goal,
    this.player_order,
    this.paint_order,
    this.image_path,
  );
}
