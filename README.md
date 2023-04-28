Laravel(blade)をdockerで動かす構成のテンプレート

## Setup
1. コメントアウトする
```Dockerfile:Dockerfile
# COPY /myapp/composer.json /myapp/composer.lock ./
# COPY /myapp/vendor /var/www/myapp/vendor
# COPY /myapp/bootstrap/cache /var/www/myapp/bootstrap/cache

# COPY --from=composer /var/www/myapp/vendor ./vendor
# COPY --from=composer /var/www/myapp/bootstrap/cache ./bootstrap/cache
```
```yml:docker-compose.yml
# - ./myapp/public:/var/www/myapp/public
# - ./myapp/storage:/var/www/myapp/storage

# - /var/www/myapp/vendor/
# - /var/www/myapp/bootstrap/cache
```

2. docker-compose up
3. myappコンテナにatachしてLaravelインストール
```
composer create-project --prefer-dist laravel/laravel . "9.*"
```

4. docker-compose downして1.のコメントアウトを元に戻す
5. docker-compose up
6. パーミッションを変更する
```
cd ..
chmod 777 myapp -R
```

7. Laravelの初期設定（タイムゾーン、言語）
```php:app.php
'timezone' => 'Asia/Tokyo',
'locale' => 'ja',
```
```:.env
APP_NAME=myapp
```

8. DB設定とマイグレーション
```:.env
DB_CONNECTION=mysql
DB_HOST=template-laravel-blade-on-docker-mysql-1
DB_PORT=3306
DB_DATABASE=laravel_myapp
DB_USERNAME=root
DB_PASSWORD=password
```
```
php artisan migrate
```