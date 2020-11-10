class AddLastXLastYSpeedToCharacter < Jennifer::Migration::Base
  def up
    change_table :characters do |t|
      t.add_column :last_x, :integer
      t.add_column :last_y, :integer
      t.add_column :speed, :integer
    end
  end

  def down
    change_table :characters do |t|
      t.drop_column :last_x
      t.drop_column :last_y
      t.drop_column :speed
    end
  end
end
