from flask import Flask
from flask_restful import Api

app = Flask(__name__)
api = Api(app)

@app.route('/', methods=['GET'])
def hello_world() :
    return { 'name' : 'Hello World!', 'email' : '12313123', 'company' : {'name': "kim"} }

if __name__ == '__main__' :
    app.run()