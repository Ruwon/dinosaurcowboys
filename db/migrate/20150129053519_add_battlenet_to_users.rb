class AddBattlenetToUsers < ActiveRecord::Migration
  def change
    add_column :users, :battlenet, :string
  end
end
