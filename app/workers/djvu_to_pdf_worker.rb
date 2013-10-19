class DjvuToPdfWorker
  include Sidekiq::Worker


  def perform(book_id)
    book = Book.find(book_id)
    book.process!

    djvu_file = book.bookfile.file.file
    tiff_file = convert_djvu_to_tiff(djvu_file)
    pdf_file = convert_tiff_to_pdf(tiff_file)
    book.bookfile_pdf = File.open(pdf_file)
    book.save!
    book.finish_process!

    book.set_pages_count_and_cover
  end


  protected


  def convert_djvu_to_tiff(djvu_file)
    tiff_file = djvu_file[0..-6] + "_tmp.tiff"
    output = "#{Rails.root}/public/uploads/#{tiff_file}"
    command = "ddjvu -format=tiff -skip -quality=40 -mode=black -scale=150 #{djvu_file} #{output}"
    unless system(command)
      msg = "Can not convert DJVU to TIFF"
      Honeybadger.notify msg
      raise Exception.new(msg)
    end
    return tiff_file
  end


  def convert_tiff_to_pdf(tiff_file)
    pdf_file = tiff_file[0..-6] + "_tmp.pdf"
    output = "#{Rails.root}/public/uploads/#{pdf_file}"
    command = "jbig2 -p -s #{tiff_file} && pdf.py output > #{output}"
    unless system(command)
      msg = "Can not convert TIFF to PDF"
      Honeybadger.notify msg
      raise Exception.new(msg)
    end
    system("rm output.*")
    return pdf_file
  end
end
