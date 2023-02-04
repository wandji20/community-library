module Types
  class QueryType < Types::BaseObject
    include GraphQL::Types::Relay::HasNodeField
    include GraphQL::Types::Relay::HasNodesField

    field :books, [Types::BookType], null: true do
      argument :library_id, ID, required: false
    end

    def books(params = {})
      Book.where(params)
    end

    field :most_popular, [Types::BookType] do
      argument :library_id, ID, required: false
    end

    def most_popular(params = {})
      Book.where(params).most_popular
    end

    field :book, Types::BookType, null: true do
      argument :id, ID, required: true
      argument :library_id, ID, required: false
    end

    def book(params)
      Book.find_by(params)
    end
  end
end
