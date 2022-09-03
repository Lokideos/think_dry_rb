task :settings do
  ENV['PROJECT_ENV'] ||= 'development'
  require 'config'
  require_relative '../config/boot'
  # require "dotenv"
  # Dotenv.load(".env", ".env.#{ENV["APP_ENV"]}")
end
