require 'active_support/concern'

module DjvuLocalExtension
  extend ActiveSupport::Concern


  included do
    after_commit :queue_to_process, :on => :create

    # Only if book not if PDF
    state_machine :djvu_state do
      event :enqueue do
        transition nil => :queued
      end

      event :process do
        transition :queued => :processing
      end

      event :finish_process do
        transition :processing => :finished
      end

      state :error
    end
  end


  def queue_to_process
    if book_djvu.file.present? && book_djvu.file.extension == "djvu"
      self.enqueue!
      DjvuToPdfWorker.perform_async(self.id)   #TODO: move to after transition
    end
  end
end