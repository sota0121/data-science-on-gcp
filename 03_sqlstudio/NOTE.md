# 本章の概要

- データ理解に必要な作業として「探索的データ分析」と「ダッシュボード構築」がある
- 探索的データ分析は5章で扱う。本章はダッシュボード
- ダッシュボードは…
  - エンドユーザーや意思決定者を対象とした、対話的に操作可能なレポートである
  - データサイエンティストの為のものではない
  - 新たなモデルを開発するための知見を得ることが目的ではない
  - 既存のモデルの内容を説明することが目的である

![img](img/IMG_4779.jpg)

---

<br>

## ダッシュボードでモデルを説明する

- ダッシュボードの目的は、「モデルがどのように機能しているかをユーザーに理解してもらうこと」である
- そのためには以下の３点に気をつける必要がある。
  - ①：データを正確に表現しているか（誤解を与える表現をしていないか）
  - ②：データそのものだけでなく、その背後にある情報を示すことができているか
    - ダッシュボードを対話的に操作して、ユーザー自身がデータに対する知見や洞察を得ようとするとき特に大事
  - ③：レコメンデーションの根拠となるモデルの振る舞いを十分に説明できるように構成されているか（<font color=red>★特に重要</font>）
- モデルの開発者は、モデルの全体的な評価をする一方で、エンドユーザーはより個別具体的なケースにおいて評価する。評価する粒度が違うのである。したがって、ダッシュボードを対話的に操作することで、そのユーザーが関心のある粒度でモデルを評価できるようにすることが望ましい。

---

<br>


## 最初にダッシュボードを作成する理由

- 目的１：モデル構築に役立つ情報をユーザーから提案してもらうため
  - 高性能なモデルを作るには、データセットの理解が必要。データサイエンティストは、もちろん包括的な視点にたってビジネス課題を分析課題に落とし込むわけだが、エンドユーザーの情報はその補完に役立つ。ダッシュボードとは、モデル構築に役立つアンケートのようなものである。
- 目的２：データが想像通りの内容かどうかは確認するため
  - データ理解のためには、EDAが欠かせないが、目的を明確にもつことが難しい。一方で、ダッシュボードを作るという明確で具体的な目的がもてると、作業が具体化されて良い。また、ユーザ向けに形をつくってくことで、自分自身の理解が促進される。ちょうど、物事を勉強するときにそれを誰かに教えることで、自身の理解もより一層深まるような感じだ。
- 目的３：モデルをリリースした後、ユーザーがモデルを利用する心理的障壁を下げる為
  - モデルをリリースする際は、その説明能力が「ユーザーが使ってくれるかどうか？」といった点において重要である。よくわからないものは使ってくれない。それを補うのがダッシュボードだ。さらに、ダッシュボードとモデルが一緒にリリースされていれば、ユーザーからさらなるアイデアが生まれやすくなる可能性もあり、一石二鳥である。使ってもらえるモデルにするためにダッシュボードが必要。


**その他の注意事項**

- ダッシュボードは、対象分野の専門家や将来のユーザーがよく目にするところに実装するのが良い
- 対象ユーザーや組織ごとに個別のダッシュボードを用意して、1つのツールに全ての情報を詰め込まないようにする

---

<br>


## 正確さ、信頼性、良いデザイン

- モデルに対して誤った解釈を誘導するような表示は避けよう。奇抜な手法は避けて、目的に応じた定番のビジュアライゼーションを選択しよう

<font color=pink>大きく4パターン</font>

- **相関**：2つの変数の関係性を示す
  - 折れ線グラフ、散布図
  - スケールの設定により誤解を与えないか、気をつける
- **時系列**：時間の経過に伴う値の変化を示す
  - 時間軸は水平方向に
  - メモリやラベルではなく、グラフのラインを強調すること
- **地図**：場所ごとの値の変化を示す
  - 関心のある領域を地図上で切り取り、データそのものを大きく表示
  - 地名などのテキストは目立たないように
- **説明的表現**：特定のストーリーを説明するためのレイアウト
  - デザイナー的能力が問われる分野

<br>

**勉強するにはプロの具体例を見るのが一番！**

