class DropboxController < ApplicationController
  before_filter :authenticate_user!


  def folder_select
  end


  def link_data
    DropboxLinkWorker.perform_async current_user.id, params[:folder_name]
    redirect_to books_path
  end
end
