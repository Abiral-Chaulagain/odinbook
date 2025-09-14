class ApplicationController < ActionController::Base
  # Include Devise helpers (automatically included by default)
  protect_from_forgery with: :exception

  # Ensure Devise helpers are available
  before_action :authenticate_user!
end
