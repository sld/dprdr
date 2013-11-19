class DropboxFileWorker
  include Sidekiq::Worker


  sidekiq_options :queue => :fast, :retry => true, :backtrace => true


  def perform book_id, metadata
    book = Book.find book_id
    dropbox_file = book.build_dropbox_file

    dropbox_file.mime_type = metadata['mime_type']
    dropbox_file.modified = Time.parse(metadata['modified'])
    dropbox_file.path = metadata['path']
    dropbox_file.revision = metadata['revision']
    dropbox_file.size = metadata['size']

    book.update_column :name, metadata['path'].split("/").last

    dropbox_file.save!
  rescue Exception => e
    Honeybadger.notify e
    p e
    raise e if Rails.env == 'development'
  end
end

