class BooksController < ApplicationController

  def index
    authorize! :index, Book
  end
end
