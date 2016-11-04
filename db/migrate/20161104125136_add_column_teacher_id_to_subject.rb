class AddColumnTeacherIdToSubject < ActiveRecord::Migration
  def change
    add_reference :subjects, :teacher, index: true, foreign_key: true
    add_reference :subjects, :division, index: true, foreign_key: true
  end
end
