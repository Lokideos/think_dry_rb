# frozen_string_literal: true

Sequel.migration do
  up do
    extension :pg_enum
    create_enum(:characteristic_type_enum, %w(happines playful safeties brightness))

    create_table :toys_characteristics do
      primary_key :id, type: :Bignum
      foreign_key :toy_id, :toys, type: 'bigint', null: false, key: [:id]
      column :value, 'character varying'
      column :comment, 'character varying'
      column :characteristic_type, 'characteristic_type_enum'
      column :will_recommend, 'boolean'
      column :created_at, 'timestamp(6) without time zone', null: false
      column :updated_at, 'timestamp(6) without time zone', null: false
    end
  end

  down do
    extension :pg_enum
    drop_table :toys_characteristics
    drop_enum(:characteristic_type_enum)
  end
end
