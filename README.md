# OLAP - Data Warehouse 

Este repositorio contiene los archivos necesarios para diseñar un simple data warehouse. Trabajo práctico final del curso 72.54 - OLAP y Explotación de Datos @ ITBA. 

## Instalación 

 Aunque probablemente no se utilice Docker en un DW real, para los fines de la asignatura es muy útil para tener dependencias separadas y facilitar la configuración.

 ```
CSV_PATH="/path/to/recorridos-realizados-2023"
sudo docker run --name olap-postgis -e POSTGRES_PASSWORD=password -e CSV_PATH=$CSV_PATH -d -p 5432:5432 -v $CSV_PATH:/csvfiles postgis/postgis
```
Para conectarse a la base de datos, utilizar `psql` con contraseña `password`. 
```
psql -h localhost -p 5432 -U postgres -W
```

## Datasets Utilizados

Utilizamos los siguientes datasets para realizar este trabajo. Será necesario colocar los archivos `.csv` en el volumen montado en el contenedor de Docker.

1. [Barrios](https://data.buenosaires.gob.ar/dataset/barrios/resource/juqdkmgo-191-resource) (`barrios.csv`)
2. [Comunas](https://data.buenosaires.gob.ar/dataset/comunas) (`comunas.csv`)
3. [Usuarios 2023](https://data.buenosaires.gob.ar/dataset/bicicletas-publicas/resource/e045c98a-ec53-4517-8859-4b36e15b152e) (`usuarios_2023.csv`)
4. [Bicicleteros](https://data.buenosaires.gob.ar/dataset/bicicleteros-via-publica/resource/juqdkmgo-241-resource) (`bicicleteros.csv`)
5. [Trips 2023](https://data.buenosaires.gob.ar/dataset/bicicletas-publicas/resource/ff671909-6860-4398-8d0a-8f2389cb2780) (`trips_2023.csv`)

