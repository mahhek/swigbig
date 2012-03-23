class ProfileJson

  def self.profile_to_json(user)
    user_profile = {}
    user_profile['id'] = user.id
    user_profile['email'] = user.email
    user_profile['address'] = user.address
    user_profile['city'] = user.city
    user_profile['country_abbr'] = user.country
    user_profile['name'] = user.name
    user_profile['phone_number'] = user.phone_number
    user_profile['service_uid'] = user.service_uid
    user_profile['state_abbr'] = user.state
    user_profile['zip_code'] = user.zip_code
    if user.is_completed?
      user_profile['status'] = "complete"
    else
      user_profile['status'] = "not complete"
    end
    return user_profile
  end

  def self.notification(bar)
    notification = {}
    notification['status_user'] = "Checkin on #{bar.name}"
    notification['deals'] = "#{(bar.bar_deals.collect{|bd|bd.deal.name+'-with tipping point-'+bd.deal.tipping_points.to_s}).join('##')}"
    notification['rewards'] = "#{(bar.bar_rewards.collect{|br|br.reward.name+' - '+br.reward.description}).join('##')}"
    return notification
  end

  def self.near_bars(bars, latitude, longitude)
   list_bars = ""
    bars.each do |bar|
      list_bars = list_bars+"id:#{bar.id.to_s}"+"&&"+"name:#{bar.name.to_s}"+"&&"+"address:#{bar.address.to_s}"+"&&"+"city:#{bar.city.to_s}"+"&&"+"#{bar.phone_number.to_s}"+"&&"+"#{bar.distance_to([latitude, longitude], units = :km).to_s} km"+"&&"+"#{bar.latitude.to_s}"+"&&"+"#{bar.longitude.to_s}"+"##"
    end
  end
end