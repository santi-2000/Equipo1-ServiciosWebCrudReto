from flask import Flask, request, jsonify
from flask_cors import CORS
import pymssql

app = Flask(__name__)
CORS(app)

# Database configuration
server = "localhost"
port = 1433
database = "master"
username = "sa"
password = "YourPassword123!"

# Database connection function
def get_connection():
    return pymssql.connect(server=server, port=port, user=username, password=password, database=database)

@app.route('/test', methods=['GET'])
def get_all():
    conn = get_connection()
    cursor = conn.cursor(as_dict=True)
    cursor.execute('SELECT * FROM Test')
    data = cursor.fetchall()
    conn.close()
    return jsonify(data)

@app.route('/test/<int:id>', methods=['GET'])
def get_one(id):
    conn = get_connection()
    cursor = conn.cursor(as_dict=True)
    cursor.execute('SELECT * FROM Test WHERE id = %s', (id,))
    data = cursor.fetchone()
    conn.close()
    if data:
        return jsonify(data)
    else:
        return jsonify({'mensaje': 'Registro no encontrado'}), 404

@app.route('/test', methods=['POST'])
def create():
    data = request.json
    id = data['id']
    name = data['name']
    email = data['email']
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute('INSERT INTO Test (id, name, email) VALUES (%s,%s, %s)', (id, name, email))
    conn.commit()
    conn.close()
    return jsonify({'mensaje': 'Registro creado'}), 201

@app.route('/test/<int:id>', methods=['PUT'])
def update(id):
    data = request.json
    name = data['name']
    email = data['email']
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute('UPDATE Test SET name = %s, email = %s WHERE id = %s', (name, email, id))
    conn.commit()
    conn.close()
    return jsonify({'mensaje': 'Registro actualizado'})

@app.route('/test/<int:id>', methods=['DELETE'])
def delete(id):
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute('DELETE FROM Test WHERE id = %s', (id,))
    conn.commit()
    conn.close()
    return jsonify({'mensaje': 'Registro borrado'})

if __name__ == '__main__':
    app.run(debug=True, port=2025)
