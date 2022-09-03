# frozen_string_literal: true

Sequel.migration do
  up do
    add_column :accounts, :balance, BigDecimal, default: 0.0, null: false
    add_column :accounts, :active, TrueClass, default: true, null: false
  end

  down do
    drop_column :accounts, :balance
    drop_column :accounts, :active
  end
end
