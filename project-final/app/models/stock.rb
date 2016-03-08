class Stock < ActiveRecord::Base
  has_many :holdings
end
