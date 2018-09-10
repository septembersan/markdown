k8s memo
==========================
2018/09/03
-----------------                

## Summary
本紙はk8s動作検証の際のmemoである。  
k8sのコマンドやコンポーネント、それらの関連について記載している。  
また、AAPFのwikiにもk8sの学習ページがあるため合わせて参照すること。  
* [AAPF on Kubernetes調査・検討資料まとめ](http://sampo-03.asou.nec.co.jp:50080/nishiyama/k8s/blob/master/README.md)

## k8s  components(固有名詞の説明)
* k8s Objects
  * k8s の機能の構成要素
  * k8s Control Plane から後に紹介するものは全て k8s Objects
* k8s Control Plane
  * k8s Objects を実現するためにマシン上で稼働するプロセス群
  * k8s cluster のネットワークを構成している
* Node
  * k8s cluster を構成するマシン
  * クラスタの管理を行うのがマスターノード
  * アプリを稼働させるのがメンバーノード
* Pod
  * Node内で稼働するコンテナのグループ
  * アプリケーションを動かすための最小単位（1つ以上のコンテナで構成される）
  * Pod内のコンテナは同一ホスト上で稼働
  * 1つのPodに1つのクラスター内IPが割り当てられる
* Service
  * Pod へのルーティングとロードバランシングを行う
  * クラスター内外の通信を行うために複数のタイプがある
* Label
  * k8s objects（Podとか）に key/value で付与されるメタデータ的なやつ
* Label Selector
  * Label の条件を指定してグルーピングすることが出来る
  * Service がルーティングするためにも使われる
* Deployment
  * 言葉そのままでデプロイに使うオブジェクト
  * Pod を制御することが出来る
  * Pod を起動したりスケールさせたり破棄したり
* ReplicaSet
  * Pod を指定された数に調整する仕組み
  * Pod がレプリカ数より足りない場合には追加、多い場合は削除
  * Deployment の際にコンテナイメージのバージョンアップがあったら新しい ReplicaSet が生成されて新旧のPod数が調整されながらローリングアップグレードがなされる（めっちゃお利口）
* DaemonSet
  * 全てのメンバーノードに共通の Pod を稼働させる仕組み
  * Node が追加されると追加されたノードで自動起動
  * Node で共通な機能を提供したいときに利用（fluentd とか）

## k8s commands(FAQ)
### description
* k8sの操作はkubectlコマンドで行う
* kubectlコマンドで取得できる情報は基本的には-o jsonオプションでjson形式による取得が可能

### commands FAQ
* 各componentsの状態を確認したい
  $ kubectl get "components name"
    ex) kubectl get pod
    ex) kubectl get service
    ex) kubectl get node
    ex) kubectl get deployments

* 各componentsの状態の詳細を確認したい
  $ kubectl describe "components name" "components object name"
    ex) kubectl describe pod pod-name-1

* Podを作成 -> 起動(docker imageを指定してpodを起動)
  * 事前準備(k8sのmaster or nodeでdocker imageをpullして"image name"を確認しておく)
    $ docker pull "image name"
      ex) docker pull fedora/nginx
    $ docker images
  * pod 作成 -> 起動
    $ kubectl run "pod name" --image="image name"
    ex) kubectl run fedora-nginx --image=docker.io/fedora/nginx

* Serviceの作成(作成したPodに対するServiceを作成する)
  $ kubectl expose pod "pod name"
  ex) kubectl expose pod fedora-nginx

* Pod内にログインする(作成したPodにshellを使用してログインする)
  $ kubectl exec -it "pod name" bash
    ex) kubectl exec -it fedora-nginx bash
        (shellなどの対話プロセスは-itをつけること)

* 取得した各componentsのオブジェクトの状態をjsonで取得する
  $ kubectl get "components name" "object name" -o json
    ex) kubectl get pod fedora-nginx -o json

* 取得したjsonをパースする
  $ kubectl get "components name" "object name" -o json|jq '.'  
    ex) kubectl get pod fedora-nginx -o json|jq '.'  
    ex) kubectl get pod fedora-nginx -o json|jq -r '.items[]'  
    ex) kubectl get service --namespace="$current_namespace" -o json|jq -r '.items[0].metadata.name'  
        (shellscriptで記述する場合はjqコマンドに-rをつけること)

