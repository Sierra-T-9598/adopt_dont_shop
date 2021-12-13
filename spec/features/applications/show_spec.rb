require 'rails_helper'

RSpec.describe 'Application Show Page' do
  describe 'When visiting the applicaiton show page' do
    before(:each) do
      @shelter = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
      @pet_1 = Pet.create!(adoptable: true, age: 1, breed: 'sphynx', name: 'Lucille Bald', shelter_id: @shelter.id)
      @pet_2 = Pet.create!(adoptable: true, age: 3, breed: 'doberman', name: 'Lobster', shelter_id: @shelter.id)
      @pet_3 = Pet.create!(adoptable: true, age: 7, breed: 'chicken', name: 'Rusty', shelter_id: @shelter.id)
      @pet_4 = Pet.create!(adoptable: true, age: 2, breed: 'dalmatian', name: 'Spot', shelter_id: @shelter.id)
      @pet_8 = Pet.create!(adoptable: true, age: 2, breed: 'kitten', name: 'Benny', shelter_id: @shelter.id)
      @application_1 = Application.create!(applicant_name: Faker::Name.name, street_address: '131 Seward Lane', city: 'Longmont', state: 'Colorado', zip_code: '80501')
      @application_2 = @pet_1.applications.create!(applicant_name: 'Maximus G', street_address: '13 Tulip Ave', city: 'Longmont', state: 'Colorado', zip_code: '80501')
      @application_3 = Application.create!(applicant_name: 'Gerald F', street_address: '1775 Spencer Street', city: 'Longmont', state: 'Colorado', zip_code: '80501')
    end

    it 'displays the name of applicant' do
      visit "/applications/#{@application_1.id}"
      expect(page).to have_content(@application_1.applicant_name)
      expect(page).to_not have_content(@application_2.applicant_name)
    end

    it 'displays the full address of applicant' do
      visit "/applications/#{@application_1.id}"
      expect(page).to have_content(@application_1.street_address)
      expect(page).to have_content(@application_1.city)
      expect(page).to have_content(@application_1.state)
      expect(page).to have_content(@application_1.zip_code)

      expect(page).to_not have_content(@application_2.street_address)
    end

    it 'lists the names of all pets that the application is for' do
      @application_1.pets << @pet_1
      @application_1.pets << @pet_2
      visit "/applications/#{@application_1.id}"
      expect(page).to have_content(@pet_1.name)
      expect(page).to have_content(@pet_2.name)
      expect(page).to_not have_content(@pet_3.name)
      expect(page).to_not have_content(@pet_4.name)
    end

    it 'links each pet on the application to its show page' do
      @application_1.pets << @pet_1
      @application_1.pets << @pet_2
      visit "/applications/#{@application_1.id}"
      expect(page).to have_link('Lucille Bald')
      expect(page).to have_link('Lobster')
    end

    it 'displays the application status' do
      @application_1.pets << @pet_1
      @application_1.pets << @pet_2
      visit "/applications/#{@application_1.id}"
      expect(page).to have_content(@application_1.status)
    end

  describe 'searching for pets for an application' do
      describe 'an application that has not been submitted' do

        it 'has a search box to search for pet by name' do
          visit "/applications/#{@application_1.id}"
          # click_button 'Submit'

          expect(page).to have_button('Submit')
        end

        it 'shows any pet whose name matches the search' do
          visit "/applications/#{@application_1.id}"
          fill_in :search, with: "#{@pet_1.name}"
          click_button 'Submit'

          expect(page).to have_content(@pet_1.name)
        end
      end
    end

    describe 'adding a pet to an application' do
      describe 'search for pet by name' do
        it 'has a button to adopt the pet' do
          visit "/applications/#{@application_1.id}"
          fill_in :search, with: "#{@pet_1.name}"
          click_button 'Submit'

          expect(page).to have_button("Adopt #{@pet_1.name}")
        end

        it 'can list the pets wanted for adoption' do

          # within("section#application_pet-#{@application_1.id}") do
          #   fill_in :search, with: "#{@pet_8.name}"
          #   click_button 'Submit'
          #
          #   click_button "Adopt #{@pet_8.name}"
          #   expect(page).to have_content(@pet_8.name)
          # end
          visit "/applications/#{@application_1.id}"
          fill_in :search, with: "#{@pet_8.name}"
          click_button 'Submit'
          click_button "Adopt #{@pet_8.name}"
          expect(page).to have_content(@pet_8.name)

        end
      end
    end

    describe 'submit an application' do
      describe 'at least one pet added' do
        it 'submits an application once description is written' do
          @application_1.pets << @pet_1
          @application_1.pets << @pet_2
          visit "/applications/#{@application_1.id}"
          expect(page).to have_button('Submit your application')

          fill_in :description, with: 'Big, fenced backyard.'
          click_button('Submit your application')

          # expect(page).to have_content(@application_1.description)
          expect(page).to have_content('Pending')
          # expect(page).to_not have_button('Submit your application')
          expect(current_path).to eq("/applications/#{@application_1.id}")
        end

        describe 'no pets added' do
          it 'does not display a section to submit' do
            visit "/applications/#{@application_1.id}"
            expect(@application_1.pets.length).to eq(0)
            expect(page).to_not have_button('Submit your application')
          end
        end
      end
    end
  end
end
