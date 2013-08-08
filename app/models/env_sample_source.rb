class EnvSampleSource < ActiveRecord::Base
  has_many :datasets
  
  validates :env_source_name, inclusion: { in: %w(air extreme habitat host associated human associated human-amniotic-fluid human-blood human-gut human-oral human-skin human-urine human-vaginal indoor microbial mat/biofilm miscellaneous_natural_or_artificial_environment plant associated sediment soil/sand unknown wastewater/sludge water-freshwater water-marine),
      message: "%{value} is not a valid env_source_name" }

  validates :env_sample_source_id, inclusion: { in: [0, 10, 20, 30, 40, 45, 47, 43, 42, 41, 46, 44, 140, 50, 60, 70, 80, 90, 100, 110, 120, 130],
      message: "%{value} is not a valid env_sample_source_id" }
  
  
end
