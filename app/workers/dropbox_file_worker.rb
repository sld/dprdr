class DropboxFileWorker
  include Sidekiq::Worker


  sidekiq_options :queue => :fast, :retry => true, :backtrace => true


  def perform book_id, metadata
    book = Book.find book_id

    book.update_column :name, metadata['path'].split("/").last
    book.update_column :dropbox_processing, true

    dropbox_file = book.build_dropbox_file

    dropbox_file.mime_type = metadata['mime_type']
    dropbox_file.modified = Time.parse(metadata['modified'])
    dropbox_file.path = metadata['path']
    dropbox_file.revision = metadata['revision']
    dropbox_file.size = metadata['size']

    if dropbox_file.save
      book.update_column :dropbox_processing, false
    else
      p ["Error on dropbox_file save", dropbox_file.errors.messages]
      book.delete
    end
  rescue Exception => e
    Honeybadger.notify e
    p e
    raise e if Rails.env == 'development'
  end
end

