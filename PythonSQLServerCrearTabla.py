from flask import Flask, request, jsonify
from flask_cors import CORS
import pymssql

app = Flask(__name__)
CORS(app)

# Database configuration
server = "localhost"
port = 1433
database = "Data"
username = "sa"
password = "Pioner0s:D"

# Database connection function
def get_connection():
    return pymssql.connect(server=server, port=port, user=username, password=password, database=database)

@app.route('/Data', methods=['GET'])
def get_database():
    conn = get_connection()
    cursor = conn.cursor(as_dict=True)

    # Obtener todas las tablas de la base de datos
    cursor.execute("SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE = 'BASE TABLE'")
    tables = [row['TABLE_NAME'] for row in cursor.fetchall()]

    database_data = {}

    # Obtener los datos de cada tabla
    for table in tables:
        cursor.execute(f"SELECT * FROM {table}")
        database_data[table] = cursor.fetchall()

    conn.close()
    return jsonify(database_data)

# Ruta general para obtener todos los registros de una tabla
@app.route('/table/<string:table>', methods=['GET'])
def get_all(table):
    if not table.isalnum():  # Evita inyección SQL en nombres de tabla
        return jsonify({'error': 'Nombre de tabla inválido'}), 400

    conn = get_connection()
    cursor = conn.cursor(as_dict=True)
    cursor.execute(f"SELECT * FROM {table}")
    data = cursor.fetchall()
    conn.close()

    return jsonify(data) if data else jsonify({'mensaje': 'No se encontraron registros'}), 404

@app.route('/table/<string:table>/<string:ids>', methods=['GET'])
def get_one(table, ids):
    if not table.isalnum():  # Verifica que el nombre de la tabla es válido
        return jsonify({'error': 'Nombre de tabla inválido'}), 400

    conn = get_connection()
    cursor = conn.cursor(as_dict=True)

    # Separar los valores de la URL en los componentes individuales
    id_values = ids.split(',')

    # Consultar la clave primaria de la tabla especificada
    cursor.execute("""
        SELECT COLUMN_NAME
        FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
        WHERE TABLE_NAME = %s AND CONSTRAINT_NAME LIKE 'PK_%'
    """, (table,))
    
    primary_key_columns = cursor.fetchall()
    
    if len(primary_key_columns) != len(id_values):
        conn.close()
        return jsonify({'error': 'El número de parámetros no coincide con la clave primaria'}), 400

    # Crear el WHERE dinámico para la consulta con los valores de la clave primaria
    where_clause = ' AND '.join([f"{primary_key_columns[i]['COLUMN_NAME']} = %s" for i in range(len(id_values))])
    
    # Ejecutar la consulta con los valores de la clave primaria
    query = f"SELECT * FROM {table} WHERE {where_clause}"
    cursor.execute(query, tuple(id_values))
    
    data = cursor.fetchone()
    conn.close()

    return jsonify(data) if data else jsonify({'mensaje': 'Registro no encontrado'}), 404


# Ruta general para crear un registro en cualquier tabla
@app.route('/table/<string:table>', methods=['POST'])
def create(table):
    if not table.isalnum():
        return jsonify({'error': 'Nombre de tabla inválido'}), 400

    data = request.json
    if not data:
        return jsonify({'error': 'Datos inválidos'}), 400

    columns = ', '.join(data.keys())
    values_placeholders = ', '.join(['%s'] * len(data))
    values = tuple(data.values())

    conn = get_connection()
    cursor = conn.cursor()
    query = f"INSERT INTO {table} ({columns}) VALUES ({values_placeholders})"
    cursor.execute(query, values)
    conn.commit()
    conn.close()

    return jsonify({'mensaje': 'Registro creado'}), 201

# Ruta general para actualizar un registro en cualquier tabla
@app.route('/table/<string:table>/<string:id>', methods=['PUT'])
def update(table, id):
    if not table.isalnum():
        return jsonify({'error': 'Nombre de tabla inválido'}), 400

    data = request.json
    if not data:
        return jsonify({'error': 'Datos inválidos'}), 400

    # Conectar a la base de datos
    conn = get_connection()
    cursor = conn.cursor()

    # Obtener el nombre de la clave primaria para la tabla
    cursor.execute("""
        SELECT COLUMN_NAME
        FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
        WHERE TABLE_NAME = %s AND CONSTRAINT_NAME LIKE 'PK_%'
    """, (table,))
    
    primary_key = cursor.fetchone()
    
    if not primary_key:
        conn.close()
        return jsonify({'error': 'No se encontró clave primaria para esta tabla'}), 404
    
    primary_key_column = primary_key[0]  # Accedemos al valor de la clave primaria usando índice 0

    # Crear la cláusula SET para la actualización
    set_clause = ', '.join([f"{key} = %s" for key in data.keys()])
    values = tuple(data.values()) + (id,)

    # Actualizar el registro usando la clave primaria correcta
    query = f"UPDATE {table} SET {set_clause} WHERE {primary_key_column} = %s"
    cursor.execute(query, values)
    conn.commit()
    conn.close()

    return jsonify({'mensaje': 'Registro actualizado'})

# Ruta general para eliminar un registro de cualquier tabla
@app.route('/table/<string:table>/<string:id>', methods=['DELETE'])
def delete(table, id):
    if not table.isalnum():
        return jsonify({'error': 'Nombre de tabla inválido'}), 400

    conn = get_connection()
    cursor = conn.cursor()

    # Obtener el nombre de la clave primaria para la tabla
    cursor.execute("""
        SELECT COLUMN_NAME
        FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
        WHERE TABLE_NAME = %s AND CONSTRAINT_NAME LIKE 'PK_%'
    """, (table,))
    
    primary_key = cursor.fetchone()
    
    if not primary_key:
        conn.close()
        return jsonify({'error': 'No se encontró clave primaria para esta tabla'}), 404
    
    primary_key_column = primary_key[0]  # Usamos el índice 0 para acceder al valor de la clave primaria

    # Realizar la eliminación usando la clave primaria
    cursor.execute(f"DELETE FROM {table} WHERE {primary_key_column} = %s", (id,))
    conn.commit()
    conn.close()

    return jsonify({'mensaje': 'Registro borrado'}), 200


if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=2025)
