class Admin::SchoolsController < ApplicationController
	def new
	end

	def create
    new_school = School.new(user_params)
    new_school.save!
	end

  private

  def user_params
    params.require(:school).permit(:name, :address, :zip_code, :phone1, :phone2, :website, :code)
  end     
end
