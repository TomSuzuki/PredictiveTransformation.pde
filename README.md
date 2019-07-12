# 変換関数
スケジューラの改良版変換関数

## メモ
どうやって変換しているか聞かれることが多かったのでわかりやすいように改良しました。  

## 関数について
```processing
// 辞書データを読み込む（最初に1回だけ行う）
convertingCandidates cc = new convertingCandidates();

// 変換の関数
String[] cc.PredictiveTransformation(String Target, int num, boolean containTarget);
```
第1引数（Target）...変換の対象となる文字列です。（アルファベットもしくはひらがなをいれてください）  
第2引数（num）...返す文字列の数の最大です。多すぎると時間がかかります。（32程度で使うことを想定しています。）  
第3引数（containTarget）...変換の対象を変換候補に強制的に入れるか指定します。  

## 例
```processing
void setup(){
  convertingCandidates cc = new convertingCandidates();
  for (String s : cc.PredictiveTransformation("あ", 32, false)) println(s);
}
```

## データについて
dicフォルダに拡張子をcsvにしていれます。  
形式は ひらがな,漢字 のcsvです。  

## 改良するなら
- 検索結果の一番最下よりも一致率が低ければそれ以降に一致するものがないはず  
- 最も一致するものから検索していくともっと早いかも（並べ替えてi+1よりもiのほうが高いときは最も一致しているものと同じ一致率のはず）  
