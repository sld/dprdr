require 'open-uri'

class Book < ActiveRecord::Base
  MAX_BOOKS_COUNT = 7

  belongs_to :user
  has_one :dropbox_file, dependent: :destroy
  has_one :local_file, dependent: :destroy


  mount_uploader :bookcover, BookcoverUploader


  validate :max_books_count_validate, :on => :create


  before_save :set_default_page, :set_cover


  def progress
    return nil unless pages_count
    (((page.to_f-1) / pages_count)*100).to_i
  end


  def bookfile
    return local_file.bookfile if local_file
    return dropbox_file.bookfile if dropbox_file
  end


  def bookfile=(upload_file)
    filename = upload_file.original_filename if upload_file.respond_to?(:original_filename)
    filename ||= upload_file.path
    case filename.split(".").last
      when 'pdf'
        build_local_file :book_pdf => upload_file
      when 'djvu'
        build_local_file :book_djvu => upload_file
        self.update_column :name, filename.split("/").last #HACK!!!
      else
        raise ArgumentError.new("Undefined bookfile file extension")
    end
  end


  def url
    bookfile.url
  end


  def djvu_state
    local_file.try(:djvu_state)
  end

  def djvu_state?(state)
    local_file.try(:djvu_state?, state)
  end



  private


  def set_default_page
    self.page ||= 1
  end

  def set_cover
    self.bookcover ||= File.open("#{Rails.root}/public/bookcover.jpg")
  end


  def max_books_count_validate
    max_books_count = MAX_BOOKS_COUNT
    if self.user && self.user.books.count >= max_books_count
      errors.add(:books, "Books count can not be greater than #{max_books_count}")
    end
  end

end
