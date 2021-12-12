class PetApplicationsController < ApplicationController
  def create
    @application = Application.find(params[:application])
    @pet = Pet.find(params[:pet])
    pet_application = PetApplication.create(pet: @pet, application: @application)
    pet_application.save
    redirect_to "/applications/#{@application.id}"
  end
end
