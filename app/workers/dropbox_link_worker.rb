class DropboxLinkWorker
  include Sidekiq::Worker


  sidekiq_options :queue => :medium, :retry => false, :backtrace => true


  def perform user_id, folder_name
    DropboxFile.make_books_from_dropbox user_id, folder_name
  rescue Exception => e
    Honeybadger.notify e
    p e
    raise e if Rails.env == 'development'
  end
end

