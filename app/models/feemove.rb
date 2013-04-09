class Feemove < ActiveRecord::Base
  belongs_to :fee
  belongs_to :move, :dependent => :destroy
end
