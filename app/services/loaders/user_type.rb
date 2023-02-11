module Loaders
  module UserType
    def avatar_url
      BatchLoader::GraphQL.for(object.id).batch do |user_ids, loader|
        User.where(id: user_ids).with_attached_avatar.each do |user|
          url = user.record_url(:avatar)
          loader.call(user.id, url) 
        end
      end
    end

    def authored_books
      BatchLoader::GraphQL.for(object.id).batch(default_value: []) do |author_ids, loader|
        Book.where(author_id: author_ids).each do |book|
          loader.call(book.author_id) { |authored_books| authored_books << book }
        end
      end
    end
  end
end