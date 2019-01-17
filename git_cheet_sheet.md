## dev process

1. ブランチ確認(all[local/remote])
   $ git branch -a
2. remoteのブランチを元にローカルに新しいブランチを作成
   $ git checkout -b "created branch name" "origin/copy source branch name"
3. ブランチをリモートに登録
   $ git push -u origin "created branch name"

## memo
* コミットで反映される変更を表示
  commit(HEAD) =/=  index == working copy(working tree)

* create and checkout
  $ git checkout -b <branch>

* set hilight
  $ git config --global color.ui true

## What origin?
"origin" is "remote repository" alias
 attention: remote repository ==> not branch

## fetc/pull
> <https://eng-entrance.com/git-fetch>
pull(=fetch & merge)


* fetch
  fetch update "local repository" with "remote repository"
  \---------------------------------------------------------------------------
  * before  
  :remote side   | :local side
  +---------+    | +----------------+    +---------------------------------+
  | remote  | =/=| | origin/master  | == | master(related to woriking dir) |
  +---------+    | +----------------+    +---------------------------------+
                 |

  * after  
  :remote side  | :local side
  +---------+   | +----------------+     +---------------------------------+
  | remote  | ==| | origin/master  | =/= | master(related to woriking dir) |
  +---------+   | +----------------+     +---------------------------------+
                |
  \---------------------------------------------------------------------------

## diff
> <http://d.hatena.ne.jp/murank/20110320/1300619118>
* check changes with remote before "git pull"
  $ git diff "remote name/branch name"..HEAD
  ex) git diff "origin/master"..HEAD


(Y and D are commits)
* diff commit in same branch
  $ git diff Y...D
* diff commit in different branch
  $ git diff Y..D

* stage concept
git addをつかって、「このファイルは次回のコミットに含める」と宣言してやる必要があります。  
このようにある変更点を次回のコミットに含めるようgitに指示することをgit用語で 「stageする」とかstagingと言います。  
\--------------------------------------------------------------------------------------
「(リポジトリに格納された)最新のコミット」＝「index」＝「ワーキングコピー」

となっています。ワーキングコピーを編集すると
「最新のコミット」＝「index」≠「ワーキングコピー」

となりますね。次にaddの操作をを図示すると、
「最新のコミット」＝「index」←(git add)←「ワーキングコピー」

であり、その結果、
「最新のコミット」≠「index」＝「ワーキングコピー」

となります。
なお、「index」の内容を「最新のコミット」として反映するリポジトリに反映するコマンドはgit commitです。
commitの操作を図示すると、
「最新のコミット」←(git commit)←「index」＝「ワーキングコピー」

であり、その結果
「最新のコミット」＝「index」＝「ワーキングコピー」
\--------------------------------------------------------------------------------------

1ファイル内で複数の箇所を編集してしまった場合も考えられます。
そんなときは、このgit add -p を実行すれば、1ファイル内の差分ごとにstageする/しないを対話的に選択できます。



## reference
* [cheet_sheet](https://qiita.com/shibukk/items/8c9362a5bd399b9c56be)


## aapendix
Git 2.9.0 から diff が賢くなり、compactionHeuristic を ON にしておくと上方向に比較差分が出るようになりました。
見やすくていいですね。

git config --global diff.compactionHeuristic true
# diffコマンドのオプションに --compaction-heuristic をつけるだけでもOK

kajfkajl
kajflajkfjkla
