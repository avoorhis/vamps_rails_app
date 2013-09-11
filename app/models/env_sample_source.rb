class EnvSampleSource < ActiveRecord::Base
  has_many :datasets
  
  validates :env_source_name, inclusion: { in: ["", "air", "extreme habitat", "host associated", "human associated", "human-amniotic-fluid", "human-blood", "human-gut", "human-oral", "human-skin", "human-urine", "human-vaginal", "indoor", "microbial mat/biofilm", "miscellaneous_natural_or_artificial_environment", "plant associated", "sediment", "soil/sand", "unknown", "wastewater/sludge", "water-freshwater", "water-marine"], message: "%{value} is not a valid env_source_name" }

  validates :env_sample_source_id, inclusion: { in: [0, 10, 20, 30, 40, 41,42,43,44,45,46, 47, 50, 60, 70, 80, 90, 100, 110, 120, 130, 140], message: "%{value} is not a valid env_sample_source_id" }
  
  validates :env_source_name, :env_sample_source_id, uniqueness: true
  
end
