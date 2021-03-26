desc "get locations and appointments from www.vaccinespotter.org API v0"
task vaccine_spotter_v0_api_pull: :environment do
  puts "Running the VaccineSpotterV0ApiJob job now......"
  VaccineSpotterV0ApiJob.perform_now
  puts "Finished doing the thing!!!"
end

desc "get new and active appts and publish aggregated tweet"
task aggregate_tweet_job: :environment do
  puts "Running the AggregateTweetJob job now......"
  AggregateTweetJob.perform_now
  puts "Finished doing the thing!!!"
end