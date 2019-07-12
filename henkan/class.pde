import java.util.Collections;

// カプセル化？
class convertingCandidates {

  // 変数
  private ArrayList<Dictionary> dictionary = new ArrayList<Dictionary>();  // 辞書です

  // コンストラクタ（毎回データ読んでソートは重いので先にやっておく）
  public convertingCandidates() {
    // データを読み込む
    String[] extensions = {".csv"};
    File[] fileList = new File(dataPath("dic")).listFiles();
    for (File f : fileList) for (String extension : extensions) if (f.getPath().endsWith(extension)) for (String s : loadStrings(f.getAbsolutePath())) {
      String[] dic = split(s, ",");
      if (dic.length <= 1) continue;
      dictionary.add(new Dictionary(dic[0], dic[1]));
    }

    // 並べ替える
    Collections.sort(dictionary);
  }

  // 辞書データのクラス
  class Dictionary  implements Comparable<Dictionary> {

    // 変数とか
    private String beforeConverting;  // 変換前のデータ
    private String afterConverting;  // 変換後のデータ

    // コンストラクタ（変換前、変換後）
    public Dictionary(String beforeConverting, String afterConverting) {
      this.beforeConverting = beforeConverting;
      this.afterConverting = afterConverting;
    }

    // 変換前のデータを返す
    private String getBeforeConverting() {
      return beforeConverting;
    }

    // 変換後のデータを得る
    private String getAfterConverting() {
      return afterConverting;
    }

    // 一致文字数を返す
    private int matchedLength(String Target) {
      int matchedLength = 0;
      while (Target.substring(0, matchedLength+1).equals(beforeConverting.substring(0, matchedLength+1)) && ++matchedLength < min(beforeConverting.length(), Target.length()));
      return matchedLength;
    }

    // 比較用（並べ替え用）
    public int compareTo(Dictionary p1) {
      return this.getBeforeConverting().compareTo(p1.getBeforeConverting());
    }

    // デバッグ用
    public String toString() {
      return ""+beforeConverting+","+afterConverting+"";
    }
  }

  // 変換のデータを入れるクラス
  class Candidates {

    // 変数
    private String data;    // 文字列を入れる
    private int matchedLength; // 一致する長さを入れる

    // コンストラクタ（変換後、一致長さ）
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

  // 変換の関数
  private String[] PredictiveTransformation(String Target, int num) {
    // 例外
    num = num - 1;
    if (Target.equals("")) return new String[] {""};
    if(num < 0) return new String[0];

    // データの最初の場所（あとでindexOfに変える）
    int index = 0;
    for (Dictionary d : dictionary) if (null != match(d.getBeforeConverting(), "^"+Target.substring(0, 1)+"[.]*")) break;
    else index++;
    if (index == dictionary.size()) return new String[] {Target};

    // 変数とか
    ArrayList<Candidates> CandidatesData = new ArrayList<Candidates>();

    // 変換候補を保存
    for (; index < dictionary.size(); index++) {
      Dictionary d = dictionary.get(index);
      if (d.matchedLength(Target) == 0) break;  // 並べ替えているので0になった時点で配列に入ることがない
      if (d.getAfterConverting().equals(Target)) continue;  // 変換後がターゲットと全く同じならデータに入れない
      Candidates tmp = new Candidates(d.getAfterConverting(), d.matchedLength(Target));
      for (int i = CandidatesData.size()-1; i >= -1; i--) { 
        if (i != -1 && tmp.compare(CandidatesData.get(i)) == 0) break;  // 同じ文字列は除外
        if (i != -1 && tmp.compare(CandidatesData.get(i)) > 0 || i == -1) {  // データを入れる場所を決める（一番上まで来たら最も一致しているってこと）
          CandidatesData.add(i+1, tmp);
          if (CandidatesData.size() > num) CandidatesData.remove(num);  // 指定より多かったら削除
          break;
        }
      }
    }

    // 返却用に型を変える
    String[] s = new String [CandidatesData.size()+1];
    s[0] = Target;  // ターゲットを一番上に入れる（変換候補が変換前と同じ）
    for (int i = 0; i < CandidatesData.size(); i++) s[i+1] = CandidatesData.get(i).getData();
    return s;
  }
}