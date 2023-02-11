module Loaders
  module BookType
    def cover_url
      BatchLoader::GraphQL.for(object.id).batch do |book_ids, loader|
        Book.where(id: book_ids).with_attached_cover.each do |book|
          url = book.record_url(:cover)
          loader.call(book.id, url) 
        end
      end
    end

    def copy_count
      BatchLoader::GraphQL.for(object.id).batch(default_value: 0) do |book_ids, loader|
        total_copies = BookCopy.where(book_id: book_ids).group(:book_id).count
        book_ids.each do |id|
          loader.call(id, total_copies[id])
        end
      end
    end

    def read_count
      BatchLoader::GraphQL.for(object.id).batch(default_value: 0) do |book_ids, loader|
        total_reads = Reading.joins(:book_copy).where(book_copy: { book_id: book_ids }).group(:book_id).count
        book_ids.each do |id|
          loader.call(id, total_reads[id])
        end
      end
    end

    def author
      BatchLoader::GraphQL.for(object.author_id).batch(default_value: 0) do |author_ids, loader|
        User.where(id: author_ids).each do |author|
          loader.call(author.id, author) 
        end
      end
    end
  end
end