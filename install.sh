echo "Domain: "
read domain
echo "BD PASS: "
read bdpass
echo mysql-server-5.7 mysql-server/root_password password $dbpass | debconf-set-selections
echo mysql-server-5.7 mysql-server/root_password_again password $dbpass  | debconf-set-selections
apt install -y nano curl mc git rpl
apt install -y build-essential nginx php-fpm php-mcrypt git php-mysql redis-server php-xml php-mbstring mysql-server php-mysql php-bcmath php-curl php-gd letsencrypt
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
