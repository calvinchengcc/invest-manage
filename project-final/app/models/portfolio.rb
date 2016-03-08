class Portfolio < ActiveRecord::Base
  has_many :holdings, dependent: :restrict_with_error
  belongs_to :owner, class_name: 'User'
  belongs_to :manager, class_name: 'User'
end
