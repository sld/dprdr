class Api::V1::BooksController < Api::V1::BaseController

  def save_page
    @book = Book.find(params[:id])
    raise CanCan::AccessDenied.new("This is not your book!", :read, @book) unless current_or_guest_user.books.include?(@book)
    @book.page = params[:page]
    if @book.save
      render nothing: true, status: 200
    else
      render json: @book.errors.to_json, status: 500
    end

  end

end
