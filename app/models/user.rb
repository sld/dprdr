class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  devise :omniauthable, :omniauth_providers => [:facebook] #NOTE: uncomment to add dropbox #, :dropbox]

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me, :is_guest
  attr_accessible :provider, :uid

  attr_accessor :just_created

  has_many :books
  has_many :local_files, :through => :books
  has_many :dropbox_files, :through => :books

  validates_presence_of :name

  before_create :set_default_books_if_guest


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


  def self.find_for_dropbox_oauth(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid.to_s).first
    unless user
      user = User.create(name:auth.extra.raw_info.display_name,
                           provider:auth.provider,
                           uid:auth.uid,
                           email:auth.extra.raw_info.email,
                           password:Devise.friendly_token[0,20]
                           )
      user.just_created = true
    end
    user.update_column :dropbox_token, auth.credentials.token

    user
  end


  def make_book
    ActiveRecord::Base.transaction do
      book = books.build
      book.save(validate: false)
      book
    end
  end


  def dropbox_user?
    provider.to_sym == :dropbox
  end


  protected


  def set_default_books_if_guest
    if is_guest?
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

end
