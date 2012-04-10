class Chouette::ObjectId < String

  def valid?
    parts.present?
  end
  alias_method :objectid?, :valid?

  @@format = /(\w+):(\w+):([\w\d]+)/ # Selon Marc c'est de la merde
  cattr_reader :format

  def parts
    match(format).try(:captures)
  end

  def system_id
    parts.try(:first)
  end

  def object_type
    parts.try(:second)
  end

  def local_id
    parts.try(:third)
  end
  
  def self.create(system_id, object_type, local_id)
    new [system_id, object_type, local_id].join(":")
  end

  def self.new(string)
    string ||= ""
    self === string ? string : super
  end

end
