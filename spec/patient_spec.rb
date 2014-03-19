require 'spec_help'

describe Patient do
  describe '.initialize' do
    it 'is initialized with a name' do
      test_patient = Patient.new({:name => 'Billy Boggs', :birthdate => '1981-11-24'})
      test_patient.should be_an_instance_of Patient
    end
  end

  describe '.create' do
    it 'creates a patient with a name, birthdate and an id' do
      test_patient = Patient.create({:name => 'Billy Boggs', :birthdate => '1981-11-24'})
      results = DB.exec("SELECT birthdate FROM patients WHERE birthdate = '1981-11-24';")
      results.first['birthdate'].should eq '1981-11-24'
    end
  end

  describe '.all' do
    it 'makes a temporary collection of all the patients in the practice' do
      test_patient1 = Patient.create({:name => 'Billy Boggs', :birthdate => '1981-11-24'})
      test_patient2 = Patient.create({:name => 'Peggy Sue', :birthdate => '1965-07-09'})
      test_patient3 = Patient.create({:name => 'Johnny Red Walker', :birthdate => '1887-07-07'})
      Patient.all.length.should eq 3
    end
  end

  describe '.find' do
    it 'finds a patient record in the database' do
      test_patient1 = Patient.create({:name => 'Billy Boggs', :birthdate => '1981-11-24'})
      test_patient2 = Patient.create({:name => 'Peggy Sue', :birthdate => '1965-07-09'})
      test_patient3 = Patient.create({:name => 'Johnny Red Walker', :birthdate => '1887-07-07'})
      Patient.find('Peggy Sue').should eq test_patient2
    end
  end

  describe '#save' do
    it 'saves a patient to the patients database' do
      test_patient = Patient.new({:name => 'Billy Boggs', :birthdate => '1981-11-24'})
      test_patient.save
      results = DB.exec("SELECT birthdate FROM patients WHERE birthdate = '1981-11-24';")
      results.first['birthdate'].should eq '1981-11-24'
    end
  end

  describe '#delete' do
    it 'deletes a patient from the database' do
      test_patient1 = Patient.create({:name => 'Billy Boggs', :birthdate => '1981-11-24'})
      test_patient2 = Patient.create({:name => 'Peggy Sue', :birthdate => '1965-07-09'})
      test_patient3 = Patient.create({:name => 'Johnny Red Walker', :birthdate => '1887-07-07'})
      test_patient2.delete
      Patient.all.length.should eq 2
      results = DB.exec("SELECT name FROM patients WHERE name = 'Peggy Sue';")
      results.first.should eq nil
    end
  end

  describe '#edit_name' do
    it 'changes a patient\'s name' do
      test_patient2 = Patient.create({:name => 'Billy Boggs', :birthdate => '1981-11-24'})
      test_patient2.edit_name('William Boggs')
      results = DB.exec("SELECT * FROM patients WHERE id = #{test_patient2.id};")
      results.first['name'].should eq 'William Boggs'
    end
  end

  describe '#edit_birthdate' do
    it 'edits a patient\'s birthdate' do
      test_patient = Patient.create({:name => 'Billy Boggs', :birthdate => '1981-11-24'})
      test_patient.edit_birthdate('1982-11-24')
      results = DB.exec("SELECT * FROM patients WHERE id = #{test_patient.id};")
      results.first['birthdate'].should eq '1982-11-24'
    end
  end

  describe '#assign_doctor' do
    it 'assigns a patient to a doctor in the database' do
      test_patient3 = Patient.create({:name => 'Johnny Red Walker', :birthdate => '1887-07-07'})
      test_patient3.assign_doctor(6)
      results = DB.exec("SELECT * FROM doctors_patients WHERE patient_id = #{test_patient3.id};")
      results.first['doctor_id'].to_i.should eq 6
    end
  end

  describe '#find_doctors' do
    it 'lists all the doctors that a patient sees in the practice' do
      test_patient3 = Patient.create({:name => 'Johnny Red Walker', :birthdate => '1887-07-07'})
      test_patient3.assign_doctor(6)
      test_patient3.assign_doctor(9)
      test_patient3.find_doctors.reverse_each.first['doctor_id'].to_i.should eq 9
    end
  end

end
