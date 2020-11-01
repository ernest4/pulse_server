class EditUsers < Jennifer::Migration::Base
  def up
    change_table :users do |t|
      t.add_column :uid, :string
      t.add_column :email, :string

      t.drop_column :name
      t.drop_column :current_map

      t.add_index :uid, :unique
    end
  end

  def down
    change_table :users do |t|
      t.drop_column :uid
      t.drop_column :email

      t.add_column :name, :string
      t.add_column :current_map, :string
    end
  end
end
