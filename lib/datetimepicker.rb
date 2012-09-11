require "datetimepicker/version"

module Datetimepicker
  autoload :DateAndTimeManipulator, "datetimepicker/date_and_time_manipulator"

  class Engine < ::Rails::Engine
    require "datetimepicker/engine"
  end
  
end

require "datetimepicker/date_formats"
require "datetimepicker/activerecord"
require "datetimepicker/simple_form/inputs/datetimepicker_input"