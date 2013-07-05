class Chouette::TimeTablePeriod < Chouette::ActiveRecord
  self.primary_key = "id"
  belongs_to :time_table
  acts_as_list :scope => 'time_table_id = #{time_table_id}',:top_of_list => 0

  attr_accessible :period_start, :period_end, :position,:time_table_id,:time_table
  
  validates_presence_of :period_start
  validates_presence_of :period_end
  
  validate :start_must_be_before_end

  def self.model_name
    ActiveModel::Name.new Chouette::TimeTablePeriod, Chouette, "TimeTablePeriod"
  end
  
  def start_must_be_before_end
    # security against nil values
    if period_end.nil? || period_start.nil?
      return
    end
    if period_end <= period_start
      errors.add(:period_end,I18n.t("activerecord.errors.models.time_table_period.start_must_be_before_end"))
    end
  end
end
