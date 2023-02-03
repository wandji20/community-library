class Library < ApplicationRecord
  has_many :books
  has_many :readings
end
