class BooksController < ApplicationController

  def index
    raise CanCan::AccessDenied.new("Sign In or Try Guest User!", :index, Book) unless is_guest? || current_user
    @books = current_or_guest_user.books
  end


  def try_as_guest
    guest_user
    redirect_to action: :index
  end


  def viewer
    @book = Book.find params[:id]
    authorize! :read, @book

    render :layout => false
  end
end
