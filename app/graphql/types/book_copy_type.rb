module Types
  class BookCopyType < Types::BaseObject
    include Loaders::BookCopyType

    field :id, Integer, null: false
    field :current_reader, Types::UserType, null: true
    field :read_count, Integer, null: false
  end
end