require 'rails_helper'

RSpec.describe Application, type: :model do
  describe "relationships" do
    it {should have_many :pet_applications}
    it {should have_many(:pets).through(:pet_applications)}
  end

  describe 'validations' do
    it { should validate_presence_of(:applicant_name) }
    it { should validate_presence_of(:street_address) }
    it { should validate_presence_of(:city) }
    it { should validate_presence_of(:state) }
    it { should validate_presence_of(:zip_code) }
    it { should validate_presence_of(:description).on(:update) }
    it { should validate_presence_of(:status) }
  end

  describe 'instance methods' do
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
      @pet_app_1 = PetApplication.create(pet_id: @pet_4.id, application_id: @application_1.id, application_status: "Approved")
      @pet_app_2 = PetApplication.create(pet_id: @pet_8.id, application_id: @application_1.id, application_status: "Approved")
      @pet_app_3 = PetApplication.create(pet_id: @pet_4.id, application_id: @application_2.id)
      @pet_app_4 = PetApplication.create(pet_id: @pet_2.id, application_id: @application_3.id, application_status: "Approved")
      @pet_app_5 = PetApplication.create(pet_id: @pet_4.id, application_id: @application_3.id, application_status: "Rejected")
    end

    describe '#change_status' do
      it 'updates the application status after admin decisions' do
        @application_1.change_status
        @application_3.change_status

        expect(@application_1.status).to eq("Approved")
        expect(@application_3.status).to eq("Rejected")
      end
    end
  end
end
