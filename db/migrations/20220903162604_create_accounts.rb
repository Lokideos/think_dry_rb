# frozen_string_literal: true

Sequel.migration do
  up do
    create_table :accounts do
      primary_key :id, type: :Bignum
      column :created_at, 'timestamp(6) without time zone', null: false
      column :updated_at, 'timestamp(6) without time zone', null: false
    end
  end

  down do
    drop_table :accounts
  end
end
