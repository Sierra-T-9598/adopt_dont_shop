require 'rails_helper'

RSpec.describe 'Admin application show page' do
  before(:each) do
    @shelter = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    @pet_1 = Pet.create!(adoptable: true, age: 1, breed: 'sphynx', name: 'Lucille Bald', shelter_id: @shelter.id)
    @pet_2 = Pet.create!(adoptable: true, age: 3, breed: 'doberman', name: 'Lobster', shelter_id: @shelter.id)
    @pet_3 = Pet.create!(adoptable: true, age: 7, breed: 'chicken', name: 'Rusty', shelter_id: @shelter.id)
    @pet_4 = Pet.create!(adoptable: true, age: 2, breed: 'dalmatian', name: 'Spot', shelter_id: @shelter.id)
    @pet_8 = Pet.create!(adoptable: true, age: 2, breed: 'kitten', name: 'Benny', shelter_id: @shelter.id)
    @application_1 = Application.create!(applicant_name: Faker::Name.name, street_address: '131 Seward Lane', city: 'Longmont', state: 'Colorado', zip_code: '80501', description: 'I love animals!', status: "Pending")
    @application_2 = Application.create!(applicant_name: 'Maximus G', street_address: '13 Tulip Ave', city: 'Longmont', state: 'Colorado', zip_code: '80501', description: 'I love animals!', status: "Pending")
    @application_3 = Application.create!(applicant_name: 'Gerald F', street_address: '1775 Spencer Street', city: 'Longmont', state: 'Colorado', zip_code: '80501', description: 'I love animals!', status: "In Progress")
    @pet_app_1 = PetApplication.create(pet_id: @pet_4.id, application_id: @application_1.id)
    @pet_app_1 = PetApplication.create(pet_id: @pet_8.id, application_id: @application_1.id)
    @pet_app_2 = PetApplication.create(pet_id: @pet_4.id, application_id: @application_2.id)
    @pet_app_3 = PetApplication.create(pet_id: @pet_2.id, application_id: @application_3.id)
  end

  describe 'applicant details' do
    it 'displays the application info' do
      visit "/admin/applications/#{@application_1.id}"
      within('#application_info') do
        expect(page).to have_content(@application_1.applicant_name)
        expect(page).to have_content(@application_1.street_address)
        expect(page).to have_content(@application_1.description)
        expect(page).to have_content(@pet_4.name)
        expect(page).to have_content(@pet_8.name)
      end
    end
  end

  describe 'approving a pet for adoption' do
    it 'has a button to approve each pet on the application' do
      visit "/admin/applications/#{@application_1.id}"

      within("#decision-#{@application_1.id}") do
        expect(page).to have_button("Approve application for #{@pet_4.name}")
        expect(page).to have_button("Approve application for #{@pet_8.name}")
      end
    end

    it 'indicates which pets have been approved' do
      visit "/admin/applications/#{@application_1.id}"
      within("#decision-#{@application_1.id}") do
        click_button "Approve application for #{@pet_4.name}"
        expect(current_path).to eq("/admin/applications/#{@application_1.id}")
        expect(page).to_not have_button("Approve application for #{@pet_4.name}")
        expect(page).to have_button("Approve application for #{@pet_8.name}")
        expect(page).to have_content("#{@pet_4.name}: Approved")
      end
    end
  end

  describe 'rejecting a pet for adoption' do
    it 'has a button to reject each pet on the application ' do
      visit "/admin/applications/#{@application_1.id}"

      within("#decision-#{@application_1.id}") do
        expect(page).to have_button("Reject application for #{@pet_4.name}")
        expect(page).to have_button("Reject application for #{@pet_8.name}")
      end
    end

    it 'indicates which pets have been rejected' do
      visit "/admin/applications/#{@application_1.id}"

      within("#decision-#{@application_1.id}") do
        click_button "Reject application for #{@pet_4.name}"
        expect(current_path).to eq("/admin/applications/#{@application_1.id}")
        expect(page).to_not have_button("Reject application for #{@pet_4.name}")
        expect(page).to_not have_button("Approve application for #{@pet_4.name}")
        expect(page).to have_button("Reject application for #{@pet_8.name}")
        expect(page).to have_button("Approve application for #{@pet_8.name}")
        expect(page).to have_content("#{@pet_4.name}: Rejected")
      end
    end
  end

  describe 'approved or rejected pets on one application to not affect other applications' do
    it 'does not matter if there are two applications for the same pet' do
      visit "/admin/applications/#{@application_1.id}"
      within("#decision-#{@application_1.id}") do
        click_button "Reject application for #{@pet_4.name}"
        expect(current_path).to eq("/admin/applications/#{@application_1.id}")
        expect(page).to_not have_button("Reject application for #{@pet_4.name}")
        expect(page).to_not have_button("Approve application for #{@pet_4.name}")
        expect(page).to have_content("#{@pet_4.name}: Rejected")
      end

      visit "/admin/applications/#{@application_2.id}"
      within("#decision-#{@application_2.id}") do
        expect(current_path).to eq("/admin/applications/#{@application_2.id}")
        expect(page).to have_button("Reject application for #{@pet_4.name}")
        expect(page).to have_button("Approve application for #{@pet_4.name}")
      end
    end

    describe 'completed applications' do
      it 'has all pets accepted on an application' do
        visit "/admin/applications/#{@application_1.id}"
        within("#decision-#{@application_1.id}") do
          click_button "Approve application for #{@pet_4.name}"
          click_button "Approve application for #{@pet_8.name}"
        end

        within('#application_status') do
          expect(page).to have_content("Approved")
        end
      end
    end
   end
end
