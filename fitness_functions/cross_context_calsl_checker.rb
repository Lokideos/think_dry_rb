require 'parser/current'

module FitnessFunctions
  class ParseFileDependencies
    def call(file_path)
      file = File.read("#{__dir__}/../#{file_path}")

      node = Parser::CurrentRuby.parse(file).loc.node
      find_dependencies(node.to_sexp_array)
    end

    private

    def select_include_nodes(sexp)
      sexp.select { |node| node[0] == :send && node[1].nil? && node[2] == :include }
    end

    def select_di_import_node(import_sexps)
      import_sexps.select { |node| Array(node[3][1])[2] == :Import }
    end

    def get_imported_dependencies(import_sexps)
      import_sexps.empty? ? [] : import_sexps.flat_map { |sexp| sexp[3][3][1..].map { |n| n[2][1] } }
    end

    def find_dependencies(sexp) # rubocop:disable Metrics/MethodLength
      di_imports = []

      loop do
        sexp = sexp.pop
        next unless sexp[0] == :begin

        di_imports = get_imported_dependencies(
          select_di_import_node(
            select_include_nodes(sexp)
          )
        )
        break
      end

      di_imports
    end
  end

  class CrossContextCallsChecker
    def call(file_path, whitelist: [])
      di_imports = ParseFileDependencies.new.call(file_path)

      puts "Checking: '#{file_path}'"
      puts "Dependencies for file: #{di_imports}"

      di_imports.each do |dependency|
        next if dependency.start_with?(*whitelist)

        raise "Invalid dependency '#{dependency}' for '#{file_path}'"
      end
    end
  end
end
