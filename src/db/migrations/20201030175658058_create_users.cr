class CreateUsers < Jennifer::Migration::Base
  def up
    create_table(:users) do |t|
      t.string :name, {:size => 12}

      t.timestamps
    end
  end

  def down
    drop_table :users if table_exists? :users
  end
end
