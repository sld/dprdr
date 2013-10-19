class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me, :is_guest


  has_many :books

  validate :max_books_count_validate

  before_create :set_default_book


  protected


  def max_books_count_validate
    max_books_count = 5
    if books.count > max_books_count
      errors.add(:books, "Books count can not be greater than #{max_books_count}")
    end
  end


  def set_default_book
    book = self.books.build
    book.bookfile = File.open("#{Rails.root}/public/Notes_from_the_Underground_NT.pdf")
    book.save!
  end

end
