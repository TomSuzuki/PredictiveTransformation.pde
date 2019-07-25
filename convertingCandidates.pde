import java.util.Collections;

// 変換するやつ
class convertingCandidates {

  // 設定
  private final String[] extensions = {".csv"};  // 読み込むファイルの拡張子です
  private final File[] fileList = new File(dataPath("dic")).listFiles(); // 読み込むファイルのリストです

  // 変数
  private ArrayList<Dictionary> dictionary = new ArrayList<Dictionary>();  // 辞書です

  // コンストラクタ（毎回データ読んでソートは重いので先にやっておく）
  public convertingCandidates() {    
    // データを読み込む
    for (File f : fileList) for (String extension : extensions) if (f.getPath().endsWith(extension)) for (String s : loadStrings(f.getAbsolutePath())) {
      String[] dic = split(s, ",");
      if (dic.length == 2 && !dic[0].equals("")) dictionary.add(new Dictionary(dic[0], dic[1]));    // メモリ確保に時間がかかる
    }

    // 並べ替える
    Collections.sort(dictionary);
  }

  // デバッグ用
  private ArrayList<Dictionary> getDictionary() {
    return dictionary;
  }

  // 辞書データのクラス
  private class Dictionary implements Comparable<Dictionary> {

    // 変数とか
    private String beforeConverting;
    private String afterConverting;

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
      while (Target.substring(0, matchedLength+1).equals(getBeforeConverting().substring(0, matchedLength+1)) && ++matchedLength < min(getBeforeConverting().length(), Target.length()));
      return matchedLength;
    }

    // 比較用（並べ替え用）
    public int compareTo(Dictionary p1) {
      return getBeforeConverting().compareTo(p1.getBeforeConverting());
    }
  }

  // 変換のデータを入れるクラス
  private class Candidates {

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
  private String[] PredictiveTransformation(String Target, int num, boolean containTarget) {
    // 例外
    if (Target.equals("")) return containTarget ? new String[] {""} : new String[0];
    if (num <= 0) return new String[0];

    // データの最初の場所（二分探索）
    int index = 0;  // 検索場所
    int top = 0, bottom = dictionary.size();  // 探索用
    String t = Target.substring(0, 1);  // Targetの１文字目
    while (true) {
      index = (top+bottom+1)/2;
      if (index == 0 || top == bottom) break;
      String s1 = dictionary.get(index).getBeforeConverting().substring(0, 1);
      String s2 = dictionary.get(index-1).getBeforeConverting().substring(0, 1);
      if (s1.equals(t) && !s2.equals(t)) break;
      if (s1.compareTo(t) >= 0 || s1.equals(t)) bottom = index-1;
      else top = index+1;
      if ((index == bottom || index == top) && !s1.equals(t) && !s2.equals(t)) {
        index = dictionary.size();
        break;
      }
    }
    if (index == dictionary.size()) return containTarget ? new String[] {Target} : new String[0];  // 位置文字目すら一致するデータが存在しない

    // 変数とか
    ArrayList<Candidates> CandidatesData = new ArrayList<Candidates>();  // 変換候補を入れておく

    // 変換候補を保存
    if (containTarget) CandidatesData.add(new Candidates(Target, 1+Target.length())); // 変換候補を含む場合はデータを追加
    do {
      Dictionary d = dictionary.get(index);
      int matchedLength = d.matchedLength(Target);
      if (matchedLength == 0) break;  // 並べ替えているので0になった時点で配列に入ることがない
      if (d.getAfterConverting().equals(Target)) continue;  // 変換後がターゲットと全く同じならデータに入れない
      Candidates tmp = new Candidates(d.getAfterConverting(), matchedLength);  // 現在のデータを仮の変数に入れておく
      for (int i = CandidatesData.size()-1; i >= -1; i--) { 
        if (i != -1 && tmp.compare(CandidatesData.get(i)) == 0) break;  // 同じ文字列は除外
        if (i != -1 && tmp.compare(CandidatesData.get(i)) > 0 || i == -1) {  // データを入れる場所を決める（一番上まで来たら最も一致しているってこと）
          CandidatesData.add(i+1, tmp);
          if (CandidatesData.size() > num) CandidatesData.remove(num);  // 指定より多かったら削除
          break;
        }
      }
    } while (++index < dictionary.size());  // データがなくなるまで繰り返す

    // 返却用に型を変える（変換候補型配列から文字列型配列へ）
    String[] s = new String [CandidatesData.size()];
    for (int i = 0; i < CandidatesData.size(); i++) s[i] = CandidatesData.get(i).getData();
    return s;
  }
}
