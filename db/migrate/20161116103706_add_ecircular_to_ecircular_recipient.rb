class AddEcircularToEcircularRecipient < ActiveRecord::Migration
  def change
    add_reference :ecircular_recipients, :ecircular, index: true, foreign_key: true
  end
end
