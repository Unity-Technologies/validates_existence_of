$:.unshift(File.dirname(__FILE__) + '/../lib')
 
require 'test/unit'
require File.join(File.dirname(__FILE__), '..', '..', '..', '..', 'config', 'environment.rb')
require 'rubygems'
 
config = YAML::load(IO.read(File.dirname(__FILE__) + '/database.yml'))
ActiveRecord::Base.logger = Logger.new(File.dirname(__FILE__) + '/debug.log')
ActiveRecord::Base.establish_connection(config[ENV['DB'] || 'sqlite3'])
 
load(File.dirname(__FILE__) + '/schema.rb')
