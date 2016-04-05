class Exchange < ActiveRecord::Base
  has_many :stocks

  def to_s
    "#{name} (#{code})"
  end
end
