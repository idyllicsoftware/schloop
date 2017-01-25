class Admin::Teachers::BaseController < ApplicationController
  include ApplicationHelper
  before_action :authenticate_teacher!
  before_filter :authorize_permission

  protected
  def authenticate_teacher!
    if teacher_signed_in?
      super
    else
      redirect_to root_path
    end
  end
end

