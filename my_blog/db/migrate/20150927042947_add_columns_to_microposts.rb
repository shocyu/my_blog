class AddColumnsToMicroposts < ActiveRecord::Migration
  def change
    add_column :microposts, :posted_at, :datetime
    add_column :microposts, :status, :string
  end
end
