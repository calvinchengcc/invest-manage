class Address < ActiveRecord::Base
  has_many :users

  def to_s
    "#{street_address}, #{city}, #{country} #{postal_code}"
  end
end
