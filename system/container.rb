require 'dry/system/container'
require 'dry/system/loader/autoloading'

class Container < Dry::System::Container
  use :env, inferrer: -> { ENV.fetch('PROJECT_ENV', :development).to_sym }
  use :zeitwerk

  configure do |config|
    config.component_dirs.add 'lib' do |dir|
      dir.memoize = true
    end

    config.component_dirs.add 'contexts' do |dir|
      dir.memoize = true

      dir.auto_register = proc do |component|
        !component.identifier.include?('entities')
        !component.identifier.include?('types')
      end

      dir.namespaces.add 'billing', key: 'contexts.billing'
      dir.namespaces.add 'testing', key: 'contexts.testing'
    end

    config.component_dirs.add 'apps' do |dir|
      dir.memoize = true

      dir.namespaces.add 'in_memory', key: 'in_memory'
    end
  end
end

Import = Container.injector
