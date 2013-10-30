FactoryGirl.define do
    factory :env_sample_source do |e|
      # 0, 10, 20, 30, 40, 45, 47, 43, 42, 41, 46, 44, 140, 50, 60, 70, 80, 90, 100, 110, 120, 130
      # e.sequence(:env_sample_source_id){ |n| n if n < 23 }
      e.env_sample_source_id  100
      e.env_source_name       "unknown"
    end
end