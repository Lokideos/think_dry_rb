# frozen_string_literal: true

require 'bundler/setup'
Bundler.require(:default, ENV.fetch('PROJECT_ENV', :development).to_sym)

require_relative '../system/container'
Container.finalize!
