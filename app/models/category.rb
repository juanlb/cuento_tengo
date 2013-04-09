class Category < ActiveRecord::Base

  belongs_to :user
  has_many :moves
  has_many :previsions
  has_many :sched_previsions
  has_many :fees

  validates_presence_of :name

  def self.all_parents(user)
    self.find(:all, :conditions => ["user_id = ? AND parent_category_id IS NULL", user.id], :order => "name ASC" )
  end

  def children_categories
    Category.find(:all, :conditions => ["user_id = ? AND parent_category_id = ?", user.id, self.id], :order => "name ASC")
  end

  def self.all_categories(user)
    result = []
    all_parents(user).each do |parent|
      result << parent
      parent.children_categories.each do |child|
        result << child
      end
    end
    result
  end

  def format_name
    self.parent_category_id.blank? ? self.name : "-- #{self.name}"
  end

end
