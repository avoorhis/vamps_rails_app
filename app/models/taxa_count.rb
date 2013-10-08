class TaxaCount 

  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend  ActiveModel::Naming

  attr_accessor :dataset_id, :rank_name, :taxon_string_id, :count_per_d

  validates_presence_of :dataset_id, :rank_name, :taxon_string_id, :count_per_d

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def persisted?
    false
  end

end
