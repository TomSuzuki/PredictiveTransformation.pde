// デバッグ用
void setup() {
  println("---Start---");
  for (String s : PredictiveTransformation("あいす", 12)) println(s);
  println("---End---");
}

// 変換のデータを入れる
class Candidates {

  // 変数
  private String data;    // 文字列を入れる
  private int matchedLength; // 一致する長さを入れる

  // コンストラクタ
  public Candidates(String data, int matchedLength) {
    this.data = data;
    this.matchedLength = matchedLength;
  }

  // 一致の長さを取得
  private int getMatchedLength() {
    return matchedLength;
  }

  // 文字列を取得
  private String getData() {
    return data;
  }

  // 比較用関数（優先度：一致文字の長さ、文字列の長さ、文字列）
  private int compare(Candidates obj2) {
    Candidates obj1 = this;
    if (obj2.getMatchedLength() != obj1.getMatchedLength()) return obj2.getMatchedLength()-obj1.getMatchedLength();
    if (obj1.getData().length() != obj2.getData().length()) return obj1.getData().length()-obj2.getData().length();
    return obj1.getData().compareTo(obj2.getData());
  }
}

// 変換をする関数（どこかにいいライブラリあるだろうけど調べる時間が無かった）
String[] PredictiveTransformation(String Target, int num) {
  // 例外
  if (Target.equals("")) return new String[0];

  // 宣言とか
  String[] extensions = {Target.substring(0, 1)+".csv", "user.csv"};  // 辞書ファイルのリスト
  File[] fileList = new File(dataPath("dic")).listFiles();               // すべてのファイルのリスト
  ArrayList<Candidates> CandidatesData = new ArrayList<Candidates>();    // 変換候補のリスト

  // 読み込み
  for (File f : fileList) for (String extension : extensions) if (f.getPath().endsWith(extension)) for (String s : loadStrings(f.getAbsolutePath())) {
    String[] dic = split(s, ",");  // (もじれつ,文字列)の形式を分解する
    if (dic.length <= 1) continue;  // データがなかったら直前のforに戻る

    // 何文字目まで一致するか調べる
    int matchedLength = 0;
    while (Target.substring(0, matchedLength+1).equals(dic[0].substring(0, matchedLength+1)) && ++matchedLength < min(dic[0].length(), Target.length()));

    // データを入れる
    if (matchedLength > 0) {
      Candidates tmp = new Candidates(dic[1], matchedLength);
      for (int i = CandidatesData.size()-1; i >= -1; i--) {
        if (i != -1 && tmp.compare(CandidatesData.get(i)) == 0) break;  // 同じ文字列は除外
        if (i != -1 && tmp.compare(CandidatesData.get(i)) > 0 || i == -1) {  // データを入れる場所を決める（一番上まで来たら最も一致しているってこと）
          CandidatesData.add(i+1, tmp);
          if (CandidatesData.size() > num) CandidatesData.remove(num);  // 指定より多かったら削除
          break;
        }
      }
    }
  }

  // 返却用に型を変える
  String[] s = new String [CandidatesData.size()];
  for (int i = 0; i < CandidatesData.size(); i++) s[i] = CandidatesData.get(i).getData();
  return s;
}
