require 'spec_helper'

describe Book do
  describe "#bookfile=(file)" do
    before do
      user = FactoryGirl.create(:user)
      @book = user.make_book
    end

    it "should work with .pdf file" do
      @book.bookfile.should be_nil
      @book.bookfile = File.open "#{Rails.root}/spec/support/files/book.pdf"
      @book.save!
      @book.reload
      @book.bookfile.url.should_not be_nil
    end

    it "should work with .djvu file" do
      @book.bookfile.should be_nil
      @book.bookfile = File.open "#{Rails.root}/spec/support/files/book.djvu"
      @book.save!
      @book.reload
      @book.local_file.djvu_state.to_sym.should == :queued
    end
  end
end