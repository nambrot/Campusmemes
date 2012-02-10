# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
College.all.each {|d| d.destroy}
College.create ({:name => 'Boston University', :short => 'bu', :fbid => '211588618937677', :url => 'https://www.facebook.com/BUmemes'})
College.create ({:name => 'New York University', :short => 'nyu', :fbid => '251015678305867', :url => 'https://www.facebook.com/NYUMemes'})
College.create ({:name => 'University of Michigan', :short => 'umich', :fbid => '333039373386183', :url => 'https://www.facebook.com/UmichMemes'})
College.create ({:name => 'University of Texas', :short => 'ut', :fbid => '169022816541446', :url => 'https://www.facebook.com/UTexasMemes'})