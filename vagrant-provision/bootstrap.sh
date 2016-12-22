# Installation de softs de base

aptitude -y install vim
aptitude -y install python-pip
aptitude -y install python-virtualenv
aptitude -y install python-imaging python-yaml libproj0
aptitude -y install libgeos-dev python-lxml libgdal-dev python-shapely

# Répertoire d'installation de mapproxy
mkdir /opt/mapproxy/
cd /opt/mapproxy
virtualenv --system-site-packages venv_mapproxy
source venv_mapproxy/bin/activate
pip install Pillow
pip install MapProxy

# Install apache + wsgi
apt-get -y install apache2
apt-get -y install libapache2-mod-wsgi

# Copier la conf apache + mapproxy

# Conf mapproxy (pointe vers python --> /opt/mapproxy)
cp -f /vagrant/vagrant-provision/conf/apache/mapproxy.conf /etc/apache2/conf-available/
# Conf apache2 (sortir du www)
cp -f /vagrant/vagrant-provision/conf/apache/apache2.conf /etc/apache2/
# Conf par défaut pointe sur ${dir_vagrant}/html
cp -f /vagrant_sync/conf/apache/000-default.conf /etc/apache2/sites-available/

# Pris en charge des logs mapproxy

cp /vagrant_sync/conf/log.ini /opt/mapproxy/
mkdir /var/log/mapproxy
touch /var/log/mapproxy/source-requests.log /var/log/mapproxy/mapproxy.log
chown -R www-data:www-data /var/log/mapproxy/

# Répertoire de cache propriétaire user apache (www-data)

mkdir cache_data
chown -R www-data:www-data cache_data

# redémarrage apache

a2enconf mapproxy
service apache2 restart
