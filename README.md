Laravel(blade)をdockerで動かす構成のテンプレート

## Setup
1. コメントアウトする  
Dockerfile :
```Dockerfile
# COPY /myapp/composer.json /myapp/composer.lock ./
# COPY ./myapp/ .
# RUN composer dump-autoload --optimize

# COPY --from=composer /var/www/html/vendor ./vendor
# COPY --from=composer /var/www/html/bootstrap/cache ./bootstrap/cache
```
yml:docker-compose.yml :
```yml
# - ./myapp/public:/var/www/myapp/public
# - ./myapp/storage:/var/www/myapp/storage

# - /var/www/myapp/vendor/
# - /var/www/myapp/bootstrap/cache
```

2. コンテナを起動
```
docker-compose up
```

3. myappコンテナにatachしてLaravelをインストール
```
composer create-project --prefer-dist laravel/laravel . "10.*"
```

4. コンテナ再起動  
1.のコメントアウトを元に戻してコンテナを再起動する

6. パーミッションを変更する
```
cd ..
chmod 777 myapp -R
```

7. Laravelの初期設定（タイムゾーン、言語）  
config/app.php :
```php
'timezone' => 'Asia/Tokyo',
'locale' => 'ja',
```
.env :
```:.env
APP_NAME=myapp
```

8. DB設定とマイグレーション  
.env :
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