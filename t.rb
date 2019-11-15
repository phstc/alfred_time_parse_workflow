require 'time'
require 'tzinfo'

def create_item(title, arg=title)
	%{<item arg="#{arg}"><title>#{title}</title></item>}
end

def parse(time)
	time == 'now' ?  Time.now : Time.parse(time)
end

def format_time(tz, time)
	"#{tz} #{time.strftime('%H:%M:%S')}"
end

def diff_times(time_a, time_b)
	return '' unless time_b

	sec = (parse(time_b) - parse(time_a)).abs

	diff = Time.at(sec).utc.strftime("%H:%M:%S") #=> "01:00:00"

	create_item(diff)
end

def show_times(time)
	output = ''

	time = parse(time)
	output += create_item(format_time('UTC', time.utc))
	output += create_item(format_time('New York', time.localtime))
	output += create_item(format_time('Madrid', TZInfo::Timezone.get('Europe/Madrid').utc_to_local(time.utc)))
	output += create_item(format_time('Dublin', TZInfo::Timezone.get('Europe/Dublin').utc_to_local(time.utc)))
	output += create_item(format_time('Teresina', TZInfo::Timezone.get('America/Recife').utc_to_local(time.utc)))
end

output = ''

time_a, time_b = ARGV.join(' ').split(' - ').map(&:strip)

begin
	if time_b
		output += diff_times(time_a, time_b).to_s
	else
		output += show_times(time_a).to_s
	end
rescue => e
	output += create_item(e.message)
end

puts %{<?xml version="1.0"?><items>#{output}</items>}
