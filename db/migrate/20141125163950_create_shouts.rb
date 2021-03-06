class CreateShouts < ActiveRecord::Migration
  def up
    create_table :shouts do |t|
      t.string      :message, null: false
      t.string      :name, null: false
      t.string      :klass, null: false
      t.belongs_to  :user

      t.timestamps
    end
  end

  def down
    drop_table :shouts
  end
end
