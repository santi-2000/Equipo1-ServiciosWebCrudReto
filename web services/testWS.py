import requests

BASE_URL = 'http://localhost:2025/test'

# Test Create (POST)
def test_create():
    payload = {'id': '4', 'name': 'John Doe', 'email': 'john.doe@example.com'}
    response = requests.post(BASE_URL, json=payload)
    print('CREATE:', response.status_code, response.json())

# Test Get All (GET)
def test_get_all():
    response = requests.get(BASE_URL)
    print('GET ALL:', response.status_code, response.json())

# Test Get One (GET)
def test_get_one(record_id):
    response = requests.get(f'{BASE_URL}/{record_id}')
    print(f'GET ONE {record_id}:', response.status_code, response.json())

# Test Update (PUT)
def test_update(record_id):
    payload = {'name': 'Jane Doe', 'email': 'jane.doe@example.com'}
    response = requests.put(f'{BASE_URL}/{record_id}', json=payload)
    print(f'UPDATE {record_id}:', response.status_code, response.json())

# Test Delete (DELETE)
def test_delete(record_id):
    response = requests.delete(f'{BASE_URL}/{record_id}')
    print(f'DELETE {record_id}:', response.status_code, response.json())

if __name__ == '__main__':
    test_create()
    test_get_all()
    test_get_one(1)  # Adjust the ID based on your data
    ##test_update(1)   # Adjust the ID based on your data
    ##test_delete(1)   # Adjust the ID based on your data
    test_get_all()
