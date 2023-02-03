class User < ApplicationRecord
  
  has_many :authored_books, class_name: 'Book', foreign_key: :author_id
  has_many :readings
  has_many :read_books, through: :readings, source: 'book'
  
  has_one_attached :avatar
  
  def avatar_url
    return Rails.application.routes.url_helpers.rails_blob_url(self.avatar) if self.avatar.attached?
  end

  def full_name
    "#{first_name} #{last_name}"
  end
end
