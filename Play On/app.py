from os import name
from re import M
from flask import Flask, render_template, request, url_for, session
from flask.helpers import flash
from flask_mysqldb import MySQL
from werkzeug.utils import redirect
import yaml

app = Flask(__name__)


db = yaml.safe_load(open('db.yaml'))

app.config['MYSQL_HOST'] = db['mysql_host']
app.config['MYSQL_USER'] = db['mysql_user']
app.config['MYSQL_PASSWORD'] = db['mysql_password']
app.config['MYSQL_DB'] = db['mysql_db']
app.config['MYSQL_CURSORCLASS'] = 'DictCursor'

mysql = MySQL(app)

@app.route('/')
def home():
    return render_template('start.html')

@app.route('/register', methods=['GET','POST'])
def register():
    if request.method == 'POST':
        error = False
        client_details = request.form

        login_id = client_details['login_id']
        name = client_details['name']
        password = client_details['password']

        if login_id == '' or password == '' or name == '':
            flash('No input detected')
            error = True
            return render_template('register.html', error = error)

        cur = mysql.connection.cursor()
        cur.execute("INSERT INTO clients(name, login_id, password) VALUES (%s, %s, %s)", (name, login_id, password))
        mysql.connection.commit()
        cur.close()
        return redirect('/')

    return render_template("register.html") 

@app.route('/login', methods=['GET','POST'])
def login():
    error = False
    if request.method == 'POST':
        login_details = request.form

        login_id = login_details['login_id']
        password_entered = login_details['password']

        if login_id == '' or password_entered == '':
            flash('No input detected')
            error = True
            return render_template('login.html', error = error)

        cur = mysql.connection.cursor()

        result = cur.execute("SELECT * FROM clients WHERE login_id = %s", [login_id])
        if result > 0:
            details = cur.fetchone()
            password = details['password']

            if password == password_entered:
                return redirect('/')
        else:
            flash('Incorrect password or id')
            error = True
            return render_template('login.html', error = error)

    return render_template('login.html')

if __name__ == "__main__":
    app.secret_key = "WBDJSBALFkjdabd"
    app.run(debug=True)