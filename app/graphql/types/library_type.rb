module Types
  class LibraryType < Types::BaseObject
    field :id, Integer, null: false
    field :name, String, null: false

    field :books, [Types::BookType], null: true
    field :readings, [Types::ReadingType], null: true
  end
end