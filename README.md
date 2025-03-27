# Servicios Web CRUD para tabla en MSSQLServer

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
docker run -e 'ACCEPT_EULA=Y' -e 'SA_PASSWORD=YourPassword123!' \
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
```sh
sqlcmd -S localhost -U sa -P YourPassword123!
```

# Probar servicios web

## Prerequisitos

- Se ejecutó previamente el programa *PythonSQLServerCrearTabla.py*, donde se creó la tabla y se agregaron los registros


### Ejecución de servidor de servicios web

Ejecuta el siguiente comando en la terminal de tu **GitHub Codespace**:

```sh
cd web\ services/
python CRUDServer.py

```

### Ejecución de cliente en Python que consume servicios

Abra **otra** terminal (no cierre la terminal que está ejecutando el servidor), y ejecute el siguiente comando:
```sh
cd web\ services/
python testWS.py
```

### Correr servidor web
Modifique la siguiente línea en *index.html* para actualizar la dirección correcta de los servicios web
```JavaScript
const apiUrl = "http://localhost:2025/test";
```

De nuevo, abra **otra** terminal (no cierre la terminal que está ejecutando el servidor), y ejecute el siguiente comando:
```sh
python -m http.server 5500 --directory static
```

