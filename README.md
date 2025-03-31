# Servicios Web CRUD reto Equipo 1

Este repositorio contiene un ejercicio de conexión a una instancia de **SQL Server** que corre dentro de un contenedor Docker en **GitHub Codespaces** utilizando el paquete **pymssql** para Python.

## Prerequisitos

Antes de comenzar, asegúrate de tener:

- **GitHub Codespaces** habilitado.
- **Docker** ejecutándose en tu Codespace.
- **Python 3** instalado.
- **pymssql** instalado en tu entorno Python.

### Iniciar la instancia de SQL Server en Docker

Para iniciar una instancia de **SQL Server** en un contenedor Docker, ejecuta el siguiente comando en la terminal de tu **GitHub Codespace**:

```sh
docker run -e 'ACCEPT_EULA=Y' -e 'SA_PASSWORD=Pioner0s:D' \
   -p 1433:1433 --name sqlserver -d mcr.microsoft.com/mssql/server:2022-latest
```

### Instalar sqlcmd
```sh
sudo apt update
sudo apt install mssql-tools unixodbc-dev
echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc
source ~/.bashrc
```
### Usar sqlcmd para conectarse desde la terminal
Crear base de datos y despues acceder a la base de datos por sqlcmd
```sh
sqlcmd -S localhost -U sa -P Pioner0s:D -i ./init_db.sql
sqlcmd -S localhost -U sa -P Pioner0s:D -d Data
```

# Probar servicios web

### Ejecución de servidor de servicios web

Ejecuta el siguiente comando en la terminal de tu **GitHub Codespace**: Das acceso a tu puerto haciendolo publico y con esto podras usar los servicios establecidos en el programa para la modificacion de la tabla.

```sh
python ServiciosWeb.py

```
### Ejemplo de servicio

Con la aplicacion de postman pegaremos la url que nos otorgan y asi podremos usar 
Get, Post, Delete, Put

```sh
Get = URL / table / NombreBaseDeDatos, con esto podras ver la base de datos entera
Get = URL / table / Nombre_tabla, podras ver las talas deseadas
Get = URL / table / Nombre_tabla / Llave_primaria, con esto podras ver registros por id
Post = URL / table / Nombre_tabla, se debera insertar datos en formato Json, ejemplo
{
    "id":5,
    "name": "Alberto",
    "email": "hojo@hojo"
}
Put = URL / table / Nombre_tabla / Llave, podras actulizar los datos de cualquier usuario, se debe insertar en formato Json, ejemplo,
{
    "name": "Alberto",
    "email": "hojo@hojo"
}
Delete = URL / table / Nombre_tabla / Llave, podras borrar informacion por usuario.
```


