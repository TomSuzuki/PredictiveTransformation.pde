// デバッグ用
void setup() {
  println("---Start---");
  convertingCandidates cc = new convertingCandidates();  // 辞書データを作る
  String[] testData = {"あいす", "かんじ", "m", "てすと"};  // テストデータ
  for (String t : testData) {
    println("*テストデータ："+t);
    for (String s : cc.PredictiveTransformation(t, 12)) println(s);
    println();
  }
  println("---End---");
}