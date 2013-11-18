class DjvuToPdfWorker
  include Sidekiq::Worker

  sidekiq_options :queue => :long, :retry => false, :backtrace => true


  def perform(local_file_id)
    local_file = LocalFile.find local_file_id

    local_file.process! if local_file.djvu_state?(:queued)

    djvu_file = local_file.book_djvu.file.file
    tiff_file = convert_djvu_to_tiff(djvu_file)
    pdf_file = convert_tiff_to_pdf(tiff_file)
    local_file.book_pdf = File.open(pdf_file)
    local_file.save!
    local_file.finish_process!

    local_file.send :set_book_pages_count
    local_file.send :set_book_cover
    system("rm #{pdf_file}")

  rescue
    local_file.djvu_state = :error
    local_file.save
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
    hex_digest = Digest::MD5.hexdigest(tiff_file[0..-6])
    pdf_file = "#{hex_digest}_tmp.pdf"
    output = "#{Rails.root}/public/uploads/#{pdf_file}"

    basename = "output-#{rand(1337)}-#{hex_digest}}"
    command = "jbig2 -b #{basename} -p -s #{tiff_file} && pdf.py #{basename} > #{output}"
    unless system(command)
      puts command
      msg = "Can not convert TIFF to PDF"
      Honeybadger.notify msg
      raise Exception.new(msg)
    end
    system("rm #{basename}.*")
    system("rm #{tiff_file}")
    return output
  end
end
