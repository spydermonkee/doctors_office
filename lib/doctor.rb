require 'pg'

class Doctor

  attr_reader :name, :specialty_id, :insurance_id, :id

  def initialize(attributes)
    @name = attributes[:name]
    @specialty_id = attributes[:specialty_id]
    @insurance_id = attributes[:insurance_id]
    @id = attributes[:id]
  end

  def self.create(attributes)
    doctor = Doctor.new(attributes)
    doctor.save
    doctor
  end

  def save
    results = DB.exec("INSERT INTO doctors (name, specialty_id, insurance_id) VALUES ('#{@name}', #{@specialty_id}, #{@insurance_id}) RETURNING id;")
    @id = results.first['id'].to_i
  end

  def delete
    DB.exec("DELETE FROM doctors WHERE id = #{@id};")
  end

  def edit_name(new_name)
    DB.exec("UPDATE doctors SET name = '#{new_name}' WHERE id = #{@id};")
  end

  def edit_specialty_id(new_specialty_id)
    DB.exec("UPDATE doctors SET specialty_id = #{new_specialty_id} WHERE id = #{@id};")
  end

  def edit_insurance_id(new_insurance_id)
    DB.exec("UPDATE doctors SET insurance_id = #{new_insurance_id} WHERE id = #{@id};")
  end

  def self.all
    results = DB.exec("SELECT * FROM doctors;")
    doctors = []
    results.each do |result|
      name = result['name']
      specialty_id = result['specialty_id'].to_i
      insurance_id = result['insurance_id'].to_i
      id = result['id'].to_i
      doctors << Doctor.new({:name => name, :specialty_id => specialty_id, :insurance_id => insurance_id, :id => id})
    end
    doctors
  end

  def find_patients
    DB.exec("SELECT * FROM doctors_patients WHERE doctor_id = #{@id};")
  end

end
