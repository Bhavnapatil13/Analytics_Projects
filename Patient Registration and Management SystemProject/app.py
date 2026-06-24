from flask import Flask , request,jsonify
import re
import sqlite3
app = Flask(__name__)

def init_db():
    conn = sqlite3.connect('hospital.db')
    cursor = conn.cursor()

    cursor.execute('''create table if not exists patients(
                       id INTEGER Primary key Autoincrement,
                       name text not null,
                       dob text,
                       gender text,
                       email text not null,
                       phone text not null,
                       address text
                       )
                       ''')
    conn.commit()
    conn.close()

class PatientValidator:

    @staticmethod
    def validate_name(name):
        if not re.match(r"^[A-Za-z\s]+$", name):
            raise ValueError("Invalid name: only letters and spaces are allowed.")
        return True

    @staticmethod
    def validate_email(email):
        if not re.match(r"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$", email):
            raise ValueError("Invalid email format.")
        return True

    @staticmethod
    def validate_phone(phone):
        if not re.match(r"^[6-9]\d{9}$", phone):
            raise ValueError("Invalid phone: It must be in 10-digit format.")
        return True

@app.route('/patients',methods=['POST'])
def register_patient():
    data = request.get_json()

    try:
        PatientValidator.validate_name(data['name'])
        PatientValidator.validate_email(data['email'])
        PatientValidator.validate_phone(data['phone'])

        conn = sqlite3.connect('hospital.db')
        cursor = conn.cursor()

        cursor.execute('''Insert  into patients(name, dob, gender,email,phone,address) 
                          values(?,?,?,?,?,?)''',(
                             data['name'],
                             data.get('dob', ''),
                             data.get('gender',''),
                             data['email'],
                             data['phone'],
                             data.get('address', '')
        ))

        conn.commit()
        conn.close()

        return jsonify({"message": "Patient registered successfully!!"}), 201

    except ValueError as error_message:
        return jsonify({"Error": str(error_message)}), 400

    except KeyError as missing_key:
        return jsonify({"Error": f"Missing mandatory field: {str(missing_key)}"}), 400


@app.route('/patients', methods=['GET'])
def get_patients():
    conn = sqlite3.connect('hospital.db')
    cursor = conn.cursor()
    cursor.execute("Select * from patients")
    rows = cursor.fetchall()
    conn.close()

    patients_list = []
    for row in rows:
        patients_list.append({
            "id": row[0], "name": row[1], "dob": row[2], "gender": row[3],
            "email": row[4], "phone": row[5], "address": row[6]
        })

    return jsonify({"patients": patients_list}), 200


if __name__ == '__main__':
    init_db()
    print("Starting Hospital API... Waiting for postman requests on port 5000!!")
    app.run(debug=True)

