desc "get locations and appointments from www.vaccinespotter.org API v0"
task vaccine_spotter_v0_api_pull: :environment do
  puts "Running the VaccineSpotterV0ApiJob job now!"
  VaccineSpotterV0ApiJob.perform_now
  puts "Finish doing the thing!"
end