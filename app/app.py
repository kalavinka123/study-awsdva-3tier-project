import os
import json
import boto3
import pymysql
from flask import Flask, jsonify

app = Flask(__name__)

def get_db_credentials():
    """Retrieve database credentials from Secrets Manager"""
    secret_name = os.environ.get('DB_SECRET_NAME', 'dev/three-tier-db')
    region = os.environ.get('AWS_REGION', 'us-west-2')
    
    client = boto3.client('secretsmanager', region_name=region)
    response = client.get_secret_value(SecretId=secret_name)
    secret = json.loads(response['SecretString'])
    
    return secret['username'], secret['password']

def get_db_connection():
    """Create database connection"""
    db_host = os.environ.get('DB_HOST')
    db_name = os.environ.get('DB_NAME', 'testdb')
    
    username, password = get_db_credentials()
    
    connection = pymysql.connect(
        host=db_host,
        user=username,
        password=password,
        database=db_name,
        cursorclass=pymysql.cursors.DictCursor
    )
    
    return connection

@app.route('/')
def index():
    """Home endpoint"""
    return jsonify({
        'message': 'Three-Tier Application',
        'endpoints': {
            '/': 'This message',
            '/health': 'Health check',
            '/users': 'Get all users from database'
        }
    })

@app.route('/health')
def health():
    """Health check endpoint"""
    try:
        connection = get_db_connection()
        connection.close()
        return jsonify({'status': 'healthy', 'database': 'connected'}), 200
    except Exception as e:
        return jsonify({'status': 'unhealthy', 'error': str(e)}), 500

@app.route('/users')
def get_users():
    """Get all users from database"""
    try:
        connection = get_db_connection()
        
        with connection.cursor() as cursor:
            cursor.execute("SELECT * FROM users")
            users = cursor.fetchall()
        
        connection.close()
        
        # Format as "Hello {user}" for each user
        greetings = [f"Hello {user['name']}" for user in users]
        
        return '<br>'.join(greetings), 200
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 80))
    app.run(host='0.0.0.0', port=port)
