# Proxy/cache OSM avec mapproxy

Exemple de proxy cache de tuiles OSM

```sh
vagrant ssh # aller dans la VM
```

## Proxy

Dans la VM pour démarrer le proxy

```sh
source mapproxy/bin/activate
cd mymapproxy
sudo mapproxy-util serve-develop --bind 0.0.0.0:8080 mapproxy-osm.yaml
[info]  * Running on http://0.0.0.0:8080/ (Press CTRL+C to quit)
[info]  * Restarting with reloader
```

##Moissonnage (seeding)

```sh
source mapproxy/bin/activate
sudo mapproxy-seed -f mapproxy-osm.yaml -c 4 seed-osm.yaml
```

## La démo 

Dans le système hôte (le proxy doit être démarré) : http://localhost:8080/demo/

