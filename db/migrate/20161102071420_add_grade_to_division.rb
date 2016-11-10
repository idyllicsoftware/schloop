class AddGradeToDivision < ActiveRecord::Migration
  def change
    add_reference :divisions, :grade, index: true, foreign_key: true
  end
end
