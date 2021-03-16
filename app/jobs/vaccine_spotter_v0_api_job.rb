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

      full_address = obj[:"properties.address"] + ", " + obj[:"properties.city"] + ", " + obj[:"properties.state"] + " " + obj[:"properties.postal_code"]

      location_params_hash = {
        api_id: obj[:"properties.id"],
        name: obj[:"properties.name"],
        address: full_address.upcase,
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

      if Area.find_by(postal_code: location_params_hash[:postal_code]) #check if location falls in our postal_code provider Area "cached, not a DB lookup"
        try_create_location(location_params_hash, vaxspotter_locations)
        try_create_appointments(appointment_params_hash, location_params_hash[:api_id])
      end
    end
  end


  private


  def try_create_appointments(params_hash, api_id)
    if params_hash[:vaccines_available].nil? || params_hash[:"vaccines_available"] == false
      remove_stale_appointments(api_id)
    end
    appts_to_create = []
    location_id = Location.where('api_id = ?', api_id).ids[0]

    # This 'if' covers the case where params_hash[:vaccines_available]=true, but appt array is empty.
    # Assume there are appts, and the day last fetched the the appt day. Often this is the case when looking at the raw data
    if params_hash[:appointments].nil? == true || params_hash[:appointments].length == 0
      if params_hash[:appointments_last_fetched].nil? == true
        date = DateTime.now.strftime('%Y/%m/%d') #naive assumption the appt is today
      else
        date = params_hash[:appointments_last_fetched].to_datetime.strftime('%Y/%m/%d')
      end
      vaccines_available = '' #naive assumption for now
      appointment_hash = {
        location_id: location_id,
        vaccines_available: vaccines_available,
        date: date
      }
      appts_to_create << appointment_hash
      create_appointments(appts_to_create)

    # This 'else' covers the case where params_hash[:vaccines_available]=true and we have a non empty appt array.
    # We loop thropugh the arrays to get appt dates. We do not yet grab the number of vaccines available nor the times
    # either start/end or actual appt times. TODO: This is a naive base case assumption and should be improved
    else
      dates_seen = []
      params_hash[:appointments].each do |a|
        vaccines_available = '' #naive assumption for now
        if a["time"].nil? == true #formatted as {"time"=>"2021-03-19T09:45:00.000-07:00"}
          next
        else
          date = a["time"].to_datetime.strftime('%Y/%m/%d')
        end
        if dates_seen.include? date
          next
        end
        dates_seen << date
        appointment_hash = {
          location_id: location_id,
          vaccines_available: vaccines_available,
          date: date
        }
        appts_to_create << appointment_hash
      end
      create_appointments(appts_to_create)
    end
  end


  def create_appointments(appts_to_create)
    appts_to_create.each do |appts|
      if Appointment.exists?( {location_id: appts[:location_id], date: appts[:date]} ) #truthy conditional since we dont know the id
        next
        # TODO: update appts that were all taken, but more opened up? 
        # Appointment.where( {location_id: appts[:location_id], date: appts[:date]} ).update_all(is_stale: false)
      else
        Appointment.create!(appts)
      end
    end
  end

  def remove_stale_appointments(api_id)
    location_id = Location.where('api_id = ?', api_id).ids[0]
    Appointment.where('location_id = ?', location_id).where('is_stale = ?', false).update_all(is_stale: true)
  end


  def try_create_location(params_hash, vaxspotter_locations)
    if vaxspotter_locations.include? params_hash[:api_id]
      Location.where(:api_id => params_hash[:api_id]).update_all(params_hash)
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