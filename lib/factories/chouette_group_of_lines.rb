Factory.define :group_of_line, :class => "Chouette::GroupOfLine" do |group_of_line|
  group_of_line.sequence(:name) { |n| "Group Of Line #{n}" }
  group_of_line.sequence(:objectid) { |n| "test:GroupOfLine:#{n}" }
  group_of_name.sequence(:registration_number) { |n| "test:GroupOfLine:#{n}" }
end
