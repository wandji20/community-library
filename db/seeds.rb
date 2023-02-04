class DatabaseBuilder
  def run
    destroy_data
    @files = prepare_images
    ActiveRecord::Base.transaction do
      create_users
      create_libraries
      create_books
      create_readings
    end
  end


  def prepare_images
    Dir.glob("public/images/*")
  end

  def destroy_data
    [ActiveStorage::Attachment, ActiveStorage::Blob, Reading, Book, Library, User].each do |klass|
      klass.destroy_all
      klass.connection.reset_pk_sequence!(klass.table_name, 'id')
    end
  end

  def create_users
    50.times do
      attr = {
        first_name: Faker::Name.first_name,
        last_name: Faker::Name.last_name
      }
      user = User.create!(attr)
      if user.persisted?
        file = @files.sample
        io = File.open(file)

        user.avatar.attach({
          io: io,
          filename: File.basename(file),
          content_type: "application/#{File.extname(file).sub('.', '')}",
          identify: false
        })
        io.rewind
      end
    end
  end

  def create_libraries
    10.times do
      Library.create!(name: Faker::Address.full_address)
    end
  end

  def create_books
    author_ids = User.order(id: :desc).take(10).pluck(:id)
    library_ids = Library.pluck(:id)
    author_ids.each do |author_id|
      rand(3..10).times do
        attrs = {
          author_id: author_id,
          title: Faker::Book.title,
          library_id: library_ids.sample,
          published_year: rand(1927..2023),
          read_period: rand(3..7)
        }
        book = Book.create!(attrs)
        if book.persisted?
          file = @files.sample
          io = File.open(file)
  
          book.cover.attach({
            io: io,
            filename: File.basename(file),
            content_type: "application/#{File.extname(file).sub('.', '')}",
            identify: false
          })
          io.rewind
          rand(5..10).times do
            book.copies.create!
          end
        end
      end
    end
  end

  def create_readings
    user_ids = User.order(id: :asc).take(40).pluck(:id)
    library_ids = Library.pluck(:id)
    BookCopy.all.shuffle.slice(rand(50..100), BookCopy.count).each do |copy|
      rand(2..15).times do |i|
        attr = {
          book_copy_id: copy.id,
          user_id: user_ids.sample,
          library_id: copy.book.library_id,
          status: [0,1,2,3].sample,
          signed_at: i.days.try([:ago, :from_now].sample),
          return_library_id: library_ids.sample
        }
        attr[:returned_at] = attr[:signed_at] + rand(1..8).days
        attr[:to_return_at] = attr[:signed_at] + copy.book.read_period.days
        attr[:status] = 1 if DateTime.now < attr[:to_return_at]
        Reading.create!(attr)
      end
    end
  end
end

DatabaseBuilder.new.run
