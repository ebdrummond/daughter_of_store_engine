class Role < ActiveRecord::Base
  attr_accessible :title
  has_many :user_stores

  def self.admin
    find_or_create_by_title(title: "admin")
  end

  def self.stocker
    find_or_create_by_title(title: "stocker")
  end

  def admin?
    self.title == "admin"
  end

  def stocker?
    self.title == "stocker"
  end
end
