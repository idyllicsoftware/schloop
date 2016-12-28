class HomeController < ApplicationController

  def index
  	@user = current_user
  end

  def privacy_policy
    
  end

end

