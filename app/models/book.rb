class Book < ApplicationRecord
  belongs_to :library
  belongs_to :author, class_name: 'User'

  has_many :copies, class_name: 'BookCopy'

  has_one_attached :cover

  def read_count
    copies.joins(:readings).count
  end

  def copy_count
    copies.count
  end

  def self.most_popular
    top_books = Reading.joins(:book_copy)
      .group("book_copies.book_id")
      .count.sort_by{|k_, v| v}.to_h
    Book.where(id: top_books.keys)
  end

  def cover_url
    return Rails.application.routes.url_helpers.rails_blob_url(self.cover) if self.cover.attached?
  end
end
