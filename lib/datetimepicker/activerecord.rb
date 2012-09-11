# Extension made to ActiveRecord::Base to handle datetimepickers dynamic methods.
ActiveRecord::Base.class_eval do

  # Public: All the available :datetime columns for this model.
  #
  # Returns an Array of attribute names.
  def self.datetime_columns
    @datetime_columns ||= columns.select { |c| c.type == :datetime }.map(&:name)
  end
  
  # Public: we need to retain all of ActiveRecord's existing respond_to? fun.
  alias_method :active_record_original_respond_to?, :respond_to?

  # Public: ActiveRecord::Base should recognize our dynamic methods as existing.
  #
  # This respond_to? override will do exactly that. If the method being
  # tested does not match any of these, the pre-exisiting respond_to? for
  # ActiveRecord::Base is called to continue looking.
  def respond_to?(method, include_private = false)
    (method =~ datetimepicker_method_regex) || active_record_original_respond_to?(method, include_private)
  end
  
  private
  
  # Private: we need to retain all of ActiveRecord's existing method_missing fun.
  alias_method :active_record_original_method_missing, :method_missing

  # Private: handle missing methods for datetimepickers.
  #
  # This method_missing override will do exactly that. If the method being
  # tested does not match any of these, the pre-exisiting method_missing for
  # ActiveRecord::Base is called to continue looking
  def method_missing(method, *args, &block)
    if method =~ datetimepicker_method_regex
      # First matched group in datetimepicker_method_regex is the attribute
      # we're trying to set/get.
      attribute_name = $1
    
      # Second matched group in datetimepicker_method_regex  is the method
      # on datetimepicker that is trying to be sent.
      # Possible values: "date", "date=", "time", "time=",
      #     "date_before_type_cast", "time_before_type_cast"
      datetimepicker_method = $2
    
      # When simple_form is generating inputs, it's looking for the value of
      # "#{attribute_name}_datepicker_date_before_type_cast". Since this
      # "column" we're generating inputs for is dynamic, we can cut that part
      # out to keep things working the way we expect.
      datetimepicker_method.gsub!("_before_type_cast", "")

      send(:datetimepicker_proxy, attribute_name, datetimepicker_method, *args)
    else
      active_record_original_method_missing(method, *args, &block)
    end
  end  

  # Private: the regex that matches datetimepicker's dynamic methods.
  #
  # The method we want to allow to be called dynamically:
  #
  # - attribute_name_datetimepicker_date
  # - attribute_name_datetimepicker_date=
  # - attribute_name_datetimepicker_date_before_type_cast
  # - attribute_name_datetimepicker_time
  # - attribute_name_datetimepicker_time=
  # - attribute_name_datetimepicker_time_before_type_cast
  #
  # Returns a Regex
  def datetimepicker_method_regex
    /^(\w+)_datetimepicker_((?:date|time)(?:_before_type_cast)?=?)$/
  end

  # Private: does a datetime column exist for this attribute_name?
  #
  # attribute_name - the column we're testing for.
  #
  # Returns a Boolean.
  def datetimepicker_column?(attribute_name)
    self.class.datetime_columns.include?(attribute_name.to_s)
  end

  # Private: Proxy method written so we can utilize dynamic methods for
  # manipulating columns of type datetime by their date and time independently.
  #
  # Getters get date/time values.
  #
  # Setters set date/time values, and update the datetime column.
  #
  # attribute_name -        The active record attribute we're wrapping.
  # datetimepicker_method - the message to pass along to manipulate the column
  #                         using the Datetimepicker.
  # args                  - Any attitional arguments to pass along to
  #                         Datetimepicker.
  #
  # Examples
  #
  #   datetimepicker_proxy(:created_at, "date=", "2012/01/01")
  #
  # Returns mixed. Getters return gotten value. Setters return the new 
  # attribute_name value.
  def datetimepicker_proxy(attribute_name, datetimepicker_method, *args)
    if !datetimepicker_column?(attribute_name)
      raise "Datetimepicker can only be used on columns of type :datetime"
    end
    
    # Datetimepicker won't work so good with a nil value.
    attribute_value = send(attribute_name) || Time.now.beginning_of_hour

    datetimepicker = Datetimepicker::DateAndTimeManipulator.new(attribute_value,
        Time::DATE_FORMATS[:datetimepicker_date],
        Time::DATE_FORMATS[:datetimepicker_time])
    return_value = datetimepicker.send(datetimepicker_method, *args)
    
    # Setters gonna set.
    if datetimepicker_method =~ /=$/
      return_value = write_attribute(attribute_name.to_sym, datetimepicker.datetime)
    end
    
    return_value
  end
  
end