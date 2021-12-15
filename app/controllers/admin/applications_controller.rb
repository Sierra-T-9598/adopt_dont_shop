class Admin::ApplicationsController < ApplicationController
  def show
    @application = Application.find(params[:id])
    @pets = @application.pets
  end

  def update
    pet_application = PetApplication.find(params[:id])
    pet_application.update(application_status: params[:application_status])
    redirect_to "/admin/applications/#{pet_application.application.id}"
  end
end
