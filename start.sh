# shellスクリプトファイルの最初にかく､おまじないみたいなもの
#! /bin/sh

# Dockerfile上では条件分岐がやりにくいので､
# Dockerfileで実行を指定したこのshellスクリプトファイル内で条件分岐を行っている
if [ "${RAILS_ENV}" = "production" ]
then
  # railsではcssやjsをひとまとめに読み込んでhtmlファイルにわたす
  # 以下のコマンドは､ひとまとめに読み込むコマンド
  # ローカルのときは､自動でやってくれるのでやんなくていい
  # 本番環境のときは以下のコマンド打って手動で実行しないといけない
  bundle exec rails assets:precompile
fi

# railsサーバーを起動します
# ポートは､環境変数PORTに値が入ってたら､その値を使う : 入ってなければ3000番ポートを使う
# IPアドレスは0.0.0.0(どこからのIPアドレスもOK)
bundle exec rails s -p ${PORT:-3000} -b 0.0.0.0

# 補足
# 今回のように､dockerfile内でshellスクリプトを実行して､
# shellスクリプトファイル内で条件分岐を行うのはよくやる｡

# 条件分岐して､大きく違う処理を行いたいときは､そもそも環境ごとにdockerfileを分けて作ったりする
# 今回なら､ローカルと本番環境で別々のDockerfileを作るっていうことだね
