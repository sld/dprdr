class DropboxController < ApplicationController
  before_filter :authenticate_user!
  before_filter :check_is_user_dropbox


  def folder_select
  end


  def link_data
    current_user.update_column :dropbox_folder, params[:folder_name]
    DropboxLinkWorker.perform_async current_user.id, params[:folder_name]
    redirect_to books_path
  end


  def refresh_folder
    DropboxLinkWorker.perform_async current_user.id, current_user.dropbox_folder
    redirect_to :back
  end


  private


  def check_is_user_dropbox
    unless current_user.dropbox_user?
      raise CanCan::AccessDenied.new("You cannot access to Dropbox part because you are not linked Dropbox account",
                                     :dropbox, DropboxFile)
    end
  end
end
