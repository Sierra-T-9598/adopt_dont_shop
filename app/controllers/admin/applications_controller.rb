class Admin::ApplicationsController < ApplicationController
  def show
    @application = Application.find(params[:id])
    @pets = @application.pets
    @approved_pets = []
    if params.include?(:pet_id)
      @approved_pets << Pet.find(params[:pet_id])
    end
  end

  def update
    pet_application = PetApplication.find(params[:id])
    pet_application.update(application_status: params[:application_status])

    redirect_to "/admin/applications/#{pet_application.application.id}"
  end
end
