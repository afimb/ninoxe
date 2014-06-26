class Chouette::TimeTableDate < Chouette::ActiveRecord
  self.primary_key = "id"
  belongs_to :time_table, inverse_of: :dates
  acts_as_list :scope => 'time_table_id = #{time_table_id}',:top_of_list => 0

  validates_presence_of :date
  validates_uniqueness_of :date, :scope => :time_table_id

  attr_accessible :date, :position, :time_table_id, :time_table, :in_out

  after_update :update_parent

  def self.model_name
    ActiveModel::Name.new Chouette::TimeTableDate, Chouette, "TimeTableDate"
  end

  def update_parent
    time_table.shortcuts_update
  end
end

