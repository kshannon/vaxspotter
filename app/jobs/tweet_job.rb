class TweetJob < ApplicationJob
  queue_as :default

  def perform(tweet)
    CLIENT.update(tweet)
  end
end
