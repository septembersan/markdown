# sklearn implementation memo
## LinearRegression
* 前処理はfit()内で行っている self._preprocess_data()
* fit()のsample_weightは外れ値対応用
* 疎行列での実装について
    > http://hamukazu.com/2014/09/26/scipy-sparse-basics/
    * 行列を密配列でもたなくなるため、基本的には行列が大きい場合にのみ有効
    * 疎行列で実際に計算させる際には疎行列で持たせておいて、必要な時に密行列変換を行うとよい
    * csc同士, csr同士の和・積は高速
    * csc or csr? csc -> colの取り出しが高速, csr -> rowの取り出しが高速
    * csc_matrix.T -> csr_matrix, csr_matrix.T -> csc_matrix

### 実装
1. 入力配列確認
2. 前処理実施
    * 標準化/正規化
    * sample_weightでの説明変数の重み調整
3. 重みが調整されていたらrescale
4. 
