require 'rails_helper'

RSpec.describe 'Admin Shelters Index', type: :feature do
  before(:each) do
    @shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    @shelter_2 = Shelter.create(name: 'RGV animal shelter', city: 'Harlingen, TX', foster_program: false, rank: 5)
    @shelter_3 = Shelter.create(name: 'Fancy pets of Colorado', city: 'Denver, CO', foster_program: true, rank: 10)

    @pet_1 = @shelter_1.pets.create(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: false)
    @pet_2 = @shelter_1.pets.create(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)
    @pet_3 = @shelter_3.pets.create(name: 'Lucille Bald', breed: 'sphynx', age: 8, adoptable: true)
    @pet_4 = @shelter_1.pets.create(name: 'Ann', breed: 'ragdoll', age: 5, adoptable: true)
  end

  it 'displays all shelters in the system in reverse alphabetical order' do
    visit '/admin/shelters'

    expect(@shelter_2.name).to appear_before(@shelter_1.name)
    expect(@shelter_2.name).to appear_before(@shelter_3.name)
    expect(@shelter_1.name).to_not appear_before(@shelter_3.name)
  end

  xit 'displays a section for shelters with pending applications' do
    application_1 = Application.create!(applicant_name: Faker::Name.name, street_address: '131 Seward Lane', city: 'Longmont', state: 'Colorado', zip_code: '80501')
    application_1 << @pet_1
    visit "/applications/#{application_1.id}"
    fill_in :search, with: "#{@pet_1.name}"
    click_button 'Submit'
    click_button "Adopt #{@pet_1.name}"
    fill_in :description, with: 'Big, fenced backyard.'
    click_button('Submit your application')
    visit '/admin/shelters'

    within("#pending-apps") do
      expect(page).to have_content([@shelter_1.name])
    end

  end
end
