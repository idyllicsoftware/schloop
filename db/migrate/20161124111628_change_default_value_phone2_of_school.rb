class ChangeDefaultValuePhone2OfSchool < ActiveRecord::Migration
  def change
  	  	change_column :schools, :phone2, :string, :default => nil

  end
end
