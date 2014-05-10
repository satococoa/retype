class StaticsController < ApplicationController
  def index
    redirect_to sites_url if user_signed_in?
  end
end
