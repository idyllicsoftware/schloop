class Admin::Teachers::BaseController < ApplicationController
  include ApplicationHelper
  before_action :authenticate_teacher!
  before_filter :authorize_permission
end
