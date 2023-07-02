class BooksController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]

  def show
    @q = Book.ransack(params[:q])
    @book = Book.find(params[:id])
    @book_comment = BookComment.new
  end

  def index
    @q = Book.ransack(params[:q])
    @books = Book.all
    @book = Book.new
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      redirect_to book_path(@book), notice: "You have created book successfully."
    else
      @books = Book.all
      render 'index'
    end
  end

  def edit
  end

  def update
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
    @book.destroy
    redirect_to books_path
  end
  
  def search
    @q = Book.ransack(params[:q])
    @searches = @q.result(distinct: true)
  end

  private

  def book_params
    params.require(:book).permit(:title, :body)
  end
  
  def search_params
    params.require(:q).permit!
  end

  def ensure_correct_user
    @book = Book.find(params[:id])
    unless @book.user == current_user
      redirect_to books_path
    end
  end
end