* kube-dns(pod)を確認する
  $ kubectl get pods -l k8s-app=kube-dns -n kube-system

* 全Namespaceのcomponents情報を取得する
  $ kubectl get "components name" --all-namespaces
   ex) kubectl get pod --all-namespaces
   ex) kubectl get service --all-namespaces
   ex) kubectl get deployments --all-namespaces

* 各nodeで動作しているPodを確認する
  $ kubectl describe node|grep -A 4 "Non-terminated Pods"
    (describeはjqで取得できない)

* 設定の上書き(--overridesを使用する)
  $ kubectl run "pod name" --image="image name" --overrides 'json code'
    ex) kubectl run fedora-nginx --image=docker.io/fedora/nginx --overrides '{"spec":{"template":{"spec":{"hostname":"foo","subdomain":"bar"}}}}'

## k8s 留意事項
* PodをDeploymentで作成している場合, Deploymentを削除すること  
  (Podのオプション"--restart"はデフォルトでは常時起動(Always)なため)
  (一度のみの起動にする場合は"--restart=Never"にすること)

* 名前解決はServiceを使用する
  * Domain name: NAME(Service name in namespace)
  * IP         : CLUSTER-IP

* PodIP is written in /etc/hosts.

* Service name is written in /etc/resolv.conf

* "nameserver" in /etc/resolv.conf is kube-dns service  

* Serviceのネーミングとディスカバリを行う
  $ kubectl get deployments --namespace=kube-system kube-dns

* DNSサーバーをロードバランシングするためのServiceも動作する
  $ kubectl get services --namespace=kube-system kube-dns

## k8s details
* Podの通信理解        
  * 通信方法           | [GKE/Kubernetes でなぜ Pod と通信できるのか](https://qiita.com/apstndb/items/9d13230c666db80e74d0)
  * VirtualIP          | [Virtual IPs and service proxies](https://kubernetes.io/docs/concepts/services-networking/service/#proxy-mode-iptables)
* kube-DNSの利用と理解 | [Kubernetesの名前解決を確認する](https://varu3.hatenablog.com/entry/2018/05/24/200311)
* k8s Deployment理解   | [Kubernetes Deploymentを理解する](https://qiita.com/komattaka/items/bd1d8d32f6cb24a32f53)
* Podの終了詳細        | [Kubernetes: 詳解 Pods の終了](https://qiita.com/superbrothers/items/3ac78daba3560ea406b2)
* Serviceの概要        | [Kubernetes "サービス"の概要についての自習ノート](https://qiita.com/MahoTakara/items/d18d8f9b36416353066c)
* kube-DNS挙動         | [Kubernetes1.10 Cluster内DNSの挙動確認](https://qiita.com/sugimount/items/1873d9d332a25f5b0167)
* k8s API community    | [API Conventions](https://github.com/kubernetes/community/blob/master/contributors/devel/api-conventions.md)
* Deploymentの仕組み   | [Kubernetes: Deployment の仕組み](https://qiita.com/tkusumi/items/01cd18c59b742eebdc6a)

## k8s reference
* k8s入門              | [Kubernetes 初心者の超簡単まとめ](https://reboooot.net/post/hello-k8s/)
* k8sチュートリアル    | [Kubernetesのチュートリアルをやる](https://www.kaitoy.xyz/2017/10/11/goslings-on-kubernetes-cont/)
* k8sデバッグ          | [Kubernetes: アプリケーションのデバッグ方法 (kubectl exec など)](https://qiita.com/tkusumi/items/a62c209972bd0d4913fc)
* k8sコマンド一覧      | [kubectlコマンドの使い方(1.2)](https://qiita.com/hana_shin/items/ef1a20239001ac83a78d)
* k8sチートシート      | [kubectlチートシート](https://qiita.com/mumoshu/items/19392308cdadf8667fdd)
* Service作成          | [Kubernetes 1.10.4でServiceを作成してクラスタ外にサービスを公開](http://ossfan.net/setup/kubernetes-07.html)
