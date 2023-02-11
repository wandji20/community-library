class Reading < ApplicationRecord
  belongs_to :user
  belongs_to :book_copy
  belongs_to :library
  belongs_to :returned_library, optional: true

  enum :status, { pending: 0, active: 1, completed: 2, past_due: 3, canceled: 4 }
end
