class Fee < ActiveRecord::Base

  belongs_to :account
  belongs_to :user
  belongs_to :category
  has_many :feemoves, :dependent => :destroy

  validates_numericality_of :amount
  validates_numericality_of :fee_cant

  validates_presence_of :amount
  validates_presence_of :category_id
  validates_presence_of :account_id
  validates_presence_of :description
  validates_presence_of :fee_cant


end
