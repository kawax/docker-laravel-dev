# DockerでHomestead並の開発環境を作る

自分で使う用なので他人が使うことやこのまま本番で使うことは想定してない。

LaradockはLaravelと関係ないものまで全部入りすぎて過剰、他人が作ったものはphpとmysqlしかなくて足りない。  
cron、キュー、Horizon、ブロードキャストまで使えるちょうどいい環境が目標。

本番はForge使えばDockerより楽。本番もDockerで運用する規模ならもっと調整が必要。

docker-composeのコマンドが長くなるのはMakefileで短縮。

## 環境
- ホスト：Mac
- PHP, composer, node.js関連はホスト側にインストール済。ホストでやれば十分なことはホストでやる。
- PhpStorm

## 新規作成
Homesteadはプロジェクト毎にインストールして使ってたのでDockerでも同様の使い方を目指す。

laravel newから始めたい。
```
laravel new my-project && cd $_
```

必要なファイルをコピー。ローカルで保存済の前提。

- docker-compose.yml
- Makefile
- docker/

/etc/hostsの設定。  
大量のプロジェクトではhostsが一番面倒な所だけどDockerだとBonjourが使いにくそう。  
代わりにこれで楽に設定できた。  
https://github.com/cbednarski/hostess  
`brew install hostess`でもインストール可能。

ディレクトリ名.test、`my-project.test`で登録。
```
make hosts
```

docker-compose up -d
```
make upd
```

open http://my-project.test:8000

```
make open
```

docker-compose down
```
make down
```

## MySQL
Sequel Proから接続するための設定はHomesteadと同じ。

- Host: 127.0.0.1
- User: homestead
- Password: secret
- Database: homestead
- Port: 33060

.envでは
```
DB_HOST=mysql
DB_PORT=3306
```

データはプロジェクト内`docker/storage/mysql/`に保存。

## Redis
.env
```
CACHE_DRIVER=redis
QUEUE_CONNECTION=redis
REDIS_HOST=redis
```

データはプロジェクト内`docker/storage/redis/`に保存。

memcachedはない。キャッシュもredisを使う。

## composer
基本的にはホスト側でやればいいけどキャッシュなどを共有してるのでDocker内で実行しても速いはず。
素のcomposerだと遅い。日本語のDocker+Laravelの記事ではインストールに時間かかると書いてることが多いけどcomposer高速化する方法を知らないだけ。

```
volumes:
      - ~/.composer:/root/.composer
```

install
```
make ci
```

update
```
make cu
```

## コンテナ内へ

```
make sh
```

コンテナ内でしか動かないartisanコマンドの実行などに使えるけどMakefileに増やしたほうが早い。

## cron
docker-compose.ymlではコメントにしてるので使うならコメントオフにして有効化。

## キュー
workerかhorizonどちらかのみ有効化する。

## ブロードキャスト
websocketsを有効化。

https://github.com/beyondcode/laravel-websockets

## メール
Mailfogはない。Telescopeで十分なはず。

# https
これでhttpsにはできるけどこれで作られる`signed.crt`がキーチェインに追加できないので「保護された通信」にならない。
https://github.com/SteveLTN/https-portal
Homesteadではcrtを追加すれば保護されるのでService WorkerやWebPushも動く。

## その他
MakefileやDockerfileはプロジェクト毎に必要なら修正する想定。
Docker imageは公式からなので修正しやすい。

Makefileのインデントはタブ
.editorconfig
```
[Makefile]
indent_style = tab
```

## 注意点
複数プロジェクトで同時に起動しないようにする。
portエラーで起動できないだろうけど。
