require 'date'

class AggregateTweetJob < ApplicationJob
  queue_as :default
  attr_accessor :aggregate_appts_to_tweet

  def perform()
    aggregate_appts
    unless aggregate_appts_to_tweet.empty?
      aggregate_appts_to_tweet.each do |tweet|
        build_publish_tweet(tweet)
      end
    end
  end

  def initialize
    @aggregate_appts_to_tweet = []
  end

  private

  def build_publish_tweet(tweet)
    if Rails.env.production?
      TweetJob.perform_now(tweet)
    else
      puts '========================================================'
      puts tweet
      puts '================  NEXT AGGREGATE TWEET  ================'
    end
  end

  def aggregate_appts
    active_record_obj = Location.joins(:appointments)
                                .select('locations.id, date, name, address, managed_by, appointments.updated_at, postal_code, appointment_url')
                                .where('appointments.updated_at > ?', 10.minutes.ago)
                                .where('is_stale = ?', false)
                                .all
    appointments = active_record_obj.to_a.map(&:serializable_hash)

    unique_providers = appointments.map { |h| h['managed_by'] }.uniq
    unique_providers.each do |provider|
      hash_to_tweet = {:provider => provider, :dates => [], :addresses => [], :postal_codes => [], :urls => []} #some urls might be unqiue, but all should lead to provider
      appointments.each do |appt|
        if appt['managed_by'] == provider
          hash_to_tweet[:dates] << appt['date']
          hash_to_tweet[:addresses] << appt['address']
          hash_to_tweet[:postal_codes] << appt['postal_code']
          hash_to_tweet[:urls] << appt['appointment_url']
        end
      end
      aggregate_appts_to_tweet << generate_tweet_text(hash_to_tweet)
    end
  end

  def generate_tweet_text(hash_to_tweet)
    num_locations = hash_to_tweet[:addresses].uniq.length
    provider = hash_to_tweet[:provider]
    tweet_line_header = "New appointments for #{num_locations} #{provider} location(s) on the following date(s):\n"

    appt_dates = []
    hash_to_tweet[:dates].each do |date|
      appt_dates << date.strftime('%A, %b %-m')
    end
    tweet_line_dates = "\n#{appt_dates.uniq.join("\n")}\n"

    postal_codes = hash_to_tweet[:postal_codes].uniq
    if postal_codes.all?(&:nil?) == false
      tweet_line_postal_codes = "\nIn these Postal Codes:\n#{postal_codes.map(&:to_i)}\n"
    else
      tweet_line_postal_codes = ""
    end

    url = hash_to_tweet[:urls].uniq[0] #first url is fine
    tweet_line_url = "\n#{url}\n\n"

    relay_station = '@CovaxSd @CovidVaccineSD @VaccineCa #TeamVaccine'
    tweet_line_footer = "#{relay_station}"

    return tweet_line_header + tweet_line_dates + tweet_line_postal_codes + + tweet_line_url + tweet_line_footer
  end
end