class Category < ActiveRecord::Base
  
  has_many :interests
  has_many :channel_interests, :through => :interests
  has_many :local_channels, :through => :channel_interests,
  :finder_sql => proc { "SELECT c.* FROM `kitsknndb`.categories c " +
           "INNER JOIN `kitsknndb`.channel_interests ci ON ci.category_id=c.id " +
           "INNER JOIN `kitscentraldb`.channels lc ON ci.channel_id=lc.id " +
           "WHERE c.id=#{id}" }
#  has_many :events, :through => :local_channels
             
  scope :unhidden, where(:hide.downcase => 'no')
  default_scope :order => 'sortkey ASC'

  def self.get_active_list
    includes(:interests => [:channel_interests]).unhidden.where(:status.downcase => 'active')
  end
  
  def self.get_channels title, loc
    channels = []
    category = Category.where('name like ?', title + '%').first
    category.interests.map {|interest| channels << LocalChannel.select_channel(interest.name, loc, loc)[0]}
    channels  
  end
  
  def self.parse_ary
    [['Sculpture|Art|Painting|Exhibit|Gallery|Artist|Artwork|Museum|Curated|Arts|Crafts', 'Arts & Crafts'], 
     ['Preschool|Teen|Children|Kids|Kindergarten|Elementary|Private School|High School', 'Education'], 
     ['R&B|Hip-Hop|Soul|Dance|Concert|Band|Performance|Music|Ball|Jazz|Salsa|DJ|Ballroom|CD|Blues|Reggae|Rehearsal|Rock|Pop|Noise|Country Music|Quartet|Trio|Quintet', 'Music'],  
     ['Comedy|Funny|Comedian|Improv|Laugh', 'Entertainment'],
     ['Culinary|Food|Wine|Cooking|Taste|Brunch|Dinner|Chocolate|Chef|Kitchen|Farmers|Barbeque|Tasting|Lunch|Dining|Coffee|Dine|Potluck|Winery|Feed|Feast|Beer', 'Food & Dining'],  
     ['Fiesta|Festival|Fair|Show|Celebration|Fireworks|Exhibition|Flea|Fest|Parade|March', 'Community'],
     ['Volunteer|Charity|Fundraiser|Gala|Benefit|Luncheon|Fundraising|Community|Foundation', 'Community'], 
     ['Speaker|Lecture|Discussion|Talk|Author|Panel|Book|Reading|Literature|Stories', 'Entertainment'],
     ['Screening|Film|Movie|Cinema|3D|Film noir|Drama|Documentary', 'Entertainment'], ['Science|History','Education'],
     ['Church|Religion|Baptist|Islam|Catholic|Christ|Episcopal|Evangelical|Buddist|Hindu|Mormon|Christian|Methodist|Congregational|Presbyterian|Quaker|Lutheran', 'Religion'],
     ['Medical|Health|Medicine|Yoga|Rehab','Health & Fitness'], ['Home|House|Real Estate|Construction|Land', 'Housing'],
     ['Book|Reading|Literature|Stories|Author|Novels|Poems|Poetry|Magazines', 'Entertainment'],['Senior|Youth|Kids|Children|Family', 'Family'],
     ['Orchestra|Piano|Violin|Cello|Musical|Recital|Cello|Symphony|Concerto', 'Music'],
     ['Cloud|Mobile|Technology|Software|Hardware|Server|Engineering', 'Technology'],
     ['Football|Baseball|Hockey|Golf|Tennis|Basketball|Soccer|Boxing|NFL|NHL|NBA|MMA|Wrestling', 'Pro Sports'],
     ['Football|Baseball|Hockey|Golf|Tennis|Basketball|Soccer|Boxing|Softball|Wrestling|Gymnastics|Track|Lacrosse|Water Polo|Rowing|Swimming|Fencing', 'College Sports'],
     ['Sale|Offer|Shopping|Discounts','Shopping'], ['Cruise|Trip|Tour|Visit|Guided Tour|Sightseeing|Monuments|Landmark|Travel', 'Travel & Tourism'],    
     ['Opera|Choir|Theater|Symphony|Ballet|Concerto|Theatre|Play|Choregraphy|Dance|Orchestra|Piano|Pops|Violin|Cello|Musical|Recital', 'Performing Arts'],
     ['Zoo|Animals|Aquarium', 'Family'], 
     ['Association|Organization|Retail|Professionals','Business'],
     ['Parks|Hiking|Biking|Running|Camping|Walking|Fishing|Skydiving|Kite|Hang Gliding|Skiing|Scuba|Boating|Sailing|Flying|Snokel|Birdwatching', 'Recreation'], 
     ['Meeting|Conference|Product Launch|Marketing|Business|Networking|Management|Entrepreneur|Venture', 'Business']]
  end
  
  def self.select_category title
    category = []
    parse_ary.each do |str|
      if !(title.downcase =~ /^.*\b(#{str[0].downcase})\b.*$/i).nil? 
        category << Category.where('name like ?', str[1] + '%') 
      end
    end 
    category << Category.find_by_name('Entertainment') if category.blank?  
    category
  end   
end