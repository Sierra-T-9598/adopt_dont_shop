require 'rails_helper'

RSpec.describe 'Application Show Page' do
  describe 'When visiting the applicaiton show page' do
    before(:each) do
      @shelter = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
      @pet_1 = Pet.create!(adoptable: true, age: 1, breed: 'sphynx', name: 'Lucille Bald', shelter_id: @shelter.id)
      @pet_2 = Pet.create!(adoptable: true, age: 3, breed: 'doberman', name: 'Lobster', shelter_id: @shelter.id)
      @pet_3 = Pet.create!(adoptable: true, age: 7, breed: 'chicken', name: 'Rusty', shelter_id: @shelter.id)
      @pet_4= Pet.create!(adoptable: true, age: 2, breed: 'dalmatian', name: 'Spot', shelter_id: @shelter.id)
      @application_1 = @pet_1.applications.create!(applicant_name: 'Jenny Q', street_address: '131 Seward Lane', city: 'Longmont', state: 'Colorado', zip_code: '80501', description: 'Great backyard!', status: 'In Progress')
      @application_1 = @pet_2.applications.create!(applicant_name: 'Jenny Q', street_address: '131 Seward Lane', city: 'Longmont', state: 'Colorado', zip_code: '80501', description: 'Great backyard!', status: 'In Progress')
      @application_2 = @pet_1.applications.create!(applicant_name: 'Maximus G', street_address: '13 Tulip Ave', city: 'Longmont', state: 'Colorado', zip_code: '80501', description: 'Work from home.', status: 'In Progress')
      @application_3 = @pet_2.applications.create!(applicant_name: 'Gerald F', street_address: '1775 Spencer Street', city: 'Longmont', state: 'Colorado', zip_code: '80501', description: 'Dog lover.', status: 'In Progress')
      visit "/applications/#{@application_1.id}"
    end

    it 'displays the name of applicant' do
      expect(page).to have_content(@application_1.applicant_name)
      expect(page).to_not have_content(@application_2.applicant_name)
    end

    it 'displays the full address of applicant' do
      expect(page).to have_content(@application_1.street_address)
      expect(page).to have_content(@application_1.city)
      expect(page).to have_content(@application_1.state)
      expect(page).to have_content(@application_1.zip_code)

      expect(page).to_not have_content(@application_2.street_address)
      expect(page).to_not have_content(@application_2.city)
      expect(page).to_not have_content(@application_2.state)
      expect(page).to_not have_content(@application_2.zip_code)
    end

    it 'has a description for why the applicant says they are a good home' do
      expect(page).to have_content(@application_1.description)
      expect(page).to_not have_content(@application_2.description)
    end

    it 'lists the names of all pets that the application is for' do
      expect(page).to have_content(@pet_1.name)
      expect(page).to have_content(@pet_2.name)
      expect(page).to_not have_content(@pet_3.name)
      expect(page).to_not have_content(@pet_4.name)
    end

    it 'links each pet on the application to its show page' do
      expect(page).to have_link('Lucille Bald')
      expect(page).to have_link('Lobster')
    end

    it 'displays the application status' do
      expect(page).to have_content(@application_1.status)
    end
  end
end
