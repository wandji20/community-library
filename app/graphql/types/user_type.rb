module Types
  class UserType < Types::BaseObject
    include Loaders::UserType

    field :id, ID, null: false
    field :first_name, String, null: false
    field :last_name, String, null: false

    field :authored_books, [Types::BookType], null: true
    field :read_books, [Types::BookType], null: true

    field :full_name, String, null: false
    field :avatar_url, String, null: true
  end
end