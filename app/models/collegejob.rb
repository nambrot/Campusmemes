class CollegeJob < Object
    def perform
      College.all.each {|d| College.getPhotos(d)}
    end
end