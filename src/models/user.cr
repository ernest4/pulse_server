# TODO: specs??

class User < ApplicationRecord
  with_timestamps
  
  # TODO: has_many characters

  mapping(
    id: {type: Int32, primary: true},
    uid: String,
    email: String?,
    # current_map: {type: String, default: "hub_0"}, # TODO: put this on character !!!

    # gender: {type: String, default: "male", null: true},
    # age: {type: Int32, default: 10},
    # description: {type: String, null: true},
    # TODO: password...

    created_at: {type: Time, null: true},
    updated_at: {type: Time, null: true}
  )

  # TODO: re-evaluate. At the moment it makes sense to only permit one to stop one account from
  # ruling over multiple resources with multiple characters!
  has_many :characters, Character

  # has_many :addresses, Address
  # has_many :facebook_profiles, FacebookProfile
  # has_and_belongs_to_many :countries, Country
  # has_and_belongs_to_many :facebook_many_profiles, FacebookProfile, join_foreign: :profile_id
  # has_one :main_address, Address, {where { _main }}
  # has_one :passport, Passport

  # validates_inclusion :age, 13..75
  # validates_length :name, minimum: 1, maximum: 15
  # validates_with_method :name_check

  # scope :main { where { _age > 18 } }
  # scope :older { |age| where { _age >= age } }
  # scope :ordered { order(name: :asc) }

  # def name_check
  #   if @description && @description.not_nil!.size > 10
  #     errors.add(:description, "Too large description")
  #   end
  # end
end
