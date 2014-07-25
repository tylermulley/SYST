#	Author: 	Tyler Mulley with help from Eze Anyanwu
#	Completed: 	7-15-2014 (Alpha)
#	Title: 		SYST - Should You Skim Today?
#	Puropse: 	This code opens webpages from Magiseaweed, accuweather and boatma.com
#				to retreive weather, surf and tide data that can inform the avid skimmer  
#				about the current conditions.



## Require Statements	
	require 'open-uri'
	require 'nokogiri'

## Functions

	## Clears the terminal
	def clear()
		system('clear')
	end

	## Serves the same as /n
	def line()
		puts ""
	end

## Initial Variables

	weather_url = ''
	surf_url = ''
	hourly_weather_url = ''
	tide_url = ''
	right_input = false

	month_hash = {1 => "January", 2 => "February", 3 => "March", 4 => "April", 5 => "May", 6 => "June", 7 => "July",
					8 => "August", 9 => "September", 10 => "October", 11 => "November", 12 => "December"}

	## Get Date and set day and month
	date = Time.new 
	month = date.month
	day = date.day


## Ask user for beach choice of beach and set URLs based on choice
	
	clear()

	puts "Where do you wanna go skimming today? (type the number of the location)"
	puts "1. Crane Beach"
	puts "2. Plum Island"
	puts "3. Singing Beach"  
	puts "4. Salisbury Beach" 

	choice = gets.chomp


## Set URLs depending on choice above
	while !right_input
		
		if choice == "1"
			weather_url = 'http://www.accuweather.com/en/us/ipswich-ma/01938/weather-forecast/338615'
			hourly_weather_url = 'http://www.accuweather.com/en/us/ipswich-ma/01938/hourly-weather-forecast/338615'
			surf_url = 'http://magicseaweed.com/Cape-Ann-Surf-Report/370/'
			tide_url = 'http://www.boatma.com/tides/' + month_hash[month] + '/Annisquam-Lobster-Cove.html'
			right_input = true
		elsif choice == "2"
			weather_url = 'http://www.accuweather.com/en/us/plum-island-ma/01950/weather-forecast/2088926'
			hourly_weather_url = 'http://www.accuweather.com/en/us/plum-island-ma/01950/hourly-weather-forecast/2088926'
			surf_url = 'http://magicseaweed.com/Salisbury-Surf-Report/1130/'
			tide_url = 'http://www.boatma.com/tides/' + month_hash[month] + '/Plum-Island-Sound-(south-end).html'
			right_input = true
		elsif choice == "3"
			weather_url = 'http://www.accuweather.com/en/us/manchester-ma/01944/weather-forecast/2089088'
			hourly_weather_url = 'http://www.accuweather.com/en/us/manchester-ma/01944/hourly-weather-forecast/2089088'
			surf_url = 'http://magicseaweed.com/Cape-Ann-Surf-Report/370/'
			tide_url = 'http://www.boatma.com/tides/' + month_hash[month] + '/Essex.html'
			right_input = true
		elsif choice == "4"
			weather_url = 'http://www.accuweather.com/en/us/salisbury-ma/01952/weather-forecast/2088928'
			hourly_weather_url = 'http://www.accuweather.com/en/us/salisbury-ma/01952/hourly-weather-forecast/2088928'
			surf_url = 'http://magicseaweed.com/Salisbury-Surf-Report/1130/'
			tide_url = 'http://www.boatma.com/tides/' + month_hash[month] + '/Plum-Island%20Merrimack-River-Entrance-Merrimack%20River.html'
			right_input = true
		else
			puts "Invalid input. Try again."

			puts "Where do you wanna go skimming today? (type the number of the location)"
			puts "1. Crane Beach"
			puts "2. Plum Island"
			puts "3. Singing Beach"  
			puts "4. Salisbury Beach" 

			choice = gets.chomp
		end

	end


## Setting up web pages as variables and parsing HTML

	## opening web pages and parsing HTML
	weather_page = Nokogiri::HTML(open(weather_url))
	hourly_weather_page = Nokogiri::HTML(open(hourly_weather_url))
	surf_page = Nokogiri::HTML(open(surf_url))
	tide_page = Nokogiri::HTML(open(tide_url))

	### setting parts of HTML to variables
	weather_condition = weather_page.css('li#feed-main span.cond').text
	current_temp = weather_page.css('li#feed-main strong.temp').text
	real_feel = weather_page.css('li#feed-main span.realfeel').text

	hours_start = hourly_weather_page.css('table.data thead th')
	temp_start = hourly_weather_page.css('table.data tr.temp td')
	cond_start = hourly_weather_page.css('table.data tr.forecast td div')
	rain_start = hourly_weather_page.css('table.data tr.rain td')
	wind_start = (hourly_weather_page.css('tr')[13]).css('td') 

	surf_start = surf_page.css('table#msw-js-fc tbody tr td')
	sunset_start = surf_page.css('table.msw-tide-stable.table tr')

	high_tide_start = tide_page.css('div#tides_table div.tides_row')[day].css('div.high')
	low_tide_start = tide_page.css('div#tides_table div.tides_row')[day].css('div.low')


