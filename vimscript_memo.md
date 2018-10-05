# memo1
> <http://toyamarinyon.hatenablog.jp/entry/2012/04/28/131034>
expand({expr})

{expr}が'%'か'#'か'<'で始まる場合には、展開は|cmdline-special|                                                                                                                   
            のように、変換子を受け付け、それらに関連付けられた変換が施され
            る。ここに簡単な概略を示す:

                    %               現在のファイル名
                    #               代替バッファのファイル名
                    #n              n番の代替バッファのファイル名
                    <cfile>         カーソルのしたのファイル名
                    <afile>         autocmdのファイル名
                    <abuf>          autocmdのバッファ名
                    <sfile>         取り込み(source)中のファイル名
                    <slnum>         取り込み(source)中の行番号
                    <cword>         カーソル下の単語(word)
                    <cWORD>         カーソル下の単語(WORD)
                    <client>        最後に受け取ったメッセージの{clientid}
                                    |server2client()|

            変換子:
                    :p              フルパス名を展開
                    :h              ヘッド(ディレクトリ)
                    :t              テイル(ファイル名だけ)
                    :r              拡張子が削除される
                    :e              拡張子だけ
