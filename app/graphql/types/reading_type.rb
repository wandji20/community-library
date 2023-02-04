module Types
  class ReadingType < Types::BaseObject
    field :id, Integer, null: false
    field :signed_at, GraphQL::Types::ISO8601DateTime, null: false
    field :returned_at, GraphQL::Types::ISO8601DateTime, null: true

    field :user, Types::UserType, null: false
    field :book, Types::BookType, null: false
    field :library, Types::LibraryType, null: false
    field :returned_library, Types::LibraryType, null: true
  end
end