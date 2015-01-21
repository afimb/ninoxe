Factory.define :footnote, :class => "Chouette::Footnote" do |footnote|
  footnote.sequence(:code) { |n| "#{n}" }
  footnote.sequence(:label) { |n| "footnote #{n}" }
  footnote.association :line, :factory => :line
end

