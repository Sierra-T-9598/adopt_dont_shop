require 'rails_helper'

RSpec.describe 'Admin application show page' do
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

  describe 'approving a pet for adoption' do
    it 'has a button to approve each pet on on the application' do
      @application_1.pets << @pet_1
      @application_1.pets << @pet_2
      @application_1.description = "I love animals."
      @application_1.status = "Pending"

      expect(page).to have_button("Approve application for #{@pet_1.name}")
      expect(page).to have_button("Approve application for #{@pet_2.name}")
    end

    it 'indicates which pets have been approved' do
      @application_1.pets << @pet_1
      @application_1.pets << @pet_2
      @application_1.description = "I love animals."
      @application_1.status = "Pending"

      click_button "Approve application for #{@pet_1.name}"

      expect(current_path).to eq("/admin/applications/#{@application_1.id}")
      expect(page).to_not have_button("Approve application for #{@pet_1.name}")
      expect(page).to have_button("Approve application for #{@pet_2.name}")
      expect(page).to have_content("Approved")
    end
  end
end
