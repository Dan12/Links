class CreateTaglinks < ActiveRecord::Migration
  def change
    create_table :taglinks do |t|
      t.integer :tag_id
      t.integer :link_id

      t.timestamps null: false
    end
  end
end
