module Loaders
  module BookCopyType
    def read_count
      BatchLoader::GraphQL.for(object.id).batch do |book_copy_ids, loader|
        total_read_count = Reading.where(book_copy_id: book_copy_ids).group(:book_copy_id).count
        book_copy_ids.each do |id|
          loader.call(id, total_read_count[id] || 0)
        end
      end
    end

    def current_reader
      BatchLoader::GraphQL.for(object.id).batch do |book_copy_ids, loader|
        readings = Reading.active.where(book_copy_id: book_copy_ids)
        readings.includes(:user).each do |reading|
          loader.call(reading.book_copy_id, reading.user)
        end
      end
    end
  end
end
