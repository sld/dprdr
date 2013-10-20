class HomeController < ApplicationController
  def index
    if params[:screenshot] == "true"
      filepath = "#{Rails.root}/public/screenshoot-dpreader.png"
      render :text => File.open(filepath, 'rb').read,
             :status => 200, :content_type => 'image/png'

    end
  end
end
