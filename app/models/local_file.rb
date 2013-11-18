class LocalFile < ActiveRecord::Base
  include PdfExtension
  include DjvuLocalExtension


  attr_accessible :book_djvu, :book_pdf, :djvu_state


  mount_uploader :book_pdf, BookfileUploader
  mount_uploader :book_djvu, BookfileUploader


  belongs_to :book


  before_save :set_book_name_from_pdf
  validate :validate_pdf_file_size


  def pdf_file_io
    File.open( book_pdf.file.file ) if book_pdf.file
  end


  protected


  def validate_pdf_file_size
    max_allowed_filesize = 50.0
    if self.book_pdf.file && self.book_pdf.file.size.to_f/(1000*1000) > max_allowed_filesize
      errors.add(:base, "You cannot upload a pdf file greater than #{max_allowed_filesize}MB")
    end
  end


  def set_book_name_from_pdf
    if !book.name && pdf_file_io.present?
      book.update_column :name, pdf_file_io.path.split("/").last
    end
  end


end
