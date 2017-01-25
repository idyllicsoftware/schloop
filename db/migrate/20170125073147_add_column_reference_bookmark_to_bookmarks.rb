class AddColumnReferenceBookmarkToBookmarks < ActiveRecord::Migration
  def change
    add_column :bookmarks, :reference_bookmark, :integer, default: 0
  end
end
