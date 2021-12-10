# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Shelter.destroy_all
Pet.destroy_all
Application.destroy_all

shelter = Shelter.create!(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
pet_1 = shelter.pets.create!(adoptable: true, age: 1, breed: 'sphynx', name: 'Lucille Bald')
pet_2 = shelter.pets.create!(adoptable: true, age: 3, breed: 'doberman', name: 'Lobster')
pet_3 = shelter.pets.create!(adoptable: true, age: 7, breed: 'chicken', name: 'Rusty')
pet_4= shelter.pets.create!(adoptable: true, age: 2, breed: 'dalmatian', name: 'Spot')
application_1 = pet_1.applications.create!(applicant_name: 'Jenny Q', street_address: '131 Seward Lane', city: 'Longmont', state: 'Colorado', zip_code: '80501', description: 'Great backyard!', status: 'In Progress')
application_1.pets << pet_2
application_2 = pet_1.applications.create!(applicant_name: 'Maximus G', street_address: '13 Tulip Ave', city: 'Longmont', state: 'Colorado', zip_code: '80501', description: 'Work from home.', status: 'In Progress')
application_3 = pet_2.applications.create!(applicant_name: 'Gerald F', street_address: '1775 Spencer Street', city: 'Longmont', state: 'Colorado', zip_code: '80501', description: 'Dog lover.', status: 'In Progress')
