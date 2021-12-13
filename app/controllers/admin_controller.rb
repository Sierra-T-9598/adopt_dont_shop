class AdminController < ApplicationController
  def index
    @shelters = Shelter.all.by_name_reverse
  end
end
