class ApplicationController < ActionController::Base
  # protect_from_forgery with: :exception
  protect_from_forgery with: :null_session

  before_action :authenticate_user!
  # Every logged in user should be redirected to their own subdomain
  before_action :redirect_to_subdomain
  before_action :allow_cross_domain_ajax
  helper_method :current_admin

  def allow_cross_domain_ajax
      headers['Access-Control-Allow-Origin'] = '*'
      headers['Access-Control-Request-Method'] = 'GET, POST, OPTIONS'
  end

  private

  def after_sign_in_path_for(resource_or_scope)
    puts resource_or_scope.subdomain + " - это из ApplicationController - after_sign_in_path_for"
    dashboard_index_url(subdomain: resource_or_scope.subdomain)
  end # after_sign_in_path_for


  def invoice_path_for(resource_or_scope)
    invoices_url(subdomain: resource_or_scope.subdomain)
  end # invoice_path_for


  def redirect_to_subdomain
    return if self.is_a?(DeviseController)
    if request.subdomain.present?
      if current_user.present? && request.subdomain != current_user.subdomain
        subdomain = current_user.subdomain
        host = request.host_with_port.sub!("#{request.subdomain}", subdomain)
        redirect_to "http://#{host}#{request.path}"
      end
    end
  end # redirect_to_subdomain


  def redirect_to_app_url
    return if request.subdomain.present? && request.subdomain == 'app'

    url = app_url
    redirect_to url

  end # redirect_to_app_url


  def app_url
    subdomain = 'app.'
    # puts request.subdomain.present?
    if request.subdomain.present?
      host = request.host_with_port.sub! "#{request.subdomain}.", ''
    else
      host = request.host_with_port
      # puts host
    end # if

    # "http://#{subdomain}.#{host}#{request.path}"
    "http://"+"#{subdomain}"+"#{host}"+"#{request.path}"


  end # app_url


  def current_admin
    if current_user.present?
      admin1 = ENV["ADMIN1"]
      admin2 = ENV["ADMIN2"]
      current_user.subdomain == admin1 || current_user.subdomain == admin2
    end
  end


end # class
