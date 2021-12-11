class ApplicationsController < ApplicationController

  def index
  end

  def show
    @application = Application.find(params[:id])
  end

  def new
    @application = Application.new
  end

  def create
    application = Application.new(app_params)
    application.save
    redirect_to "/applications/#{application.id}"
  end

  private
  def app_params
    params.permit(:id, :applicant_name, :street_address, :city, :state, :zip_code)
  end

end
