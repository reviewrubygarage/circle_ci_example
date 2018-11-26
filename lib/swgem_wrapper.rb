require "swgem_wrapper/version"
require 'swgem'
require 'faraday'
require 'json'
require_relative 'swgem_wrapper/script_generator'

module SwgemWrapper
end

module SWGEM
  BASE_URL = 'https://swapi.co/api/'.freeze
end
