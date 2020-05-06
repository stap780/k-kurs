class HomeController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :redirect_to_subdomain
  # before_action :redirect_to_app_url

  # GET /homes
  # GET /homes.json
  def index
  end # index

  def index_setup
  end

  def show
    render template: "home/#{params[:page]}"
  end
end # class
