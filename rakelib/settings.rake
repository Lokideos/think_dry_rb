task :settings do
  ENV['PROJECT_ENV'] ||= 'development'
  require 'config'
  require_relative '../config/boot'
end
