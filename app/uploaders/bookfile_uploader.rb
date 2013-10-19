# encoding: utf-8

class BookfileUploader < CarrierWave::Uploader::Base

  CarrierWave::SanitizedFile.sanitize_regexp = /[^[:word:]\.\-\+]/


  storage :file


  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end


  def extension_white_list
     %w(pdf djvu)
  end


  def filename
    if original_filename
      @name ||= Digest::MD5.hexdigest(File.dirname(current_path)+Time.now.to_i.to_s+rand(8910).to_s)
      "#{@name}.#{file.extension}"
    end
  end

end