## Creating Array variables
	hours = []
	temp = []
	cond = []
	rain = []
	wind = []
	sunset_new = []

	surf_array = []
	surf_new = []
	high_tide_array = []
	low_tide_array = []


## Getting hourly weather arrays
	hours_start.each do |item|
		if item.text.size > 5
			hours << item.text[3..item.text.size]
		elsif item.text.size < 2
			next
		else
			hours << item.text
		end
	end

	temp_start.each do |item|
		temp << item.text
	end

	cond_start.each do |item|
		cond << item.text
	end

	rain_start.each do |item|
		rain << item.text
	end

	wind_start.each do |item|
		wind << item.text
	end

	for num in (0..3)
		sunset_new << sunset_start[num]
	end

	temp2 = []

	sunset_new.each do |item|
		temp2 << item.text.split
	end


## Getting surf array data
	if choice == "1" or choice == "3"
		for num in (2..57)
			surf_new << surf_start[num]
		end
	else
		for num in (1..57)
			surf_new << surf_start[num]
		end
	end

	counter = 0

	while counter < 51
		temp_surf = []
		for num2 in (0..6)
			temp_surf << surf_new[counter + num2].text		
		end
		surf_array << temp_surf
		counter += 7
	end

	high_data = high_tide_start.text.gsub(/[^[:alnum:], :, .]/, " ").split
	low_data = low_tide_start.text.gsub(/[^[:alnum:], :, ., -]/, " ").split


## Printing weather

	buffer = (weather_condition.length / 2).to_i
	space = "            "
	space = space[0..-buffer]

	clear()
	line()
	puts "═════════════════════════════════════════════════"
	puts " ⛅   🌞   ⚡   ☔   ⛅   WEATHER  🌞   ⚡   ☔   ⛅   🌞"
	puts "═════════════════════════════════════════════════"
	line()
	line()
	puts "                 General Forecast"
	puts "            ────────────────────────── "
	puts "            #{space}#{weather_condition}      "
	puts "                        #{current_temp}      "
	puts "                   #{real_feel}              "
	puts "            ────────────────────────── "

	line()

	puts "                  Hourly Forecast"
	puts "  ─────────────────────────────────────────────"
	puts "   Hour\t Temp\tCondition\tRain\tWind"
	puts "  ─────────────────────────────────────────────"
	line()


	for num in (0..(hours.size - 1))
		if cond[num].length < 8
			print "   " + hours[num] + "\t  " + temp[num] + "\t" + cond[num] + "\t\t" + rain[num]+ "\t" + wind[num] + "\n\n"
		else
			print "   " + hours[num] + "\t  " + temp[num] + "\t" + cond[num] + "\t" + rain[num]+ "\t" + wind[num] + "\n\n"
		end
	end

	line()


	## Print sunset stuff

	puts "\t    " + temp2[0][0] + " " + temp2[0][1] + "\t    " + temp2[3][0] + " " + temp2[3][1]
	puts "	   ─────────────   ────────────"
	puts "\t       " + temp2[0][2] + "\t      " + temp2[3][2]

	line()

	puts "\t      " + temp2[1][0] + "  \t      " + temp2[2][0]
	puts "	   ─────────────   ────────────"
	puts "\t       " + temp2[1][1] + "\t      " + temp2[2][1]

	line()
	line()


## Printing Surf Data
	puts "══════════════════════════════════════════════════"
	puts "  🌊   🌊   🌊   🌊   🌊    SURF    🌊   🌊   🌊   🌊   🌊  "
	puts "══════════════════════════════════════════════════"
	line()
	line()
	puts "                  Surf Forecast"
	puts " ─────────────────────────────────────────────"
	puts "  Hour\t  Surf\t  Swell\t\tWind\tGusts"
	puts " ─────────────────────────────────────────────"

	for num in (0..(surf_array.size - 1))
		print " "
		for num2 in (0..6)
			if num2 == 2
				primary = surf_array[num][num2].split
				if primary[0].length < 4
					print primary[0] + "    " + primary[1] + "\t"
				else
					print primary[0] + "  " + primary[1] + "\t"
				end
			elsif num2 == 3 or num2 == 5 or num2 == 6
				next
			elsif num2 == 1
				print surf_array[num][num2] + "\t  "
			elsif num2 == 4
				winds = surf_array[num][num2].split
				print winds[0] + "\t" + winds[1]
			else
				print surf_array[num][num2] + "\t"
			end
		end
		puts ""
		puts ""
	end

	line()
	line()

	puts "       " + "High Tide" + "\t\t" + "Low Tide"
	puts " ─────────────────────   ─────────────────────"
	line()
	puts "    " + high_data[0] + high_data[1] + "M" + "   " + high_data[2] + "FT" + "\t    " + low_data[0] + low_data[1] + "M"+ "   " + low_data[2] + "FT"
	line()
	puts "    " + high_data[3] + high_data[4] + "M" + "   " + high_data[5] + "FT" + "\t    " + low_data[3] + low_data[4] + "M"+ "   " + low_data[5] + "FT"

	line()
	line()















