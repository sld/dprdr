require 'dropbox_sdk'
require 'open-uri'

class DropboxFile < ActiveRecord::Base
  include PdfExtension


  #FORMATS = ['djvu', 'pdf', 'epub', 'fb2']
  FORMATS = ['pdf']

  attr_accessible :path

  belongs_to :book
  has_one :user, :through => :book

  validate :user_files_uniqueness


  before_create :set_book_name


  def self.make_books_from_dropbox user_id, folder
    user = User.find(user_id)
    dropbox_client = DropboxClient.new user.dropbox_token

    folder_metadata = dropbox_client.metadata(folder)
    metadatas = all_files_in_dir_and_subs( dropbox_client, folder_metadata )
    metadatas.each do |metadata|
      book = user.make_book
      DropboxFileWorker.perform_async book.id, metadata
    end
  end


  def bookfile
    Bookfile.new( extension, { :dropbox_client => dropbox_client, :dropbox_path => path } )
  end


  def extension
    path.split('.').last
  end


  protected


  def set_book_name
    unless book.name
      book.update_column :name, path.split("/").last
    end
  end


  def dropbox_client
    @dropbox_client = DropboxClient.new user.dropbox_token
  end


  def tmp_url
    dropbox_client.media(path)['url']
  end


  def pdf_file_io
    unless temp_file_path && File.exist?(temp_file_path)
      temp_file_path = open( tmp_url )
    end
    File.open(temp_file_path)
  end


  def user_files_uniqueness
    user.dropbox_files.each do |dropbox_file|
      if "#{modified}#{revision}#{path}" == "#{dropbox_file.modified}#{dropbox_file.revision}#{dropbox_file.path}"
        errors.add(:base, "This #{modified}#{revision}#{path} Dropbox File already exists")
        break
      end
    end
  end


  # Ищем все файлы с форматами FORMATS в папке, с глубиной вхождения максимум +max_rec+
  def self.all_files_in_dir_and_subs dropbox_client, folder_metadata, result=[], curr_rec = 0, max_rec = 4
    folder_metadata["contents"].each do |file_metadata|
      if file_metadata["is_dir"] && curr_rec < max_rec
        all_files_in_dir_and_subs( dropbox_client, dropbox_client.metadata(file_metadata["path"]), result, curr_rec+1 )
      elsif FORMATS.include?(file_metadata["path"].split(".").last.downcase)
        result << file_metadata
      end
    end
    return result
  end
end
