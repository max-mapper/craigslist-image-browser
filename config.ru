require 'rubygems'
require 'sinatra'
require 'haml'
require 'sass/plugin/rack'
require 'nokogiri'
require 'open-uri'
require 'json'
require 'builder'
require 'application'

use Sass::Plugin::Rack
Sass::Plugin.options[:css_location] = "./public"
Sass::Plugin.options[:template_location] = "./public"

run Sinatra::Application