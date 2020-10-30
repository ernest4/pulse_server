class AddCurrentMapToUsers < Jennifer::Migration::Base
  def up
    change_table :users do |t|
      t.add_column :current_map, :string

      t.add_index :name, :unique
    end
  end

  def down
    change_table :users do |t|
      t.drop_column :current_map

      t.drop_index :name
    end
  end
end
