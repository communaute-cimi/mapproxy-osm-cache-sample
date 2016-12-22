# Exemple de proxy "données spatiales" avec mapproxy (vagrant)

## Intro

Ce vagrant file créé une instance de mapproxy configuré pour aller chercher des tuiles sur openstreetmap.org et les stocker dans un cache.

Autre caractéristique de mapproxy, permettre la transformation des formats à partir d'un ou plusieurs caches, ce qui est fait dans la démo, OSM est fourni en : 
* WMS (webmercator et 2154)
* WMTS (webmercator)
* TMS (webmercator)

Chaque tuile est mise en cache pour une durée indéterminée, c'est par des scripts de purge que l'on peut gérer le cache (cleanups)

## Utilisation

[Vagrant](https://www.vagrantup.com/) est utilisé pour automatiser la création de la VM et le provisionning.

```sh
# Prévoir 5mn lors du premier démarrage.
vagrant up
```

Une fois la VM lancée vérifier le fonctionnement:
* [La carte](http://localhost:8082/) : 
* La [démo mapproxy](http://localhost:8082/mapproxy/demo/) qui permet de tester les différentes configurations : 

## Moissonnage (seeding)

Le moissonnage permet de récupérer et mettre en cache des tuiles en fonction de différents critères comme la couverture, ou niveau d'échelle. L'exemple suivant concerne une zone (Etrechy 91) et quelques niveaux de zoom (grande échelle).

```sh
sudo -u www-data /opt/mapproxy/venv_mapproxy/bin/mapproxy-seed -f /vagrant_sync/conf/mapproxy-osm.yaml -s /vagrant_sync/conf/seed-osm.yaml --seed=seed_etrechy
```

## Sous le capôt

### répertoire mapproxy
Le répertoire de base : /opt/mapproxy
Environnement virtuel python : /opt/mapproxy/venv_mapproxy
Cache : /opt/mapproxy/cache_data

### Fichiers de configuration

### Bind python apache

## Le script de bootstrap

```sh
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
```

## Notes

### Fichier de configuration mapproxy
Le fichier de configuration permettra à apache de faire le lien entre la requête http et l'accès à mapproxy

Créer un fichier mapproxy.conf dans /etc/apache2/conf.available/
Contenant
```sh
# If not loaded elsewhere
LoadModule wsgi_module modules/mod_wsgi.so

WSGIScriptAlias /mapproxy $conf/mapproxy-config.wsgi

WSGIPythonPath /home/vagrant/mapproxy/lib/python2.7/site-packages

<Directory /home/vagrant/mapproxy/lib/python2.7/site-packages/mapproxy/>
      Order deny,allow
      Require all granted
</Directory>
```

Modifier les chemins le cas échéant...

### Permettre la sortie du www
Modifier apache2.conf
```sh
<Directory />
        Options FollowSymLinks
        AllowOverride None
        Require all granted
</Directory>
```

## liens
https://httpd.apache.org/docs/2.4/fr/mod/core.html
https://mapproxy.org/docs/latest/
https://doc.ubuntu-fr.org/tutoriel/virtualhosts_avec_apache2#configuration_des_hotes_virtuels

