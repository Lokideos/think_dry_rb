# frozen_string_literal: true

Sequel.migration do
  up do
    create_table :toys do
      primary_key :id, type: :Bignum
      foreign_key :account_id, :accounts, type: 'bigint', null: true, key: [:id]
      column :tested, 'boolean', default: false
      column :created_at, 'timestamp(6) without time zone', null: false
      column :updated_at, 'timestamp(6) without time zone', null: false
    end
  end

  down do
    drop_table :toys
  end
end
