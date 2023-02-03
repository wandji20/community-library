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
    500.times do
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
      end
      io.rewind
    end
  end

  def create_libraries
    10.times do
      Library.create!(name: Faker::Address.full_address)
    end
  end

  def create_books
    author_ids = User.order(id: :desc).take(50).pluck(:id)
    library_ids = Library.pluck(:id)
    author_ids.each do |author_id|
      rand(8..25).times do
        attrs = {
          author_id: author_id,
          title: Faker::Book.title,
          library_id: library_ids.sample,
          published_year: (1927..2023),
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
        end
        io.rewind
      end
    end
  end

  def create_readings
    user_ids = User.order(id: :asc).take(450).pluck(:id)
    library_ids = Library.pluck(:id)
    Book.all.shuffle.slice(rand(300..500), Book.count).each do |book|
      rand(2..5).times do |i|
        attr = {
          book_id: book.id,
          user_id: user_ids.sample,
          library_id: book.library_id,
          status: [0,1].sample,
          use_period: rand(2..7),
          signed_at: i.days.try([:ago, :from_now].sample),
          return_library_id: library_ids.sample
        }
        attr[:returned_at] = attr[:signed_at] + rand(2..9).days
        Reading.create!(attr)
      end
    end
  end
end

DatabaseBuilder.new.run
