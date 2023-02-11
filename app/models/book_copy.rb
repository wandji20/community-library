class BookCopy < ApplicationRecord
  belongs_to :book
  has_many :readings

  def read_count
    readings.count
  end

  def current_reader
    readings.active.first&.user
  end
end
