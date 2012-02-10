class Photo
  include Mongoid::Document
  field :fbid, :type => Integer
  field :thumburl, :type => String
  field :fullurl, :type => String
  field :created_at, :type => String
  key :fbid
  embedded_in :college, :inverse_of => :comments
end
