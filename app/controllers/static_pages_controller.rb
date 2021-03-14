class StaticPagesController < ApplicationController
  skip_before_action :authenticate_user!

  def about
  end

  def help
  end

  def disclaimer
  end
end