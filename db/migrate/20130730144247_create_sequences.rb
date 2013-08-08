class CreateSequences < ActiveRecord::Migration
  def change
    create_table :sequences do |t|
      t.binary :sequence_comp, :limit => 16.megabyte
      
      t.timestamps
    end
  end
end
