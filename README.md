# Datetimepicker

## Installation

Add to your application's Gemfile:

```
gem 'datetimepicker'
```

## Usage

For barebones implementation, you only need to add the require CSS and JS to your application.

```coffeescript
# application.js.coffee

#= require datetimepicker
```

```sass
// application.css.scss

@import "datetimepicker"
```

Then, in simple form, use `:as => :datetimepicker`

```erb
<%= simple_form_for @record do |f| %>
  <% f.input :created_at, :as => :datetimepicker %>
<% end %>
```

