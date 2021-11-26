from os import name
from re import M
from flask import Flask, render_template, request, url_for
from flask_mysqldb import MySQL
from werkzeug.utils import redirect
import yaml

app = Flask(__name__)


db = yaml.safe_load(open('db.yaml'))
app.config['MYSQL_HOST'] = db['mysql_host']
app.config['MYSQL_USER'] = db['mysql_user']
app.config['MYSQL_PASSWORD'] = db['mysql_password']
app.config['MYSQL_DB'] = db['mysql_db']

mysql = MySQL(app)

@app.route('/', methods=['GET','POST'])
def register():
    if request.method == 'POST':
        client_details = request.form

        login_id = client_details['login_id']
        name = client_details['name']
        password = client_details['password']

        cur = mysql.connection.cursor()
        cur.execute("INSERT INTO clients(name, login_id, password) VALUES (%s, %s, %s)", (login_id, name, password))
        mysql.connection.commit()
        cur.close()
        return redirect('/home')

    return render_template("register.html") 

@app.route('/home')
def home():
    return render_template('home.html')

if __name__ == "__main__":
    app.run(debug=True)