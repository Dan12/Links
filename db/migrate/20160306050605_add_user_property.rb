class AddUserProperty < ActiveRecord::Migration
  def change
    add_column :tags, :user_id, :integer
    add_column :links, :user_id, :integer
  end
end
