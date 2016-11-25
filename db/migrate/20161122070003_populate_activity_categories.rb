class PopulateActivityCategories < ActiveRecord::Migration
  def up
    Rake::Task['populate_activity_categories'].invoke
  end

  def down
  end
end
