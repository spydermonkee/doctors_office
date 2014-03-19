require 'rspec'
require 'doctor'
require 'patient'
require 'insurance'
require 'specialty'
require 'pg'

DB = PG.connect(:dbname => 'practice_test')

RSpec.configure do |config|
  config.after(:each) do
    DB.exec("DELETE FROM doctors *;")
    DB.exec("DELETE FROM patients *;")
    DB.exec("DELETE FROM insurances *;")
    DB.exec("DELETE FROM specialties *;")
  end
end
