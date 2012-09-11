module SimpleForm
  module Inputs
  
    class DatetimepickerInput < Base
      def input
        multiple_inputs_buffer = ""

        # Build the CSS and input necessary for datetimepicker_date
        input_html_classes.push(partial_input_name(:date))
        multiple_inputs_buffer << @builder.text_field("#{attribute_name}_#{partial_input_name(:date)}", input_html_options)
        input_html_classes.delete(partial_input_name(:date))

        # Build the CSS and input necessary for datetimepicker_time
        input_html_classes.push(partial_input_name(:time))
        multiple_inputs_buffer << @builder.text_field("#{attribute_name}_#{partial_input_name(:time)}", input_html_options)
        input_html_classes.delete(partial_input_name(:time))

        return multiple_inputs_buffer
      end
  
      private
    
      def partial_input_name(which_input)
        "datetimepicker_#{which_input}"
      end
    end
  
  end
end