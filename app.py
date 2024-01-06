import awsgi
# import boto3
# import json
from flask import (
    Flask,
    jsonify,
    request,
)

# Create a Flask app

app = Flask(__name__)


@app.route('/', methods=['GET'])
def get_handler():
    """
    Get Handler
    ---
    responses:
      200:
        description: Successful response
    """
    return jsonify(status=200, message='Hello Flask!')

@app.route('/post', methods=['POST'])
def post_handler():
    data = request.get_json()
    name = data.get('name', 'Guest')
    """
    Post Handler
    ---
    parameters:
      - name: data
        in: body
        required: true
        schema:
          type: object
    responses:
      200:
        description: Successful response
    """
    return jsonify({'message': f'POST request handled with data Hello, {name}!'})

@app.route('/put', methods=['PUT'])
def put_handler():
    """
    Put Handler
    ---
    parameters:
      - name: data
        in: body
        required: true
        schema:
          type: object
    responses:
      200:
        description: Successful response
    """
    data = request.get_json()
    return jsonify({"message": f"PUT request handled with data: {data}"})

@app.route('/delete', methods=['DELETE'])
def delete_handler():
    """
    Delete Handler
    ---
    responses:
      200:
        description: Successful response
    """
    return jsonify({"message": "DELETE request handled"})

def lambda_handler():
    response = awsgi.response()
    response.headers['Content-Type'] = 'application/json'
    app_response = app.full_dispatch_request()
    response.set_data(app_response.get_data())
    response.set_status_code(app_response.status_code)
    return response._to_dict()

if __name__ == "__main__":
    app.run(debug=True)