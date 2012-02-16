require 'clockwork'
include Clockwork
require File.expand_path('../../config/boot', __FILE__)
require File.expand_path('../../config/environment', __FILE__)

every(2.hours, 'feeds.refresh') { Delayed::Job.enqueue CollegeJob.new }

class CollegeJob < Object
    def perform
      College.all.each {|d| College.getPhotos(d)}
    end
end