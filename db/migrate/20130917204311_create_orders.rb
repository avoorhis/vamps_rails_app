class CreateOrders < ActiveRecord::Migration
  def change
    unless ActiveRecord::Base.connection.table_exists? 'orders'    
      create_table :orders do |t|
        t.string :order, {:limit => 300, :null => false, :default => ''}
        t.index  :order, {:name => "order", :unique => true}
      end
    end
  end
end
