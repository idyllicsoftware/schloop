class CreateSchools < ActiveRecord::Migration
  def change
    create_table :schools do |t|

      t.string      :name, null: false
      t.text        :address, null: false
      t.string      :zip_code, null: false
      t.string      :phone1, null: false
      t.string      :phone2
      t.string      :website, null: false
      t.references  :school_director

      t.timestamps null: false
    end
  end
end
