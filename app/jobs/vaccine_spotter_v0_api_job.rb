#Consumes a url.json file from the Version 0 vaccine spotter API.
# https://github.com/GUI/covid-vaccine-spotter
# API changes: https://github.com/GUI/covid-vaccine-spotter/discussions/27


class VaccineSpotterV0ApiJob < ApplicationJob
  queue_as :default

  def perform(*args)
    #grab and parse json data
    source = ENV['VACCINE_SPOTTER_V0_API_SOURCE']
    resp = Net::HTTP.get_response(URI.parse(source))
    data = resp.body
    result = JSON.parse(data) #returns a Hash

    features = result["features"] #an array of hashes is under features key
    vaxspotter_locations = vaxspotter_locations()

    features.each do |objs|
      obj = flatten_hash(objs)

      if obj[:"properties.postal_code"].nil? || obj[:"properties.address"].nil? || obj[:"properties.url"].nil?
        next
      end

      location_params_hash = {
        api_id: obj[:"properties.id"],
        name: obj[:"properties.name"],
        address: obj[:"properties.address"],
        city: obj[:"properties.city"],
        postal_code:  obj.fetch(:"properties.postal_code", ''),
        appointment_url: obj[:"properties.url"],
        managed_by: obj[:"properties.provider_brand_name"], #prefer this name to brand_name
        location_type: 4, #Assume all locations from this API are pharmacies so enum = 4
        longitude: obj[:"geometry.coordinates"][0],
        latitude: obj[:"geometry.coordinates"][-1],
        state: obj[:"properties.state"],
        appointments_last_fetched: obj[:"properties.appointments_last_fetched"] #format: "2021-02-24T23:36:37.222+00:00"
      }

      appointment_params_hash = {
        appointments: obj.fetch(:"properties.appointments", []), #array, empty array or nil?
        vaccines_available: obj.fetch(:"properties.appointments_available", false),
        appointments_last_fetched: obj[:"properties.appointments_last_fetched"] #format: "2021-02-24T23:36:37.222+00:00"
      }

      # parsed_appointments = parse_appointments()

      if Area.find_by(postal_code: location_params_hash[:postal_code]) #check if location falls in our postal_code provider Area "cached, not a DB lookup"
        try_create_location(location_params_hash, vaxspotter_locations)
        try_create_appointments(appointment_params_hash, location_params_hash[:api_id])
      end

    end
  end

  private

  def parse_appointments(params_hash)
    appointment_objects = []
    dates_seen = []

    if params_hash.try(:vaccines_available) == false
      return appointment_objects
    end

    puts params_hash
    puts '==================================='
    params_hash[:appointments].each do | appt |
      puts 'hi'
      puts appt
      date = appt["time"].to_datetime.strftime('%Y/%m/%d')
      if dates_seen.include? date
        appointment_objects.map! do |h|
          h['vaccines_available'] += 1 if h[date]
        end
      else
        appointment_objects << {:date => date, :vaccines_available => 1}
        dates_seen << date
        puts appointment_objects.class
        puts dates_seen
      end
    end
    return appointment_objects
  end


  def try_create_appointments(params_hash, api_id)
    if params_hash[:vaccines_available].nil? || params_hash[:vaccines_available] == false
      return
    end

    appts_to_create = []

    location_id = Location.where('api_id = ?', api_id).ids[0]

    if params_hash[:appointments].length == 0
      date = params_hash[:appointments_last_fetched].to_datetime.strftime('%Y/%m/%d')
      vaccines_available = '' #we dont know, empty array, but api says there are appts availble.

      appointment_hash = {
        location_id: location_id,
        vaccines_available: vaccines_available,
        date: date
      }

      appts_to_create << appointment_hash
      create_appointments(appts_to_create)
    else
      #handle date and counts
      vaccines_available = params_hash[:appointments].length()
    end


    # appointment_hash = {
    #   location_id: location_id,
    #   vaccines_available: vaccines_available,
    #   date: date
    # }

    # Appointment.create!(appointment_hash)
    # puts 'appt created!'

    # if Appointment.where(:location_id => appointment_hash['location_id'], :date => appointment_hash['date']).blank?
    #   puts "we already have this appt!!!!!"
    #   return
    # else
    #   Appointment.create!(appointment_hash)
    # end
  end

  def create_appointments(appts_to_create)
    appts_to_create.each do |appts|
      if Appointment.exists?( {location_id: appts[:location_id], date: appts[:date]} )
        puts "we found an existing one!!"
         # Appointment.create!(appts) #check for update??
      else
        Appointment.create!(appts)
      end
    end
  end






  def try_create_location(params_hash, vaxspotter_locations)
    if vaxspotter_locations.include? params_hash[:api_id]
      return
    else
      Location.create!(params_hash)
    end
  end


  def vaxspotter_locations()
    Location.pluck(:api_id)
  end

  def flatten_hash(hash)
    hash.each_with_object({}) do |(k, v), h|
      if v.is_a? Hash
        flatten_hash(v).map do |h_k, h_v|
          h["#{k}.#{h_k}".to_sym] = h_v
        end
      else
        h[k] = v
      end
     end
  end

end