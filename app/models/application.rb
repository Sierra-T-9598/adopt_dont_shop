class Application < ApplicationRecord
  validates_presence_of :applicant_name
  validates_presence_of :street_address
  validates_presence_of :city
  validates_presence_of :state
  validates_presence_of :zip_code
  validates :description, presence: true, on: :update
  validates_presence_of :status
  has_many :pet_applications
  has_many :pets, through: :pet_applications

  def change_status
    state = []
    pet_applications.each do |app|
      state << app.application_status
    end

    if state.include?("Rejected")
      self.status = "Rejected"
    else
      self.status = "Approved"
    end
  end
end
