class Token
  include Mongoid::Document
  field :token, :type => String
end
