class CreateJoinTablePrimerSuitePrimer < ActiveRecord::Migration
  def change
    create_join_table :primers, :primer_suites do |t|
      # t.index [:primer_id, :primer_suite_id]
      # t.index [:primer_suite_id, :primer_id]
    end
  end
end
