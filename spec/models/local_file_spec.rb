require 'spec_helper'

describe LocalFile do
  context "#pdf" do
    it "should set up pages count and bookcover to Book after creating" do
      user = FactoryGirl.create(:user)
      book = user.make_book

      book.bookcover.file.should be_nil
      book.local_file.should be_nil

      local_file = book.build_local_file
      local_file.book_pdf = File.open("#{Rails.root}/spec/support/files/book.pdf")
      local_file.save!

      book.reload
      book.bookcover.file.should_not be_empty
      book.local_file.book_pdf.file.should_not be_empty
    end
  end

  context "#djvu" do
    it "should enqueue to sidekiq if djvu is attached to local file" do
      user = FactoryGirl.create(:user)
      book = user.make_book

      local_file = book.build_local_file
      local_file.djvu_state.should be_nil
      local_file.book_djvu = File.open("#{Rails.root}/spec/support/files/book.djvu")
      local_file.save!
      local_file.reload
      local_file.djvu_state.to_sym.should == :queued



    end
  end
end
