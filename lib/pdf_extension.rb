require 'active_support/concern'

# Need to tbe included in model with +belongs_to :book+ association
module PdfExtension
  extend ActiveSupport::Concern

  included do
    before_create :set_book_pages_count, :set_book_cover
  end


  def set_book_pages_count
    if pdf_file_io
      pdf = PDF::Reader.new(pdf_file_io)
      book.update_column :pages_count, pdf.page_count
    end
  end


  #TODO: test deletion after set
  def set_book_cover
    if pdf_file_io
      tmp_bookcover_name = Digest::MD5.hexdigest("#{pdf_file_io.object_id}_cover_#{Time.now.to_i}_#{rand(9999)}")
      to_delete_filepath = "#{Rails.root}/public/uploads/#{tmp_bookcover_name}.png"
      im = Magick::Image.read(pdf_file_io.path+"[0]")
      im[0].write to_delete_filepath

      book.bookcover = File.open(to_delete_filepath)
      book.save!

      File.delete to_delete_filepath
    end
  end


  def pdf_file_io
    raise NoMethodError
  end
end