class Chouette::TimeTableDate < Chouette::ActiveRecord
  set_primary_keys :time_table_id, :position
  belongs_to :time_table
  acts_as_list :scope => 'time_table_id = #{time_table_id}',:top_of_list => 0
  
  attr_accessible :date, :position
  def self.model_name
    ActiveModel::Name.new Chouette::TimeTableDate, Chouette, "TimeTableDate"
  end
end

