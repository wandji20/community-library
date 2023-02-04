module Types
  class BookType < Types::BaseObject
    field :id, Integer, null: false
    field :title, String, null: false
    field :published_year, Integer, null: false

    field :author, Types::UserType, null: false
    field :library, Types::LibraryType, null: false
    field :copies, [Types::BookCopyType], null: true

    
    field :read_count, Integer, null: false
    field :copy_count, Integer, null: false
    field :cover_url, String, null: true
  end
end