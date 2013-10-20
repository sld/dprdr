class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  devise :omniauthable, :omniauth_providers => [:facebook]

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me, :is_guest
  attr_accessible :provider, :uid


  has_many :books


  before_create :set_default_book


  protected


  def set_default_book
    book = self.books.build
    book.bookfile = File.open("#{Rails.root}/public/Notes_from_the_Underground_NT.pdf")
    book.save!
  end

end
