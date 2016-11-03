class Admin::TeachersController < ApplicationController
  def new
    @teacher = Teacher.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @teacher }
    end
  end

  def edit
    @teacher = Teacher.find(params[:teacher][:id])
  end

  def create
  	params["teacher"]["password"] = generated_password = Devise.friendly_token.first(8)
     @teacher = Teacher.new(teacher_params)

    respond_to do |format|
      if @teacher.save
        format.html { redirect_to @teacher, notice: 'Teacher was successfully created.' }
        format.json { render json: @teacher, status: :created, location: @teacher }
      else
        format.html { render action: "new" }
        format.json { render json: @teacher.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
  	binding.pry
    @teacher = Teacher.find(params[:id])

    respond_to do |format|
      if @teacher.update_attributes(teacher_params)
        format.html { redirect_to @teacher, notice: 'teacher was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @teacher.errors, status: :unprocessable_entity }
      end
    end
  end
   private

  def teacher_params
    params.require(:teacher).permit(:id ,:first_name, :last_name, :middle_name, :phone, :email,  :school_id, :password)
  end
end
