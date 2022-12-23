# ベースのイメージをruby2.7に指定
# FROM ruby:2.7
#=> docker-compose exec web bundle exec rake test 実行時のYour Ruby version is 2.7.7, but your Gemfile specified 2.7.5解消のため書き換え
# 解決案①
FROM ruby:2.7.5
# => エラー解決!

# production時用の処理を追加1
# 環境変数 RAILS_ENV を定義し､それにproductionという値を格納
# 後に実行を指定する/start.sh内で､条件分岐の条件として用いる
ENV RAILS_ENV=production

# 必要なライブラリをインストール
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
  && apt-get update -qq \
  && apt-get install -y nodejs yarn

# dockerの作業ディレクトリを/appと指定
WORKDIR /app
# ローカルの./srcファイルを､dockerの作業ディレクトリである/appにコピー
COPY ./src /app
# ruby関連のライブラリ(gemのこと)のインストール先をvendor/bundleに指定｡そのご､bundle installでインストール
RUN bundle config --local set path 'vendor/bundle' \
  && bundle install

# production時用の処理を追加2
# start.sh(ローカル上のファイル)を /start.sh(ルートディレクトリ直下のDocker上のファイル)にコピー
COPY start.sh /start.sh
# /start.sh(ルートディレクトリ直下のDocker上のファイル)にコマンドの実行権限をもたせる
RUN chmod 744 /start.sh
# /start.shファイルを実行(Shellの実行)
CMD ["sh", "/start.sh"]
