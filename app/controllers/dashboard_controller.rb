class DashboardController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    data_providers = Location.group(:managed_by, :is_active).where.not( managed_by: [nil, ""] ).count
    @vaxspotter_providers = []
    data_providers.each do |key, value|
      if key[1] == true
        status = "active"
      else
        status = "false"
      end
      @vaxspotter_providers << {:name => key[0], :count => value, :status => status}
    end

  end
end