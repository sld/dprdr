class BooksController < ApplicationController

  def index
    raise CanCan::AccessDenied.new("Sign In or Try Guest User!", :index, Book) unless is_guest? || current_user
  end


  def try_as_guest
    guest_user
    redirect_to action: :index
  end
end
