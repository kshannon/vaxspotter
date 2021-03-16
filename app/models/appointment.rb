class Appointment < ApplicationRecord
  belongs_to :location
  after_save_commit :build_publish_tweet

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      Appointment.create! row.to_hash
    end
  end

  private

  def build_publish_tweet
    location = Location.where("id = ?", self.location_id).first

    if self.start_time && self.end_time
      appt_times = "  #{self.start_time.strftime("%l:%M%P")} - #{self.end_time.strftime("%l:%M%P")}"
    else
      appt_times = ""
    end

    if self.vaccines_available
      vaccines_available = "  (#{self.vaccines_available} availble)"
    else
      vaccines_available = ""
    end

    appt_info = "#{self.date.strftime("%b %d")}#{appt_times}#{vaccines_available}"
    tweet = "#{location.name}\n#{location.address}\n\n#{appt_info}\n\n#{location.appointment_url}"

    if Rails.env.production?
      TweetJob.perform_now(tweet)
    else
      puts '=================================================='
      puts tweet
      puts '==================  NEXT TWEET  =================='
    end


  end

end
