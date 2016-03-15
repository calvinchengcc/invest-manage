class Address < ActiveRecord::Base
  has_many :users

  def full_address
    "#{street_address}, #{city}, #{country} #{postal_code}"
  end
end
