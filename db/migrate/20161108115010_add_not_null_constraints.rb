class AddNotNullConstraints < ActiveRecord::Migration
  def change
  	change_column :divisions, :name, :string,  null: false
  	change_column :grades, :name, :string, null: false
	  change_column :subjects, :name, :string, null: false

  end
end
