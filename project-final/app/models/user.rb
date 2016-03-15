class User < ActiveRecord::Base
  belongs_to :address
  has_many :owned_portfolios, class_name: 'Portfolio', foreign_key: 'owner_id'
  has_many :managed_portfolios, class_name: 'Portfolio', foreign_key: 'manager_id'
  enum role: [:user, :advisor, :admin]
  after_initialize :set_default_role, :if => :new_record?

  def set_default_role
    self.role ||= :user
  end

  def owned_portfolios
    Portfolio.where(owner_id: self.id)
  end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
