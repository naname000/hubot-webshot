# Hubot-webshot

[![Build Status](https://travis-ci.org/naname000/hubot-webshot.svg?branch=master)](https://travis-ci.org/naname000/hubot-webshot)

ウェブサイトのスクリーンショットを撮影するHubotのスクリプトです。

## Description

Hubotがウェブサイトのスクリーンショットを撮影、imgurにアップロードを行い、アップロード後のURLを発言します。

***DEMO:***

![Demo](https://qiita-image-store.s3.amazonaws.com/0/102985/001ea750-1954-53ee-7615-cd8d9d6e0f02.png)

## Usage

以下の発言をするとhubotが各種の動作を行います。

- webshot __keyword__  
キーワードに応じたスクリーンショットを撮影します。  
- webshot add __keyword URL__  
キーワードをURLと共に登録します。  
- webshot add __keyword URL options__  
利用可能なオプションはtop left width heightです。  
オプション名と値をコロン区切りで指定します。例: (top:10)  
- webshot __URL__  
一度だけスクリーンショットを撮影します。  

詳しくは hubot help webshot と発言してhubotに聞いてください。

## Requirement

データベースが必要です。PostgreSQLで動作確認しています。  
他にもMySQL,SQLite,MSSQLに対応しています。が、動作確認していません。  
詳しくは http://docs.sequelizejs.com/en/v3/ を御覧ください。

[imgur](http://imgur.com/)のアカウントが必要です。
imgur APIの利用登録が必要です。
キャプチャした画像をアップロードする際に利用します。

## Installation

1. hubotを運用しているディレクトリで以下のコマンドを実行します。

   `$ npm install naname000/hubot-webshot --save`
-----
2. hubotを運用しているディレクトリ内にあるexternal-scripts.jsonファイルにhubot-webshotを追加します。

````json
[
 ".....",
 "hubot-webshot"
]
````
-----
3. 以下の環境変数を設定します。

- __DATABASE_URL__  
データベースURL 例: postgres://user:pass@example.com:5432/dbname
- __IMGUR_USERNAME__  
imgurアカウントのユーザ名
- __IMGUR_PASSWORD__  
imgurアカウントのパスワード
- __IMGUR_CLIENT_ID__  
imgurアカウントのクライアントID。
詳しくは http://api.imgur.com/ を御覧ください。

hubotを実行するプロセスへ環境変数を設定します。実行環境に合わせて設定して下さい。以下は一例です。

   `$ DATABASE_URL=postgres://user:pass@example.com:5432/dbname IMGUR_USERNAME=**** IMGUR_PASSWORD=**** IMGURL_CLIENT_ID=**** $(npm bin)hubot`

-----
<img src="http://i.imgur.com/oXscx5J.png" width="320px" />
herokuでの設定画面例です。

## etc

データベース接続設定はconfigディレクトリ(./node_modules/hubot-webshot/config/)にあるconfig.jsonへデータベース接続情報を記述することも可能です。連想配列のキーはNODE_ENVの値を参照します。しかしこの方法は _非推奨_ です。

## Author

[NANAME](https://about.me/naname/)
