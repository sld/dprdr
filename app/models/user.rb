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

  validates_presence_of :name


  before_create :set_default_books


  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    unless user
      user = User.create(name:auth.extra.raw_info.name,
                           provider:auth.provider,
                           uid:auth.uid,
                           email:auth.info.email,
                           password:Devise.friendly_token[0,20]
                           )
    end
    user
  end


  protected


  def set_default_books
    book = self.books.build
    book.name = "[Guest Book] Dostoyevsky, Notes from the Underground"
    book.bookfile = File.open("#{Rails.root}/public/Notes_from_the_Underground_NT.pdf")
    book.save!

    book = self.books.build
    book.name = "[Guest Book] Data-Intensive Text Processing with MapReduce"
    book.bookfile = File.open("#{Rails.root}/public/MapReduce-book-final.pdf")
    book.save!
  end

end
