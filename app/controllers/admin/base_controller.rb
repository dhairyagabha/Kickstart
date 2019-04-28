module Admin
  class BaseController < ActionController::Base
    protect_from_forgery with: :exception
    before_action :authenticate_admin

    layout 'admin/application'

    protected
    def authenticate_admin
      redirect_to '/', alert: 'Not authorized.' unless user_signed_in? && current_user.admin?
    end

  end
end