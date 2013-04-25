class Promo < KitsCentralModel
  set_primary_key 'ID'

  has_many :pictures, :as => :imageable, :dependent => :destroy
  has_many :promo_codes, :as => :promoable, :dependent => :destroy
  
  scope :notempty, where("bbody is not null")
  scope :unhidden, :conditions => { :hide.downcase => 'no' }
  scope :getquote, :conditions => { :promo_type.downcase => 'quote' }
  
  def ssid
    subscriptionsourceID
  end

  def start_date
    promostartdate.to_date if promostartdate
  end
  
  def end_date
    promoenddate.to_date if promoenddate
  end 
   
  def get_zip
    mapzip.blank? ? '' : mapzip
  end
  
  def get_city
    mapcity.blank? ? '' : mapcity
  end
  
  def get_state
    mapstate.blank? ? '' : mapstate
  end
  
  def get_location
    location.blank? || !(location =~ /http/i).nil? ? get_place.blank? ? '' : get_place : location
  end
  
  def get_place
    mapplacename.blank? ? '' : mapplacename
  end
  
  def cityState
    if mapcity && mapstate
      [mapcity, mapstate].compact.join(', ')
    elsif !get_city.blank?
      mapcity
    else
      ''     
    end
  end
  
  def csz
    mapcity.blank? ? '' : mapstate.blank? ? mapcity : [mapcity, mapstate].compact.join(', ') + ' ' + get_zip
  end
  
  def location_details
    get_location.blank? ? csz : [get_location, mapstreet, csz].join(', ') unless get_place.blank? && csz.blank?
  end    
  
  def summary
    bbody.gsub("\\n",' ').gsub("\r\n",' ').gsub("\n",' ').gsub("<br />", ' ').html_safe[0..64] + '...' rescue nil
  end
    
  def self.active
    notempty.unhidden.where(:status.downcase => 'active')
  end
    
  def self.random
    active.getquote.offset(rand(self.count)).first
  end
  
  # check if pictures already exists
  def any_pix?
    pictures.detect { |x| x && !x.photo_file_name.nil? }
  end
  
  def self.any_image_promos? usr, ptype
    @promos = get_promos usr, ptype
    @promos.detect {|p| p.any_pix? } rescue nil
  end
  
  def self.get_promos usr, ptype
    where('promoenddate >= ? and promo_type = ?', Date.today, ptype).select { |p| p.subscribed?(usr) } rescue nil 
  end
    
  def subscribed?(usr)
    slist = usr.subscriptions rescue nil
    slist.blank? ? false : slist.detect {|u| u.channelID == ssid && u.status.downcase == 'active' } 
  end   
  
  define_index do
    indexes :promo_name, :sortable => true
    indexes :bbody
    indexes :cbody
   
    has :ID, :as => :promo_id
    has :promo_type
    has :promostartdate
    has :promoenddate
    has :mapcity
    where "(status = 'active' and promoenddate >= curdate() ) "
    set_property :enable_star => 1
    set_property :min_prefix_len => 3
  end
  
  sphinx_scope(:datetime_first) { 
    {:order => 'promostartdate ASC'}
  }  
  
  default_sphinx_scope :datetime_first

end
