// デバッグ用
void setup() {
  // テストデータの設定
  final String[] testData = {"あいす", "ながめのてすとでーた", "m", "てすと", "", "ー", "あ", "ろ", "無"};  // テストデータ
  final int num = 12;	// 取得するデータの数

  // 辞書データの準備
  println("辞書データ準備中...");
  double n = System.nanoTime();
  convertingCandidates cc = new convertingCandidates();  // 辞書データを作る
  n = (System.nanoTime()-n)/1000000;
  println("実行時間：", ""+n+"ms", n/1000+"s");
  println("------------------------------------------");

  //println(cc.getDictionary());

  // テスト
  for (String t : testData) {
    n = System.nanoTime();
    String[] getData = cc.PredictiveTransformation(t, num, false);	// 変換候補の取得
    n = (System.nanoTime()-n)/1000000;
    println("テストデータ：", t);
    println("検索結果：", join(getData, " "));
    println("実行時間：", n > 0 ? ""+n+"ms" : "計測不能");
    println("取得データ数：", getData.length);
    println("データの数：", cc.getDictionary().size());
    println("------------------------------------------");
  }
  println("テスト終了");
  exit();
}