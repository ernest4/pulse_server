# TODO: specs ?!?!

# belongs to user (player master account)
# belongs to group (Platoon (for Sorce), Company (for sitizens), Crew (for pirates))
# level
# xp


# TODO:
# morality ???
# has many map edits?
# has_one inventory
# has_one bank_account (in game, with credit scores and loans etc)

class Character < ApplicationRecord
  with_timestamps

  mapping(
    id: {type: Int32, primary: true},
    name: String,
    current_map: {type: String, default: "hub_0"},
    user_id: Int32,
    created_at: {type: Time, null: true},
    updated_at: {type: Time, null: true}
  )

  belongs_to :user, User

  validates_length :name, maximum: 12
end


# u = User.all.relation(:characters).last; u.characters if u