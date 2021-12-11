require 'rails_helper'

RSpec.describe 'New Application Page', type: :feature do

  describe 'As a vistor' do
      describe 'the application new' do
        it 'renders the new form' do
          visit '/applications/new'

          expect(page).to have_content('New Application')
          expect(find('form')).to have_content('Name')
          expect(find('form')).to have_content('Address')
          expect(find('form')).to have_content('City')
          expect(find('form')).to have_content('State')
          expect(find('form')).to have_content('Zip')
        end

      describe 'the application create' do
        it 'can create a new application and redirect to the new apps show page' do
          visit '/applications/new'

          fill_in(:applicant_name, with: 'George')
          fill_in(:street_address, with: '34798 Kendall Way')
          fill_in(:city, with: 'Westminister')
          fill_in(:state, with: 'Colorado')
          fill_in(:zip_code, with: '80944')

          click_button('Submit')

          expect(current_path).to eq("/applications/#{Application.last.id}")
          expect(page).to have_content("George")
          expect(page).to have_content('34798 Kendall Way')
          expect(page).to have_content('Westminister')
          expect(page).to have_content('Colorado')
          expect(page).to have_content('80944')
        end
      end

      describe 'invalid application' do
        it 'flashes an error message that fields are incomplete and stays on same page' do
          visit '/applications/new'

          click_button('Submit')

          expect(page).to have_content("Error: Applicant name can't be blank, Street address can't be blank, City can't be blank, State can't be blank, Zip code can't be blank")
        end
      end
    end
  end
end
