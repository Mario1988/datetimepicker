# Public: A simple structure for independently manipulating the date and time
# components of a TimeWithZone object, while maintining the the existing date
# and time information.
#
# datetime    - an instance of DateTime/Time/TimeWithZone.
# date_format - A String containing the strftime format for setting/getting
#               date component of datetime.
# time_format - A String containing the strftime format for setting/getting
#               time component of datetime.
# Examples
#
#   DateTimePicker.new(Post.first.created_at, "%Y/%m/%d", "%H:%M")
module Datetimepicker
  class DateAndTimeManipulator < Struct.new(:datetime, :date_format, :time_format)

    # Public: get the date component of datetime.
    #
    # Returns a String in the format of date_format.
    def date
      datetime.strftime(date_format)
    end

    # Public: set the date component of datetime.
    #
    # new_date - The String representation of date component for datetime.
    #            The String should be in the format of date_format.
    def date=(new_date)
      self.datetime = parse_date_and_time(new_date, time)
    end

    # Public: get the time component of datetime.
    #
    # Returns a String in the format of time_format.
    def time
      datetime.strftime(time_format)
    end

    # Public: set the time component of datetime.
    #
    # new_time - The String representation of time component for datetime.
    #            The String should be in the format of time_format.
    def time=(new_time)
      self.datetime = parse_date_and_time(date, new_time)
    end

    private

    # Private: create a new TimeWithZone from date and time Strings.
    #
    # date - A String of the date in the format of date_format
    # time - A String of the time in the format of time_format.
    #
    # The following blog post was infinitely valuable in figuring out how to
    # parse dates and times while maintaining a time zone in Rails.
    #
    # http://www.elabs.se/blog/36-working-with-time-zones-in-ruby-on-rails
    #
    # Returns an instance of TimeWithZone.
    def parse_date_and_time(parse_date, parse_time)
      Time.strptime(date_and_time_format(parse_date, parse_time),
          date_and_time_format(date_format, time_format)).in_time_zone(Time.zone)
    end

    # Private: generate strings for parsing datetime in a consistent way.
    #
    # date_component - A String of the date component of the date and time pair.
    # time_component - A String of the time component of the date and time pair.
    # separator      - (optional) String used to concatenate the components.
    #
    # Examples
    #
    #   date_and_time_format("%Y/%m/%d", "%H:%M")
    #   => "%Y/%m/%d %H:%M"
    #
    #   date_and_time_format("2004/08/15", "16:23", "T")
    #   => "2004/0815T16:23"
    #
    # Returns a String.
    def date_and_time_format(date_component, time_component, separator = " ")
      "#{date_component}#{separator}#{time_component}"
    end 

  end
end