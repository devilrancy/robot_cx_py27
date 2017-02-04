

### Background ###
This is a docker container which with a pre-installed Python 2.7, cx_Oracle module and Oracle XE 12.1 client.

### Create a Docker File ###
```
FROM sbanal/python-oracle-xe12.1-latest
COPY yourapp.py /code/app.py
```

### Build it ###

```
$ docker build -t my-python-app .
$ docker run -it --rm --name my-web-app my-python-app
```

### Running Python app from local volume ###

Local volume where app resides must have a main application whose name is app.py
```
docker run -it --rm --name my-python-app -v "/my/local/path/":/code sbanal/python-oracle-xe12.1-latest
```
#### Example ####
##### Create file app.py in your directory with contents below  #####

~~~~~~
from flask import Flask
import cx_Oracle

app = Flask(__name__)
app.debug = True

@app.route('/hello')
def hello():
    return 'Hello World! Running with Oracle!'

if __name__ == "__main__":
    app.run(host="0.0.0.0", debug=False)
~~~~~~

##### Run application using command below #####
```
docker run -it --rm --name my-python-app -p 5500:5000 -v `pwd`:/code sbanal/python-oracle-xe12.1-latest
```

##### Open a browser and enter http://[docker machine ip]:5500/hello #####
Example http://192.168.99.100:5500/hello





