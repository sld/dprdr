class BooksController < ApplicationController

  def index
    authorize! :index, Book
  end


  def try_as_guest
    guest_user
    redirect_to action: :index
  end
end
