# frozen_string_literal: true

Sequel.migration do
  up do
    create_table :test_results do
      primary_key :id, type: :Bignum
      foreign_key :account_id, :accounts, type: 'bigint', null: false, key: [:id]
      column :value, 'character varying'
      column :comment, 'character varying'
      column :characteristic_type, 'character varying'
      column :will_recommend, 'boolean'
      column :created_at, 'timestamp(6) without time zone', null: false
      column :updated_at, 'timestamp(6) without time zone', null: false
    end
  end

  down do
    drop_table :accounts
  end
end
