class LocalChannel < KitsSubModel
  set_table_name 'channels'
  set_primary_key 'ID'
  
	attr_accessible :channelID, :status, :hide, :subscriptionsourceID,
	     :channel_name, :channel_title, :HostProfileID, :channel_class,
	     :channel_type
	     
	belongs_to :host_profile, :foreign_key => :HostProfileID #, :primary_key => :channelID
  has_many :calendar_events, :foreign_key => :subscriptionsourceID, :primary_key => :channelID, :dependent => :destroy do
    def range(limit=10, offset=0, sdt)
      where("(eventstartdate >= curdate() and eventstartdate <= ?) OR (eventstartdate <= curdate() and eventenddate BETWEEN curdate() and ?)", sdt, sdt).limit(limit).offset(offset) 
    end
  end
  
	has_many :channel_interests, :foreign_key => :channel_id, :dependent => :destroy
	has_many :interests, :through => :channel_interests
  has_many :categories, :through => :channel_interests

  # define user & subscriptions
  has_many :subscriptions, :foreign_key => :channelID, :primary_key => :channelID,
            :dependent => :destroy, :conditions => "status = 'active'"
  has_many :users, :through => :subscriptions
  
  has_many :pictures, :as => :imageable, :dependent => :destroy
	
  scope :active, where(:status.downcase => 'active')
  scope :unhidden, where(:hide.downcase => 'no')