- おすすめ：[Graphic Detail Blog | The Economist](https://www.economist.com/graphic-detail/)

---

<br>

## Google Cloud SQLにデータを読み込む

（本編：3.4~3.9までをまとめて記載）

- Cloud SQL で MySQL インスタンスを立ててやる理由
  - 今回扱うのが表形式データであるため、選択肢の一つとしてRDB
  - 小規模なデータセットに対して、不定形のクエリを実行する場合にRDBは適している
  - MySQL：幅広いユースケースをカバー、高性能、様々なライブラリが用意されていて、接続が用意
  - Cloud SQLがそもそもMySQLのマネージド・サービス（2021/02時点では、PostgreSQL/SQL Server もサポートされている）

Cloud SDK の Cloud SQL 系コマンド `gcloud sql` のリファレンスは[こちら](https://cloud.google.com/sdk/gcloud/reference/sql)

### Cloud SQL でインスタンスを立ち上げる

- `create_instance.sh` を参照
- `--activation-policy ALWAYS` に関する情報は[こちら](https://cloud.google.com/sql/docs/mysql/start-stop-restart-instance#gcloud)

![img](img/create_instance.png)

<font color=grey>Note: bash上でCloudリソースに命令を出す時は、以下のような感じでgcloudコマンドでアクセストークンをとればいい。</font>

```bash
ACCESS_TOKEN="$(gcloud auth application-default print-access-token)"
curl --header "Authorization: Bearer ${ACCESS_TOKEN}" \
     --header 'Content-Type: aplication/json' \
     --data ...
```
って書いてたけど、以下のエラーが出るので、通常通りアクセスキーのJSONファイルのパスを環境変数 `GOOGLE_APPLICATION_CREDENTIALS` に設定して実行するべきか。

```bash
ERROR: (gcloud.auth.application-default.print-access-token) Could not automatically determine credentials. Please set GOOGLE_APPLICATION_CREDENTIALS or explicitly create credentials and re-run the application. For more information, please see https://cloud.google.com/docs/authentication/getting-started
```

### MySQLへのアクセス制御

- MySQLのデータベースに接続して、各種コマンド（`mysql`）を実行するには、接続元のマシンを認可する必要がある
- MySQLは認可するネットワークを管理しているようで、そのリストを変更する（ホワイトリストに新たに自身のIPを追加する）
- 自身のIPアドレスを返してくれる `https://ipecho.net` を利用する
- `gcloud sql instances patch flights ...`
  - [references](https://cloud.google.com/sdk/gcloud/reference/sql/instances/patch)
  - このコマンドは、CloudSQLインスタンスの設定をUpdateするもの
- `wget -q0 - https://ipecho.net/plain`
  - このコマンドにより自身のIPアドレスを返す

```bash
gcloud sql instances patch flights \
    --authorized-networks $(wget -q0 - http://ipecho.net/plain)/32
```

![img](img/authorize_network.png)


> ### ■ MySQL におけるインデックス
> <br>
> 
> - `create_table.sql` 末尾で追加している `INDEX(xxx)` は処理の高速化のためのもの
> - ざっくりいうと、検索処理を高速化するための手段である
> - 指定したカラム（複数可）に対してINDEXの命令を記述するとその列のインデックスが作られる
> - インデックスとは、各レコードの位置情報をツリー構造などで保持し、任意レコードの探索計算時間を削減する取り組み、みたいなものと理解した
> - インデックスを作ると、メモリを食う。追加処理が時間かかる。といったデメリットがある模様。
> - インデックスをはるべきカラムは、「よくWhere句の条件に使われる」「大量にレコードがあるうちの少しだけ抽出したい場合が多い」などの特性に当てはまるものが望ましい


### MySQLにテーブルを作る

MySQL付属のmysqlコマンドをつかって、`.sql`ファイルを取り込むことで、SQLクエリを実行できる。ただし、その際にMySQLインスタンスのIPアドレスを指定しなければならない。

<br>

※結論：`create_table.sh`を実行すればいける

<br>

> ### `mysql` 使い方
> <br>
> 
> - login: mysql ... (in terminal)
> - in mysql cli
>   - use {table_name};
>   - describe {instance}
>   - SQL
> - ★注意
>   - 行末尾は `;` をつけよう
>   - 行末尾に `;` がなければ、ずっと入力が終わらない `->` ってずっと出てくる。そんなときは、`;` を入力すれば終わる。
>   - `mysql` CLI を抜けるには `quit` と入力する

<br>

**CloudSQLインスタンスのアドレスを取得**

```bash
gcloud sql instances describe \
    flights --format="value(ipAddresses.ipAddress)"
```

**mysqlコマンド: sqlファイルを読み込んでクエリ実行**
```bash
MYSQLIP=$(gcloud sql instances describe \
    flights --format="value(ipAddresses.ipAddress)")
mysql --host=$MYSQLIP --user=root \
    --password --verbose < create_table.sql

```

とりあえず、ローカルのmysqlコマンドでCloudSQLのインスタンス上のテーブルを操作する。以下のコマンドでログイン（パスワードは未設定）

```bash
mysql --host=$MYSQLIP --user=root

# -----

mysql> use bts;
Database changed
mysql> describe flights;
+-----------------------+-------------+------+-----+---------+-------+
| Field                 | Type        | Null | Key | Default | Extra |
+-----------------------+-------------+------+-----+---------+-------+
| FL_DATE               | date        | YES  | MUL | NULL    |       |
| UNIQUE_CARRIER        | varchar(16) | YES  |     | NULL    |       |
| AIRLINE_ID            | varchar(16) | YES  |     | NULL    |       |
| CARRIER               | varchar(16) | YES  |     | NULL    |       |
| FL_NUM                | int(11)     | YES  |     | NULL    |       |
| ORIGIN_AIRPORT_ID     | varchar(16) | YES  | MUL | NULL    |       |
| ORIGIN_SEQ_ID         | varchar(16) | YES  |     | NULL    |       |
| ORIGIN_CITY_MARKET_ID | varchar(16) | YES  |     | NULL    |       |
| ORIGIN                | varchar(16) | YES  |     | NULL    |       |
| DEST_AIRPORT_ID       | varchar(16) | YES  |     | NULL    |       |
| DEST_AIRPORT_SEQ_ID   | varchar(16) | YES  |     | NULL    |       |
| DEST_CITY_MARKET_ID   | varchar(16) | YES  |     | NULL    |       |
| DEST                  | varchar(16) | YES  |     | NULL    |       |
| CRS_DEP_TIME          | int(11)     | YES  |     | NULL    |       |
| DEP_TIME              | int(11)     | YES  | MUL | NULL    |       |
| DEP_DELAY             | float       | YES  | MUL | NULL    |       |
| TAXI_OUT              | float       | YES  |     | NULL    |       |
| WHEELS_OFF            | int(11)     | YES  |     | NULL    |       |
| WHEELS_ON             | int(11)     | YES  |     | NULL    |       |
| TAXI_IN               | float       | YES  |     | NULL    |       |
| CRS_ARR_TIME          | int(11)     | YES  |     | NULL    |       |
| ARR_TIME              | int(11)     | YES  |     | NULL    |       |
| ARR_DELAY             | float       | YES  | MUL | NULL    |       |
| CANCELLED             | float       | YES  |     | NULL    |       |
| CANCELLATION_CODE     | varchar(16) | YES  |     | NULL    |       |
| DIVERTED              | float       | YES  |     | NULL    |       |
| DISTANCE              | float       | YES  |     | NULL    |       |
+-----------------------+-------------+------+-----+---------+-------+
27 rows in set (0.03 sec)

mysql> select distinct(FL_DATE) from flights;
Empty set (0.03 sec)

```

### ユーザーパスワードを変更しておく

```bash
gcloud sql users set-password [USER_NAME] \
   --host=[HOST] --instance=[INSTANCE_NAME] --prompt-for-password

# ---

Instance Password: 
Updating Cloud SQL user...done.  
```

で変更したつもりが、どうも上手く行かない。ちなみに、この後いろんな場面で `Enter password:` と出たときに、（設定変更したつもりの）パスワードを入力しても、アクセス拒否エラーになるのに、何も入力せずにEnter押すと、行ける。

つまり、「パスワード変更できてない」「パスワード変更はできているけど、期待したパスワードになっていない」が考えられる。おそらく後者かと。原因追求は一旦やめて、先に進む。


### テーブルへのデータインポート

以下の作業をする

- ローカルの`mysqlimport`コマンドでMySQLにCSVを取り込む
- CloudStorage上のファイルをローカルにコピーする
  - `mysqlimport` はローカルのファイルしか扱えないから
- CSVファイルのbasenameを`flights`に変更する
  - `mysqlimport`はCSVファイルの名前から、インポート先のテーブルを推測するから


※とりあえず：`populate_table.sh`を実行すればいける

```bash
chmod +x ./populate_table.sh
./populate_table.sh {BUCKET_NAME}
```

結果
![img](img/populate_table.png)


たしかにデータが入っているか確認する

```bash
mysql --host=$MYSQLIP --user=root --password

mysql> use bts;
mysql> describe flights;

# -- table description is shown --

mysql> select distinct(FL_DATE) from flights;
```

---

<br>

## とてもシンプルな第一のモデル

### モデルの概要

- 出発遅延時間が15分以上の場合は会議をキャンセルする
- この判断が正しかったかどうかは、到着遅延時間が15分を超えたかどうかで決まる


### 混同行列

到着遅延時間が15分を超えた場合と超えなかった場合の2クラス分類問題とする。

||到着遅延 < 15分|到着遅延 ≧ 15分|
|---|---|---|
|会議をキャンセルしなかった（陰性）|正解（真陰性）|偽陰性|
|会議をキャンセルした（陽性）|偽陽性|正解（真陽性）|


<font color=blue>※通常、稀な方や稀であってほしい方を陽性とする。（例：PCR検査陽性）</font>


### 結果を算出する

シンプルなクエリで計算可能

`contingency.sh` と `contingency.sql` を参照（唯一の説明変数、到着遅延を20分とした場合の処理を記述している）

||到着遅延 < 15分|到着遅延 ≧ 15分|
|---|---|---|
|会議をキャンセルしなかった（陰性）<br>（出発遅延 < 20）|<font size=3>**1065027**</font><br>正解（真陰性）|<font size=3>**69519**</font><br>偽陰性|
|会議をキャンセルした（陽性）<br>（出発遅延 ≧ 20）|<font size=3>**26182**</font><br>偽陽性|<font size=3>**195890**</font><br>正解（真陽性）|


### 地道な作業だが、機械学習の考え方そのもの

ここでは、一つのパラメータを手作業で最適化していった。考え方自体は機械学習と本質的に違いはない。これよりもっとパラメータ増えて、システマティックに最適化するようなのが、機械学習らしい機械学習って感じ。



