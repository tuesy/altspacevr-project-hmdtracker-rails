FactoryGirl.define do
  factory :hmd do
    name 'Rift'
    company 'Oculus'
    state :announced
    image_url 'http://i.imgur.com/Yypv2Us.gif' # 'Wild Speculation', featuring Palmer Luckey
    announced_at 1.week.ago
  end

  factory :hmd_state do
    hmd
    state :announced
  end
end
