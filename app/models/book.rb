class Book < ActiveRecord::Base
  attr_accessible :bookcover, :bookfile, :good_name, :last_access, :name, :page, :pages_count, :user_id

  belongs_to :user
end
