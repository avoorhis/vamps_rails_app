class CreatePrimerSuites < ActiveRecord::Migration
  def change
    create_table :primer_suites do |t|
      t.string :primer_suite, {:limit => 25, :null => false, :default => ''}
    end
    add_index :primer_suites, :primer_suite, {:name => "primer_suite", :unique => true}
  end
end
