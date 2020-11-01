class CreateCharacters < Jennifer::Migration::Base
  def up
    create_table :characters do |t|
      t.string :name, {:size => 12}
      t.string :current_map

      t.reference :user

      t.index :name, :unique

      t.timestamps
    end
  end

  def down
    drop_table :characters if table_exists? :characters
  end
end
