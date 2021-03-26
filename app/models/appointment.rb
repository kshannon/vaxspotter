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
    if self.is_stale == true
      return puts "Will not tweet about saving/updating an appt to stale = true"
    end

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

    time_now = Time.zone.now.strftime("%l:%M%P").strip
    appt_date = "#{self.date.strftime("%b %d")}"
    tweet = "(#{time_now}) spotted availability at 👇\n\n#{location.name}\n#{location.address}\n\nAppointments on: #{appt_date}\n\nUse the link below to reserve a spot!\n\n#{location.appointment_url}"

    if Rails.env.production?
      TweetJob.perform_now(tweet)
    else
      puts '=================================================='
      puts tweet
      puts '==================  NEXT TWEET  =================='
    end


  end

end