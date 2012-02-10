class ProposedCollege
  include Mongoid::Document
  field :name, :type => String
  field :short, :type => String
  field :url, :type => String
end
