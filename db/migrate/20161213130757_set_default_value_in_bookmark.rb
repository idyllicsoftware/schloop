class SetDefaultValueInBookmark < ActiveRecord::Migration
  def change
    change_column :bookmarks, :caption, :text, default: ""
    change_column :bookmarks, :preview_image_url, :string, default: ""
    change_column :bookmarks, :views, :integer, default: 0
    change_column :bookmarks, :likes, :integer, default: 0

    change_column :bookmarks, :title, :string, :null => false
    change_column :bookmarks, :preview_image_url, :string, :null => false
    change_column :bookmarks, :data, :text, :null => false
    change_column :bookmarks, :caption, :text, :null => false
    change_column :bookmarks, :data_type, :integer, :null => false
    change_column :bookmarks, :teacher_id, :integer, :null => false
    change_column :bookmarks, :subject_id, :integer, :null => false
    change_column :bookmarks, :grade_id, :integer, :null => false
    change_column :bookmarks, :school_id, :integer, :null => false
    change_column :bookmarks, :topic_id, :integer, :null => false
    change_column :bookmarks, :views, :integer, :null => false
    change_column :bookmarks, :likes, :integer, :null => false

  end
end