#  scope :uniquelist, :select => 'DISTINCT channels.id, channels.name'
  
  default_scope :order => 'channel_name ASC'
  
  def self.dbname
    Rails.env.development? ? "`kits_development`" : "`kits_production`"
  end    
  
  def self.get_channel(title, loc, loc2)
    if !loc.blank?
      where("(channel_name like ? AND (localename like ? OR localename like ?)) OR (channel_name like ?)", '%' + title + '%', loc + '%', loc2 + '%', [title, loc, ''].join('%'))
    else
      where("(channel_name like ? AND localename like ?) OR (channel_name like ?)", '%' + title + '%', loc2 + '%', [title, loc2, ''].join('%'))      
    end   
  end
  
  def self.get_channel_by_loc loc
    where("channel_name like ? OR localename like ?", '%' + loc + '%', loc + '%')      
  end
  
  def self.get_channels loc, offset, amt
    get_channel_by_loc(loc).offset(offset).limit(amt)
  end
  
  def self.get_channel_by_name(title)
    where("channel_name like ?", '%' + title + '%')   
  end
  
  def self.select_system_channels loc, loc2
    if loc
      where("channel_type like ? AND (localename like ? OR localename like ?)", '%system%', loc + '%', loc2 + '%')
    else
      where("channel_type like ? AND localename like ?", '%system%', loc2 + '%')      
    end      
  end
  
  def self.getSQL
    "(SELECT c.* FROM `kitssubdb`.channels c 
    INNER JOIN #{dbname}.channel_locations cl ON cl.channel_id = c.id 
    INNER JOIN #{dbname}.locations l ON cl.location_id=l.id
    INNER JOIN `kitsknndb`.channel_interests i ON i.channel_id = c.id 
    WHERE c.status = 'active' AND c.hide = 'no' 
    AND (cl.location_id = ?) 
    AND (i.interest_id in (?))) ORDER BY sortkey ASC"
  end

  def descr
    bbody.blank? ? '' : bbody[0..79] + '...'    
  end
    
  def summary
    bbody.blank? ? '' : bbody[0..119] + '...'
  end
  
  def current_events
    calendar_events.select {|e| e.eventstartdate >= Date.today}
  end
  
  def ssid
    subscriptionsourceID
  end
  
  def self.channel_list(loc, int_id, pg)
    paginate_by_sql(["#{getSQL}", loc, int_id], :page => pg, :per_page => 15 )
  end

  def self.list_cached(loc, int_id, pg)
    Rails.cache.fetch("channel_list") do 
      channels = channel_list(loc, int_id, pg)
      preload_associations(channels, [:pictures, :subscriptions])
      return channels
    end 
  end
  
  def self.parse_ary
    [['Sculpture|Art|Painting|Exhibit|Gallery|Artist|Artwork|Museum|Curated|Arts|Crafts', 'Galleries'], 
     ['Preschool|Teen|Children|Kids|Kindergarten|Elementary', 'Youth'], ['Elementary','Elementary'],
     ['Dance|Concert|Band|Performance|Music|Ball|Jazz|Salsa|DJ|Ballroom|CD|Blues|Reggae|Tour|Rehearsal|Rock|Pop|Noise|Country Music|Quartet|Trio|Quintet', 'Music'],  
     ['Parade|March|Walk', 'Parade'], ['Comedy|Funny|Comedian|Improv|Laugh', 'Comedy'],
     ['Culinary|Food|Wine|Cooking|Taste|Brunch|Dinner|Chocolate|Chef|Kitchen|Farmers|Barbeque|Tasting|Fine Dining|Lunch|Dining|Coffee|Dine|Potluck|Winery|Feed|Feast|Beer', 'Food'],  
     ['Bebop|Big Band|Jazz|Quintet|Quartet|Octet|Trio|Sextet', 'Jazz'], ['Blues', 'Blues'], ['Bluegrass|Country Music|Country', 'Country Music'], ['Private School|High School', 'High School'], 
     ['Fiesta|Festival|Fair|Show|Celebration|Fireworks|Exhibition|Flea|Fest', 'Festival'],
     ['Volunteer|Charity|Fundraiser|Gala|Benefit|Luncheon|Fundraising|Nonprofit', 'Charity'], 
     ['Speaker|Lecture|Discussion|Talk|Author|Panel|Book|Reading|Literature|Stories', 'Speaker'],
     ['Screening|Film|Movie|Cinema|3D|Documentary|Flick', 'Film'], ['Science|History','Science'],
     ['Cars|Camping|Biking', 'Recreation'], ['Cars|Auto|Antique Cars', 'Cars'],
     ['Civic|Government|Policy|Politics|Civics', 'Government'],
     ['Church|Religion|Baptist|Islam|Catholic|Christ|Episcopal|Evangelical|Buddist|Hindu|Mormon|Christian|Methodist|Congregational|Presbyterian|Quaker|Lutheran', 'Church'],
     ['R&B|Hip-Hop|Soul','Hip-Hop'], ['Rock|Pop', 'Rock'], ['Medical|Health|Medicine|Cancer|Disease|Cure|Drug|Wellness','Health'],
     ['Book|Reading|Literature|Stories|Author|Storytime|Story', 'Book'],['Senior', 'Senior'], 
     ['Career|Job|Job Fair|Hiring|Employer|Employee|Employment','Job'],
     ['Dating|Romance|Love|Hookup|Sex|Mating', 'Dating'],
     ['Business|Conferences|Seminars|Meetings|Trade Missions|Strategy|Management', 'Business'],
     ['Orchestra|Piano|Violin|Cello|Musical|Recital|Cello|Symphony|Concerto|Pops', 'Classical'],
     ['Cloud|Mobile|Technology|Software|Hardware|Server|Engineering|Social Media|SaaS|Enterprise|IaaS|Web|', 'Technology'],
     ['Tennis|WTA|ATP', 'Tennis'],['NFL|Football','NFL'], ['Boxing|WBC|WBA|Fight|', 'Boxing'], ['Cricket', 'Cricket'], ['WWF|Wrestling', 'Wrestling'], ['Rugby', 'Rugby'],
     ['NBA|Basketball', 'NBA'], ['NHL|Hockey', 'NHL'], ['MLB|Baseball', 'MLB'], ['MMA|Fighting', 'MMA'], ['PGA|Golf', 'PGA'], ["Women's Golf|LPGA|Golf", 'LPGA'],
     ["WNBA|Women's Basketball", 'WNBA'],['MLS|Soccer|World Cup', 'Soccer'], ['NASCAR|Formula One|CART|Indy Car|Auto Racing', 'Auto Racing'], 
     ['Pro Sports', 'NFL'],['Pro Sports','NBA'], ['Pro Sports','MLB'], ['Pro Sports','NHL'], ['Pro Sports','MLS'], ['Pro Sports','WNBA'], ['Pro Sports', 'NASCAR'], ['Pro Sports', 'Rugby'],
     ['College Football|College Baseball|College Hockey|College Golf|College Tennis|College Basketball|College Soccer|Softball|College Wrestling|Gymnastics|Track|Lacrosse|Water Polo|Rowing|Swimming|Fencing', 'College Sports'],
     ['Startup|Entrepreneur|Venture Capital|Fund Raising|Founder', 'Startup'], 
     ['Marathon|Race|5K|10K|Track Meet', 'Amateur Sports'], ['Gay|Lesbian|LGBT|Transgender|Bisexual|Bi-sexual|Queer', 'Gay'], 
     ['Baby|Pre-natal|Toddler', 'Baby'], ['Wedding|Bridal|Marital|Engagement', 'Bridal'],
     ['Startup|Entrepreneur|Venture Capital|Fund Raising|Financing|Venture|VC|IPO|M&A', 'Venture'],
     ['Sale|Offer|Deal','Promotions'],     
     ['Opera|Choir|Theater|Symphony|Ballet|Concerto|Theatre|Play|Choregraphy|Dance|Orchestra|Piano|Violin|Cello|Musical|Recital|Pops', 'Performing Arts'],
     ['Zoo|Animals|Aquarium', 'Zoo'], ['Park', 'Parks'], 
     ['Meeting|Conference|Meetup', 'Meeting']]    
  end
  
  def self.pick_channels int, cnty, loc
    channel = []
    int.each do |interest|
      channel = build_channel_list channel, interest.name, cnty, loc if interest
    end
    channel.flatten 1
  end
  
  def self.select_channel(title, cnty, loc)
    build_channel_list [], title, cnty, loc  
  end 
  
  def self.build_channel_list channel, title, cnty, loc
    parse_ary.each do |str|
      if !(title.downcase =~ /^.*\b(#{str[0].downcase})\b.*$/i).nil? 
        found_channel = get_channel(str[1], cnty, loc)
        channel << found_channel unless found_channel.blank? 
      end
    end 
    channel << get_channel('Consolidated: All', cnty, loc) if channel.blank?  
    channel    
  end 
  
  # use regex to match key words in title & description to find right channels  
  def self.select_college_channel(title, school, descr)
    channel = []
    [['Opera|Choir|Theater|Symphony|Dance|Ballet|Concerto|Theatre', 'Performing Arts'],  
     ['Speaker|Lecture|Discussion|Talk|Author|Panel', 'Speaker'],
     ['Sculpture|Crafts|Art|Painting|Exhibit|Gallery', 'Art Activities'],  
     ['Science|Natural History|Technology|Physics', 'Science'],
     ['Screening|Film|Movie|Cinema|Documentary', 'Film'], 
     ['Concert|Drama|Comedy','Lively']].each do |str|
       if !(title.downcase =~ /^.*\b(#{str[0].downcase})\b.*$/i).nil? || !(descr.downcase =~ /^.*\b(#{str[0].downcase})\b.*$/i).nil?
         channel << get_channel_by_name([school, str[1]].join('%')) 
       end      
     end
    channel << get_channel_by_name([school, "Consolidated"].join('%'))   
    channel
  end    

  def self.find_channel(cid)
    includes({:subscriptions => [{:user=>[{:host_profiles=>[:scheduled_events, :private_events]}]}]}).find(cid)
  end  
      
  define_index do
    indexes :channel_name, :sortable => true
    indexes :bbody
    indexes :cbody
   
    has :ID, :as => :channel_id
    where "(status = 'active' AND hide = 'no') "
    set_property :enable_star => 1
    set_property :min_prefix_len => 3
  end    

  sphinx_scope(:name_first) { 
    {:order => 'channel_name ASC'}
  }  
  
  default_sphinx_scope :name_first
end
