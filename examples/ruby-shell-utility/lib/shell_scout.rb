# frozen_string_literal: true

require 'thor'
require 'tty-prompt'
require 'pastel'
require 'httparty'
require 'dotenv/load'
require 'terminal-table'

class ShellScout < Thor
  desc 'weather CITY', 'Show current weather details for CITY using Open-Meteo geocoding + forecast APIs'
  def weather(city)
    geo = HTTParty.get('https://geocoding-api.open-meteo.com/v1/search', query: { name: city, count: 1 }).parsed_response
    first = geo.fetch('results', []).first

    unless first
      puts pastel.red("No matching city found for '#{city}'.")
      exit(1)
    end

    forecast = HTTParty.get(
      'https://api.open-meteo.com/v1/forecast',
      query: {
        latitude: first['latitude'],
        longitude: first['longitude'],
        current: 'temperature_2m,apparent_temperature,wind_speed_10m,weather_code'
      }
    ).parsed_response

    current = forecast.fetch('current', {})
    table = Terminal::Table.new(
      title: "Weather for #{first['name']}, #{first['country']}",
      rows: [
        ['Temperature', "#{current['temperature_2m']} °C"],
        ['Feels like', "#{current['apparent_temperature']} °C"],
        ['Wind speed', "#{current['wind_speed_10m']} km/h"],
        ['Weather code', current['weather_code']]
      ]
    )

    puts pastel.cyan(table)
  rescue StandardError => e
    puts pastel.red("Could not load weather data: #{e.message}")
    exit(1)
  end

  desc 'focus', 'Start a short interactive focus timer with optional note'
  method_option :minutes, aliases: '-m', type: :numeric, default: 25, banner: 'N'
  def focus
    prompt = TTY::Prompt.new
    minutes = options[:minutes].to_i
    note = prompt.ask('What is your focus goal for this session?', default: 'Deep work block')

    puts pastel.green("Starting #{minutes}-minute focus block: #{note}")
    sleep(minutes * 60)
    puts pastel.yellow('Time is up. Stretch, hydrate, and capture what you finished.')
  end

  desc 'check API_NAME', 'Verify that a required API key is available in your environment'
  def check(api_name)
    env_name = "#{api_name.upcase}_API_KEY"
    value = ENV[env_name]

    if value && !value.empty?
      puts pastel.green("#{env_name} is set (#{value.length} characters).")
    else
      puts pastel.red("#{env_name} is not set. Put it in .env or export it in your shell profile.")
      exit(1)
    end
  end

  private

  def pastel
    @pastel ||= Pastel.new
  end
end
