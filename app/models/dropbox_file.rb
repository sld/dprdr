require 'dropbox_sdk'
require 'open-uri'

class DropboxFile < ActiveRecord::Base
  FORMATS = ['djvu', 'pdf', 'epub', 'fb2']

  attr_accessible :path

  include PdfExtension

  belongs_to :book
  has_one :user, :through => :book

  before_create :set_book_name


  def self.make_books_from_dropbox user_id, folder
    user = User.find(user_id)
    dropbox_client = DropboxClient.new user.dropbox_token

    folder_metadata = dropbox_client.metadata(folder)
    metadatas = all_files_in_dir_and_subs( folder_metadata )
    metadatas.each do |metadata|
      book = user.books.build
      book.save(validate: false)

      dropbox_file = book.build_dropbox_file

      dropbox_file.mime_type = metadata['mime_type']
      dropbox_file.modified = Time.parse(metadata['modified'])
      dropbox_file.path = metadata['path']
      dropbox_file.revision = metadata['revision']
      dropbox_file.size = metadata['size']

      dropbox_file.save!
    end
  end


  def bookfile
    dropbox_metadata = dropbox_client.media(path)
    keys = dropbox_metadata.keys
    Struct.new(*keys).new(*keys.map { |k| dropbox_metadata[k] })
  end


  protected


  def set_book_name
    unless book.name
      book.update_column :name, path.split("/").last
    end
  end


  def dropbox_client
    @dropbox_client ||= DropboxClient.new user.dropbox_token
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


  # Ищем все файлы с форматами FORMATS в папке, с глубиной вхождения максимум +max_rec+
  def self.all_files_in_dir_and_subs folder_metadata, result=[], curr_rec = 0, max_rec = 4
    folder_metadata["contents"].each do |file_metadata|
      if file_metadata["is_dir"] && curr_rec < max_rec
        all_files_in_dir_and_subs @dropbox_client.metadata(file_metadata["path"]), result, curr_rec+1
      elsif FORMATS.include?(file_metadata["path"].split(".").last.downcase)
        result << file_metadata
      end
    end
    return result
  end
end
