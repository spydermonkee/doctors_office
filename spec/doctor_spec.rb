require 'spec_help'
require 'pry'

describe Doctor do
  describe '.initialize' do
    it 'is initialized with a name' do
      test_doctor = Doctor.new({:name => 'Dr. Jones', :specialty_id => 4, :insurance_id => 5})
      test_doctor.should be_an_instance_of Doctor
    end
  end

  describe '.create' do
    it 'creates a doctor with a name, specialty_id, an insurance_id and an id' do
      test_doctor = Doctor.create({:name => 'Dr. Jones', :specialty_id => 4, :insurance_id => 5})
      results = DB.exec("SELECT specialty_id FROM doctors WHERE specialty_id = 4;")
      results.first['specialty_id'].to_i.should eq 4
    end
  end

  describe '.all' do
    it 'makes a temporary collection of all the doctors in the practice' do
      test_doctor1 = Doctor.create({:name => 'Dr. Jones', :specialty_id => 4, :insurance_id => 5})
      test_doctor2 = Doctor.create({:name => 'Dr. Smith', :specialty_id => 4, :insurance_id => 5})
      test_doctor3 = Doctor.create({:name => 'Dr. Kinkle', :specialty_id => 1, :insurance_id => 2})
      Doctor.all.length.should eq 3
    end
  end

  describe '#save' do
    it 'saves a doctor to the doctors database' do
      test_doctor = Doctor.new({:name => 'Dr. Jones', :specialty_id => 4, :insurance_id => 5})
      test_doctor.save
      results = DB.exec("SELECT name FROM doctors WHERE name = 'Dr. Jones';")
      results.first['name'].should eq 'Dr. Jones'
    end
  end

  describe '#delete' do
    it 'deletes a doctor from the database' do
      test_doctor1 = Doctor.create({:name => 'Dr. Jones', :specialty_id => 4, :insurance_id => 5})
      test_doctor2 = Doctor.create({:name => 'Dr. Smith', :specialty_id => 4, :insurance_id => 5})
      test_doctor3 = Doctor.create({:name => 'Dr. Kinkle', :specialty_id => 1, :insurance_id => 2})
      test_doctor2.delete
      Doctor.all.length.should eq 2
      results = DB.exec("SELECT name FROM doctors WHERE name = 'Dr. Smith';")
      results.first.should eq nil
    end
  end

  describe 'edit_name' do
    it 'changes a doctors name' do
      test_doctor2 = Doctor.create({:name => 'Dr. Smith', :specialty_id => 4, :insurance_id => 5})
      test_doctor2.edit_name('Dr. Smithy')
      results = DB.exec("SELECT * FROM doctors WHERE id = #{test_doctor2.id};")
      results.first['name'].should eq 'Dr. Smithy'
    end
  end

  describe 'edit_specialty_id' do
    it 'edits a doctors specialty' do
      test_doctor = Doctor.create({:name => 'Dr. Smith', :specialty_id => 4, :insurance_id => 5})
      test_doctor.edit_specialty_id(1)
      results = DB.exec("SELECT * FROM doctors WHERE id = #{test_doctor.id};")
      results.first['specialty_id'].to_i.should eq 1
    end
  end

  describe 'edit_insurance_id' do
    it 'edits a doctors insurance' do
      test_doctor = Doctor.create({:name => 'Dr. Smith', :specialty_id => 4, :insurance_id => 5})
      test_doctor.edit_insurance_id(2)
      results = DB.exec("SELECT * FROM doctors WHERE id = #{test_doctor.id};")
      results.first['insurance_id'].to_i.should eq 2
    end
  end

  describe '#find_patients' do
    it 'lists all the patients that a doctor sees in the practice' do
      test_doctor = Doctor.create({:name => 'Dr. Smith', :specialty_id => 4, :insurance_id => 5})
      test_patient1 = Patient.create({:name => 'Billy Boggs', :birthdate => '1981-11-24'})
      test_patient2 = Patient.create({:name => 'Peggy Sue', :birthdate => '1965-07-09'})
      test_patient3 = Patient.create({:name => 'Johnny Red Walker', :birthdate => '1887-07-07'})
      test_patient3.assign_doctor(test_doctor.id)
      test_patient1.assign_doctor(test_doctor.id)
      test_patient2.assign_doctor(test_doctor.id)
      test_doctor.find_patients.reverse_each.first['patient_id'].should eq "#{test_patient3.id}"
    end
  end

end
