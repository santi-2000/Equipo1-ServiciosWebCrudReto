import pymssql

# Configuración de la conexión
server = "localhost"
port = 1433
database = "master"
username = "sa"
password = "YourPassword123!"

try:
    # Conectar a SQL Server
    conn = pymssql.connect(server=server, port=port, user=username, password=password, database=database)
    cursor = conn.cursor()

    # Crear tabla de ejemplo
    cursor.execute("CREATE TABLE Test (id INT PRIMARY KEY, name NVARCHAR(50),  email NVARCHAR(100) )")
    cursor.execute("INSERT INTO Test (id, name, email) VALUES (1, 'Alice', 'x@com'), (2, 'Bob', 'z@x.com')")
    conn.commit()

    # Consultar los datos
    cursor.execute("SELECT * FROM Test")
    for row in cursor.fetchall():
        print(row)

except Exception as e:
    print("Error:", e)

finally:
    conn.close()
