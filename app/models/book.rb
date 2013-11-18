require 'open-uri'

class Book < ActiveRecord::Base
  MAX_BOOKS_COUNT = 7


  attr_accessible :bookcover, :bookfile, :good_name, :last_access, :name, :page, :pages_count, :user_id


  belongs_to :user
  has_one :dropbox_file
  has_one :local_file


  mount_uploader :bookcover, BookcoverUploader


  validate :max_books_count_validate, :on => :create


  before_save :set_default_page, :set_cover


  def progress
    return nil unless pages_count
    (((page.to_f-1) / pages_count)*100).to_i
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
