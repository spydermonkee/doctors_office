require 'pg'

class Patient

  attr_reader :name, :birthdate, :id

  def ==(another_patient)
    (self.name == another_patient.name && self.birthdate == another_patient.birthdate) && self.id == another_patient.id
  end

  def initialize(attributes)
    @name = attributes[:name]
    @birthdate = attributes[:birthdate]
    @id = attributes[:id]
  end

  def self.create(attributes)
    patient = Patient.new(attributes)
    patient.save
    patient
  end

  def self.find(name)
    patient = DB.exec("SELECT * FROM patients WHERE name = '#{name}';")
    name = patient.first['name']
    birthdate = patient.first['birthdate']
    id = patient.first['id'].to_i
    patient = Patient.new({:name => name, :birthdate => birthdate, :id => id})
  end

  def find_doctors
    DB.exec("SELECT * FROM doctors_patients WHERE patient_id = #{@id};")
  end

  def save
    results = DB.exec("INSERT INTO patients (name, birthdate) VALUES ('#{@name}', '#{@birthdate}') RETURNING id;")
    @id = results.first['id'].to_i
  end

  def delete
    DB.exec("DELETE FROM patients WHERE id = #{@id};")
  end

  def assign_doctor(doctor_id)
    DB.exec("INSERT INTO doctors_patients (doctor_id, patient_id) VALUES (#{doctor_id}, #{@id});")
  end

  def edit_name(new_name)
    DB.exec("UPDATE patients SET name = '#{new_name}' WHERE id = #{@id};")
  end

  def edit_birthdate(new_birthdate)
    DB.exec("UPDATE patients SET birthdate = '#{new_birthdate}' WHERE id = #{@id};")
  end

  def self.all
    results = DB.exec("SELECT * FROM patients;")
    patients = []
    results.each do |result|
      name = result['name']
      birthdate = result['birthdate']
      id = result['id'].to_i
      patients << Doctor.new({:name => name, :birthdate => birthdate, :id => id})
    end
    patients
  end

end
