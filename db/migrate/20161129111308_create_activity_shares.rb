class CreateActivityShares < ActiveRecord::Migration
  def change
    create_table :activity_shares do |t|

      t.integer :activity_id, null: false
      t.integer :school_id, null: false
      t.integer :teacher_id, null: false
      t.integer :grade_id, null: false
      t.integer :division_id, null: false

      t.timestamps null: false
    end

    add_index :activity_shares, [:activity_id]
    add_index :activity_shares, [:school_id]
    add_index :activity_shares, [:school_id, :activity_id]
    add_index :activity_shares, [:grade_id, :division_id]
  end
end

