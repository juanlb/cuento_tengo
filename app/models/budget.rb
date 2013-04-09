class Budget < ActiveRecord::Base

  belongs_to :user
  belongs_to :category

  validates_numericality_of :amount
  validates_presence_of :amount
  validates_presence_of :category_id


end
