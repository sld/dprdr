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
      @url = @dropbox_client.media(@dropbox_path)['url']
    end
    @url
  end
end