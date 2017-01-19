class Admin::BaseController < ApplicationController
  include ApplicationHelper
  before_action :authenticate_user!
  before_filter :authorize_permission

  protected
  def authenticate_user!
    if user_signed_in?
      super
    else
      redirect_to root_path
    end
  end
end
