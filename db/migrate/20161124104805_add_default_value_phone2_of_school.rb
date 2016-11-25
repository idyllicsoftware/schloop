class AddDefaultValuePhone2OfSchool < ActiveRecord::Migration
  def change
  	change_column :schools, :phone2, :string, :default => 0
  end
end
