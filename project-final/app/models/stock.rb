class Stock < ActiveRecord::Base
  belongs_to :exchange, primary_key: :code
  has_many :holdings
end
