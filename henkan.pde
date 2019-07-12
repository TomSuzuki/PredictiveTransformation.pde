// デバッグ用
void setup() {
  // テストデータの設定
  String[] testData = {"あいす", "ながめのてすとでーた", "m", "てすと", "", "ー", "あ", "ろ"};  // テストデータ
  int num = 32;	// 取得するデータの数

  // 辞書データの準備
  println("---Start---");
  println("辞書データ準備中...");
  float m = millis();
  convertingCandidates cc = new convertingCandidates();  // 辞書データを作る
  println("実行時間：", ""+(millis()-m)/1000+"s");
  println();

  // テスト
  for (String t : testData) {
    m = millis();
    String[] getData = cc.PredictiveTransformation(t, num, false);	// 変換候補の取得
    m = (millis()-m)/1000;
    println("------------------------------------------");
    println(getData);
    //for (String s : getData) println(s);
    println();
    println("テストデータ：", t);
    println("実行時間：", ""+m+"s");
    println("取得データ数：", getData.length);
    println("データの数：", cc.getDictionary().size());
  }
  println("---End---");
  exit();
}