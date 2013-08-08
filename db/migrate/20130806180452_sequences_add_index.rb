class SequencesAddIndex < ActiveRecord::Migration
  def change
    add_index :sequences, :sequence_comp, {:unique=>true, :length=>400, :name => 'sequence_comp'}    
  end
end
