class Book < ApplicationRecord
  belongs_to :user
  has_many :book_comments
  has_many :favorites
  
  validates :title,presence:true
  validates :body,presence:true,length:{maximum:200}
  
  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end
  def self.ransackable_attributes(auth_object = nil)
    ["body", "created_at", "id", "title", "updated_at", "user_id"]
  end
  def self.ransackable_associations(auth_object = nil)
    ["book_comments", "favorites", "user"]
  end
end
