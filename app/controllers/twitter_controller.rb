class TwitterController < ApplicationController
  before_action :authentication_required!

  def test_tweet
    CLIENT.update("I'm a prod test tweet")
  end

  def get_tweets
     # batch_size = 10
    # @twitter_handle = ""
    # @tweets = @client.user_timeline(@twitter_handle).take(batch_size)
  end

end