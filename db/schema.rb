Sequel.migration do
  change do
    create_table(:accounts) do
      primary_key :id, :type=>:Bignum
      column :created_at, "timestamp(6) without time zone", :null=>false
      column :updated_at, "timestamp(6) without time zone", :null=>false
      column :balance, "numeric", :default=>Kernel::BigDecimal("0.0"), :null=>false
      column :active, "boolean", :default=>true, :null=>false
    end
    
    create_table(:schema_migrations) do
      column :filename, "text", :null=>false
      
      primary_key [:filename]
    end
    
    create_table(:test_results) do
      primary_key :id, :type=>:Bignum
      foreign_key :account_id, :accounts, :type=>"bigint", :null=>false, :key=>[:id]
      column :value, "character varying"
      column :comment, "character varying"
      column :characteristic_type, "character varying"
      column :will_recommend, "boolean"
      column :created_at, "timestamp(6) without time zone", :null=>false
      column :updated_at, "timestamp(6) without time zone", :null=>false
    end
    
    create_table(:toys) do
      primary_key :id, :type=>:Bignum
      foreign_key :account_id, :accounts, :type=>"bigint", :key=>[:id]
      column :tested, "boolean", :default=>false
      column :created_at, "timestamp(6) without time zone", :null=>false
      column :updated_at, "timestamp(6) without time zone", :null=>false
    end
    
    create_table(:toys_characteristics) do
      primary_key :id, :type=>:Bignum
      foreign_key :toy_id, :toys, :type=>"bigint", :null=>false, :key=>[:id]
      column :value, "character varying"
      column :comment, "character varying"
      column :characteristic_type, "characteristic_type_enum"
      column :will_recommend, "boolean"
      column :created_at, "timestamp(6) without time zone", :null=>false
      column :updated_at, "timestamp(6) without time zone", :null=>false
    end
  end
end
