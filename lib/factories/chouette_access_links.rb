Factory.define :access_link, :class => "Chouette::AccessLink" do |link|
  link.sequence(:name) { |n| "Access link #{n}" }
  link.link_type "Mixed" 
  link.link_orientation "AccessPointToStopArea"
  link.sequence(:objectid) { |n| "test:AccessLink:#{n}" }

  link.association :stop_area, :factory => :stop_area
  link.association :access_point, :factory => :access_point

end

