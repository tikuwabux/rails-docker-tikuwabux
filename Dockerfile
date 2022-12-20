# ベースのイメージをruby2.7に指定
FROM ruby:2.7

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
