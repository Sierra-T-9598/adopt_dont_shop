class Admin::SheltersController < ApplicationController
  def index
    @shelters = Shelter.all.by_name_reverse
    @shelters_pending = Shelter.all.pending_apps
  end
end
