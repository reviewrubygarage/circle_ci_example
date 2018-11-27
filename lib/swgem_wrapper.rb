require "swgem_wrapper/version"
require 'faraday'
require 'json'
require_relative 'swgem_wrapper/script_generator'
require_relative 'swgem_wrapper/exceptions'

module SwgemWrapper
  BASE_URL = 'https://swapi.co/api/'.freeze
end
