$:.unshift(File.dirname(__FILE__) + '/../lib')

require 'test/unit'
require 'rubygems'
require 'active_support'
require 'active_record'
require 'active_record/fixtures'

config = YAML::load(IO.read(File.dirname(__FILE__) + '/database.yml'))
ActiveRecord::Base.logger = Logger.new(File.dirname(__FILE__) + '/debug.log')
ActiveRecord::Base.establish_connection(config[ENV['DB'] || 'sqlite3'])

load(File.join(File.dirname(__FILE__), 'schema.rb'))
require File.join(File.dirname(__FILE__), '../init')

class User < ActiveRecord::Base
  has_one :wristband
  validates_presence_of :wristband
end
class Wristband < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :color
end
