class CreateJoinTablePrimerSuitePrimer < ActiveRecord::Migration
  def change
    create_join_table :primers, :primer_suites do |t|
      t.index [:primer_id, :primer_suite_id], {:name => "primer_id_primer_suite_id", :unique => true} 
      t.index [:primer_suite_id, :primer_id], {:name => "primer_suite_id_primer_id", :unique => true}
    end
  end
end
