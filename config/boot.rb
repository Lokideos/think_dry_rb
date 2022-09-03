# frozen_string_literal: true

ENV['PROJECT_ENV'] ||= 'development'

require 'bundler/setup'
Bundler.require(:default, ENV.fetch('PROJECT_ENV', :development).to_sym)

require_relative 'initializers/config'

require_relative '../system/container'
Container.finalize!
