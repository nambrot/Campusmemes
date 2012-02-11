require 'ap'
class College
  include Mongoid::Document
  include Mongoid::Timestamps
  field :name, :type => String
  field :short, :type => String
  field :url, :type => String
  field :fbid, :type => Integer
  validates_uniqueness_of :fbid
  key :short
  cache
  embeds_many :photos
  
  def self.getPhotos(college)
    puts "Updating #{college.name}"
    @token ||= Koala::Facebook::API.new(Token.first.token)
    feed = @token.get_connections(college.fbid, 'feed', {:limit => 50}).keep_if{|d| d['type'] == 'photo'}
    process(feed, college)
    while (feed.next_page_params) do
      feed = feed.next_page.keep_if{|d| d['type'] == 'photo'}
      process(feed, college)
    end
  end
  
  def self.process (feed, college)
    pictures = @token.batch do |batch_api|
      feed.each do |photopost|
        batch_api.get_object(photopost['object_id'])
      end
    end
    likes = @token.batch do |batch_api|
      pictures.each do |picture|
        picture.class == Hash ? batch_api.get_connections(picture['id'], 'likes', {:limit => 100000}) : batch_api.get_connections('10151252892950397','likes',{:limit => 1})
      end
    end
    records = []
    pictures.zip(likes).each {|d| if d.first.class == Hash;  d.first['likecount'] = d.last.nil? ? 0 : d.last.length; records.push (d.first); end}
    records.each do |photo|
    record = college.photos.find_or_create_by({ :fbid => photo['id']})
    record.update_attributes({
      :fbid => photo['id'],
      :thumburl => photo['images'][1]['source'],
      :fullurl => photo['images'][0]['source'],
      :likes => photo['likecount'],
      :created_at => Time.parse(photo['created_time'])
    })
    end
  end
end
