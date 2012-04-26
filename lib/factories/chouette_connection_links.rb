Factory.define :connection_link, :class => "Chouette::ConnectionLink" do |link|
  link.sequence(:name) { |n| "Connection link #{n}" }
  link.sequence(:link_type_code) { |n| Chouette::ConnectionLinkType.new( n % 3) }
  link.sequence(:objectid) { |n| "test:ConnectionLink:#{n}" }

  link.association :departure, :factory => :stop_area
  link.association :arrival, :factory => :stop_area

  
end

