module ApplicationHelper
  def time_based_greeting
    current_hour = Time.current.hour
    current_time = Time.current.strftime("%I:%M %p")
    
    greeting = case current_hour
    when 5..11
      "Good morning!"
    when 12..16
      "Good afternoon!"
    when 17..20
      "Good evening!"
    else
      "Good night!"
    end

    # Add the current time for debugging
    "#{greeting} (#{current_time})"
  end
end
