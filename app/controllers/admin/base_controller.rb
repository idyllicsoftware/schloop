class Admin::BaseController < ApplicationController
  include ApplicationHelper
  before_action :authenticate_user!
  before_filter :authorize_permission
end
