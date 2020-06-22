class BooksController < ApplicationController
  def new
    @book = Book.new()
  end

  def index
    @books = current_user.books
  end

  def create
    @book = Book.new(book_params) 
    if @book.save
      @book.add_filename
      redirect_to @book
    else
      render :new
    end
  end

  def show
    @book = Book.find(params[:id])
  end

  def processing
    @book = Book.find(params[:id])
    @book.processing_file(params)
  end

  private
  def book_params
    params.require(:book).permit(:file).merge(user: current_user)
  end
end
