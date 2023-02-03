class Reading < ApplicationRecord
  belongs_to :user
  belongs_to :book
  belongs_to :library
  belongs_to :returned_library, optional: true
end
