echo "Domain: "
read domain
echo "BD PASS: "
read bdpass
apt install -y nano curl mc git rpl
curl -sL https://deb.nodesource.com/setup_7.x | sudo -E bash -
apt install -y build-essential nginx php-fpm php-mcrypt git php-mysql nodejs redis-server php-xml php-mbstring nodejs mysql-server php-mysql php-bcmath php-curl php-gd letsencrypt
echo "cgi.fix_pathinfo=0" >> /etc/php/7.0/fpm/php.ini
echo "[client]
user=root
password=$bdpass" > /root/.my.cnf
mkdir /var/www/$domain
cd /var/www/$domain
mkdir public
cd public
wget adminer.org/latest.php
echo "<?php
phpinfo();
?>" > index.php
chown -R www-data:www-data /var/www/$domain
service nginx stop
service php7.0-fpm restart
letsencrypt certonly --standalone -d $domain
cd /root/
wget authst.me/nginxssl.conf
sed "s/bichruletka.ru/$domain/g" nginxssl.conf > /etc/nginx/sites-available/$domain
ln -s /etc/nginx/sites-available/$domain /etc/nginx/sites-enabled/
service nginx restart
