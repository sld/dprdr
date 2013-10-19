class Book < ActiveRecord::Base
  attr_accessible :bookcover, :bookfile, :good_name, :last_access, :name, :page, :pages_count, :user_id

  belongs_to :user

  mount_uploader :bookfile, BookfileUploader

  validate :file_size


  before_create :set_pages_count, :set_name, :set_page


  def progress
    (((page.to_f-1) / pages_count)*100).to_i
  end


  protected


  def file_size
    max_allowed_filesize = 20.0
    if bookfile.file.size.to_f/(1000*1000) > max_allowed_filesize
      errors.add(:bookfile, "You cannot upload a file greater than #{max_allowed_filesize}MB")
    end
  end


  def set_name
    if name.nil? && bookfile.present?
      self.name = bookfile.file.filename
    end
  end


  def set_page
    self.page = 1 unless self.page
  end


  def set_pages_count
    reader = PDF::Reader.new(bookfile.file.path)
    self.pages_count = reader.page_count
  end
end
