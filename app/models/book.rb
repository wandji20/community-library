class Book < ApplicationRecord
  belongs_to :library
  belongs_to :author, class_name: 'User'
  has_many :readings
  has_many :readers, through: :readings, source: 'user'

  has_one_attached :cover

  def total_reading
    readings.count
  end

  def cover_url
    return Rails.application.routes.url_helpers.rails_blob_url(self.cover) if self.cover.attached?
  end
end
