Container.register_provider(:db) do |_container|
  prepare do
    require 'rom'
    require 'rom-sql'
    require 'rom-repository'

    user = Settings.db.to_h[:user]
    password = Settings.db.to_h[:password]
    host = Settings.db.to_h[:host]
    port = Settings.db.to_h[:port]
    database = Settings.db.to_h[:database]
    db_url = "postgres://#{user}:#{password}@#{host}:#{port}/#{database}"
    rom = ROM.container(:sql, db_url) do |configuration|
      configuration.relation(:accounts) do
        schema(infer: true) do
          associations do
            has_many :toys
          end
        end
        auto_struct true
      end

      configuration.relation(:toys) do
        schema(infer: true) do
          associations do
            has_one :toys_characteristics

            belongs_to :account
          end
        end
        auto_struct true
      end

      configuration.relation(:toys_characteristics) do
        schema(infer: true) do
          associations do
            belongs_to :toy
          end
        end
        auto_struct true
      end
    end
    register('persistence', rom)
  end
end
