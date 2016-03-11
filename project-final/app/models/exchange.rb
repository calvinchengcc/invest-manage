class Exchange < ActiveRecord::Base
  has_many :stocks, primary_key: :code, inverse_of: :exchange
end
