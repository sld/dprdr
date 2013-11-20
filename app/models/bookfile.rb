class Bookfile
  attr_reader :extension, :expires


  def initialize extension, hash
    @extension = extension
    @expires = hash[:expires]
    @url = hash[:url]

    @dropbox_client = hash[:dropbox_client]
    @dropbox_path = hash[:dropbox_path]
  end


  def url
    if @dropbox_client
      @url = dropbox_metadata['url']
    end
    @url
  end


  def expires
    dropbox_metadata['expires']
  end


  protected


  def dropbox_metadata
    @dropbox_metadata ||= @dropbox_client.media(@dropbox_path)
  end
end