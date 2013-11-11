class Book < ActiveRecord::Base
  MAX_BOOKS_COUNT = 7

  attr_accessible :bookcover, :bookfile, :good_name, :last_access, :name, :page, :pages_count, :user_id

  belongs_to :user

  mount_uploader :bookfile, BookfileUploader
  mount_uploader :bookfile_pdf, BookfileUploader
  mount_uploader :bookcover, BookcoverUploader

  validate :validate_file_size
  validate :max_books_count_validate, :on => :create


  before_create :set_name, :set_page, :set_cover
  after_create :set_pages_count_and_cover
  after_commit :check_is_only_djvu, :on => :create


  def progress
    return nil unless pages_count
    (((page.to_f-1) / pages_count)*100).to_i
  end


  # Only if book not if PDF
  state_machine :djvu_state do
    event :enqueue do
      transition nil => :queued
    end

    event :process do
      transition :queued => :processing
    end

    event :finish_process do
      transition :processing => :finished
    end

    state :error
  end

  def set_pages_count_and_cover
    if pdf_file
      file_pdf = pdf_file
      pdf = PDF::Reader.new(file_pdf.path)
      self.pages_count = pdf.page_count

      to_delete_filepath = "#{Rails.root}/public/uploads/#{file_pdf.filename.split(".").first}_cover_#{Time.now.to_i}_#{rand(9999)}.png"
      im = Magick::Image.read(file_pdf.path+"[0]")
      im[0].write to_delete_filepath

      self.bookcover = File.open(to_delete_filepath)

      save!
      File.delete to_delete_filepath
    end
  end


  def pdf_file
    return bookfile if bookfile.file.try(:extension) == 'pdf'
    return bookfile_pdf if bookfile_pdf.file.try(:extension) == 'pdf'
    return nil
  end


  private


  def check_is_only_djvu
    if bookfile.file.extension == 'djvu' && bookfile_pdf.file.nil?
      self.enqueue!
      DjvuToPdfWorker.perform_async(self.id)   #TODO: move to after transition
    end
  end


  def set_name
    if name.blank? && bookfile.file
      self.name = bookfile.file.filename
    end
  end

  def set_page
    self.page = 1 unless self.page
  end

  def set_cover
    self.bookcover ||= File.open("#{Rails.root}/public/bookcover.jpg")
  end


  def validate_file_size
    max_allowed_filesize = 30.0
    if self.bookfile.file.size.to_f/(1000*1000) > max_allowed_filesize
      errors.add(:bookfile, "You cannot upload a file greater than #{max_allowed_filesize}MB")
    end
  end


  def max_books_count_validate
    max_books_count = MAX_BOOKS_COUNT
    if self.user && self.user.books.count >= max_books_count
      errors.add(:books, "Books count can not be greater than #{max_books_count}")
    end
  end

end
