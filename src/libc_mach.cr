# Module to provide api interface to the user-space mach kernel api
{% if flag?(:darwin) %}
require "./mach/*"
{% end %}
module LibcMach
  VERSION = "0.1.0"
end
