require 'simplecov'
SimpleCov.start do
  add_filter do |source_file|
    source_file.filename.match(/lib/).nil?
  end
end

require 'pry'

require File.expand_path('../../lib/objection.rb', __FILE__)
