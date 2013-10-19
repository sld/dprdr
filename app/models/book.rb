class Book < ActiveRecord::Base
  attr_accessible :bookcover, :bookfile, :good_name, :last_access, :name, :page, :pages_count, :user_id

  belongs_to :user

  mount_uploader :bookfile, BookfileUploader
  mount_uploader :bookcover, BookcoverUploader

  validate :validate_file_size


  before_create :set_name, :set_page
  after_create :set_pages_count_and_cover


  def progress
    (((page.to_f-1) / pages_count)*100).to_i
  end


  private


  def validate_file_size
    max_allowed_filesize = 20.0
    if bookfile.file.size.to_f/(1000*1000) > max_allowed_filesize
      errors.add(:bookfile, "You cannot upload a file greater than #{max_allowed_filesize}MB")
    end
  end


  def set_name
    if name.blank? && bookfile.present?
      self.name = bookfile.file.filename
    end
  end


  def set_page
    self.page = 1 unless self.page
  end


  def set_pages_count_and_cover
    pdf = PDF::Reader.new(self.bookfile.file.path)
    self.pages_count = pdf.page_count

    to_delete_filepath = "#{Rails.root}/public/uploads/#{bookfile.file.filename.split(".").first}_c11over.png"
    im = Magick::Image.read(self.bookfile.file.path+"[0]")
    im[0].write to_delete_filepath
    self.bookcover = File.open(to_delete_filepath)
    save!
    File.delete to_delete_filepath
  end

end
