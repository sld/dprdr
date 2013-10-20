class DjvuToPdfWorker
  include Sidekiq::Worker

  sidekiq_options :queue => :long, :retry => false, :backtrace => true


  def perform(book_id)
    book = Book.find(book_id)

    book.process! if book.djvu_state?(:queued)

    djvu_file = book.bookfile.file.file
    tiff_file = convert_djvu_to_tiff(djvu_file)
    pdf_file = convert_tiff_to_pdf(tiff_file)
    book.bookfile_pdf = File.open(pdf_file)
    book.save(validate: false)
    book.finish_process!

    book.set_pages_count_and_cover

  rescue
    book.djvu_state = :error
    book.save
  end


  protected


  def convert_djvu_to_tiff(djvu_file)
    tiff_file = Digest::MD5.hexdigest(djvu_file[0..-6]).to_s + "_tmp.tiff"
    output = "#{Rails.root}/public/uploads/#{tiff_file}"
    command = "ddjvu -format=tiff -skip -quality=80 -mode=black -scale=150 #{djvu_file} #{output}"
    unless system(command)
      msg = "Can not convert DJVU to TIFF"
      Honeybadger.notify msg
      raise Exception.new(msg)
    end
    return output
  end


  def convert_tiff_to_pdf(tiff_file)
    pdf_file = Digest::MD5.hexdigest(tiff_file[0..-6]).to_s + "_tmp.pdf"
    output = "#{Rails.root}/public/uploads/#{pdf_file}"
    command = "jbig2 -p -s #{tiff_file} && pdf.py output > #{output}"
    unless system(command)
      puts command
      msg = "Can not convert TIFF to PDF"
      Honeybadger.notify msg
      raise Exception.new(msg)
    end
    system("rm output.*")
    system("rm #{tiff_file}")
    return output
  end
end
