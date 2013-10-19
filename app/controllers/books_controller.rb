class BooksController < ApplicationController
  before_filter :authenticate_user!, :only => [:new, :create]

  def index
    raise CanCan::AccessDenied.new("Sign In or Try Guest User!", :index, Book) unless is_guest? || current_user
    @books = current_or_guest_user.books.order("updated_at desc")
  end


  def new
    @book = Book.new
  end


  def create
    @book = Book.new params[:book]
    @book.user_id = current_user.id

    if @book.save
      flash[:success] = "Book successfully added"
      redirect_to action: :index
    else
      flash[:notice] = "Error on adding book"
      render action: :new
    end
  end


  def try_as_guest
    guest_user
    redirect_to action: :index
  end


  def viewer
    @book = Book.find params[:id]
    raise CanCan::AccessDenied.new("Can not read book! Is this yours?", :read, @book) unless current_or_guest_user.books.include?(@book)
    @book.update_column :last_access, Time.now
    @bookfile_url = (@book.bookfile.file.extension == 'pdf' ? @book.bookfile.url : @book.bookfile_pdf.url)
    render :layout => false
  end
end
