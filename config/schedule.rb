# Use this file to easily define all of your local cron jobs.
# Using Heroku Scheduler in production for cron type jobs

# rails environment
set :environment, 'development'

# logs
log_path = '~/dev/vaxspotter/log'
set :output, {:standard => "#{log_path}/whenever.log", :error => "#{log_path}/whenever-error.log"}

# Simple test for ActiveJob
# every 1.minute do
#   runner "TestJob.perform_now" #note this requires you create a test_job.rb Job
# end

every 5.minutes do
  runner "VaccineSpotterV0ApiJob.perform_now"
end