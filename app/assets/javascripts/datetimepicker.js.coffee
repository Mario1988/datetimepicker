#= require datetimepicker/bootstrap_datepicker
#= require datetimepicker/bootstrap_timepicker

jQuery () ->

  # This format much match up with the format in Time::DATE_FORMATS[:datetimepicker_date]
  # TODO: automate this conversion for the gemfile drop in version.
  jQuery(".datetimepicker_date").datepicker(format: "yyyy/mm/dd")
    .on "changeDate", (ev) ->
      $(this).datepicker('hide').blur()
  
  jQuery(".datetimepicker_time").timepicker(showMeridian: false, template: "modal", defaultTime: "value")