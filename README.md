# Sinatra
Sinatraには私が作成した非常にシンプルなメモアプリが入っています。

# 使い方
はじめにPostgreSQLにデータベースと`memo_db`テーブルを作成する必要があります。
```
create db memo_db;
```
```
create table memo_db(id integer not null,title text not null,body text, primary key(id));
```

任意のディレクトリにこのアプリケーションを `git clone` してダウンロードしてください。
```
git clone https://github.com/t-suga-dev/sinatra.git
```
`sinatra_memo`ディレクトリに移動して`bundle install`をして起動に必要なGemをインストールしてください。
```
cd sinatra_memo
bundle install
```
`sinatra.rb`を実行してください。
```
bundle exec ruby sinatra.rb
```
起動後に http://localhost:4567 にアクセスしてください。
