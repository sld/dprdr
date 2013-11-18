require 'spec_helper'

describe DropboxFile do
  context "#pdf" do
    it "should work with book in remote url" do
      user = FactoryGirl.create(:user)
      book = user.make_book
      dropbox_file = book.build_dropbox_file path: 'This/Is/Path'
      book.pages_count.should be_nil

      tmp_url = "https://dl.dropboxusercontent.com/u/30880202/RO_Lectures.pdf"
      dropbox_file.stubs(:tmp_url).returns(tmp_url)
      dropbox_file.save!

      book.reload

      book.pages_count.should == 20
    end
  end
end
