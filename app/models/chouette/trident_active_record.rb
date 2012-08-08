class Chouette::TridentActiveRecord < Chouette::ActiveRecord
    before_validation :prepare_auto_columns
    after_create :build_objectid

    self.abstract_class = true
    #
    # triggers to generate objectId and objectVersion 
    # TODO setting prefix in referential object
    
    def self.object_id_key
      model_name
    end
    
    def prefix
      "NINOXE"
    end
    def prepare_auto_columns
      # logger.info 'calling before_validation'
      # logger.info 'start before_validation : '+self.objectid.to_s
      if self.objectid.blank?
        # if empty, generate a pending objectid which will be completed after creation
        self.objectid = "#{prefix}:#{self.class.object_id_key}:__pending_id__#{rand(1000)}"
      elsif not self.objectid.include? ':'
        # if one token : technical token : completed by prefix and key
        self.objectid = "#{prefix}:#{self.class.object_id_key}:#{self.objectid}"
      end
      # logger.info 'end before_validation : '+self.objectid
      # initialize or update version
      if self.object_version.nil?
        self.object_version = 1
      else
        self.object_version += 1
      end
      self.creation_time = Time.now
      self.creator_id = 'chouette'
    end
    
    def build_objectid
      # logger.info 'start after_create : '+self.objectid
      if self.objectid.include? ':__pending_id__'
        base_objectid = self.objectid.rpartition(":").first
        self.update_attributes( :objectid => "#{base_objectid}:#{self.id}", :object_version => (self.object_version - 1) )
      end
      # logger.info 'end after_create : '+self.objectid
    end

  validates_presence_of :objectid
  validates_uniqueness_of :objectid
  validates_numericality_of :object_version
  validate :objectid_format_compliance

  def objectid_format_compliance
    unless self.objectid.valid?
      errors.add(:objectid, "is not a valid ObjectId object")
    end
    unless self.objectid.object_type==self.class.object_id_key
      errors.add(:objectid, "doesn't have expected object_type: #{self.class.objectid_type}")
    end
  end

  def self.model_name
    ActiveModel::Name.new self, Chouette, self.name.demodulize
  end

  def objectid
    Chouette::ObjectId.new read_attribute(:objectid)
  end

#  def version
#    self.object_version
#  end

#  def version=(version)
#    self.object_version = version
#  end

  before_validation :default_values, :on => :create
  def default_values
    self.object_version ||= 1
  end

  def timestamp_attributes_for_update #:nodoc:
    [:creation_time]
  end
  
  def timestamp_attributes_for_create #:nodoc:
    [:creation_time]
  end

end
