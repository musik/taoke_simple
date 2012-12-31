class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, :alert => exception.message
  end
  before_filter :update_cache_location

  private
  def update_cache_location
    if request.subdomain.present?
      ActionController::Base.page_cache_directory = "#{Rails.public_path}/cache/#{request.host}"
    end
  end

end
