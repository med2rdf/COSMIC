# coding: utf-8

module CosmicRdf
  module Parser
    # Represents a tsv row
    class Row
      FORMATTERS = {
        s: ->(v) { v.present? ? v.to_s : nil },
        i: ->(v) { v.present? ? v.to_i : nil },
        f: ->(v) { v.present? ? v.to_f : nil },
        b: ->(v) { v.present? && v.downcase.in?(%w[y yes]) },
        n: ->(v) { v == 'NS' ? nil : v }
      }.freeze

      def initialize(row, headers)
        @attrs = {}
        parse(row, headers)
      end

      def to_json
        @attrs.to_json
      end

      def [](key)
        @attrs[key.to_sym]
      end

      def attributes
        @attrs
      end
      
      protected

      def parse(row, headers)
        row.each do |key, val|
          spec = headers[key]
          next unless spec
          @attrs[spec[:name]] = fmt(spec[:fmt], val)
          define_singleton_method(spec[:name]) { @attrs[spec[:name]] }
        end
      end

      def fmt(key, val)
        if FORMATTERS.key? key
          FORMATTERS[key][val]
        elsif key.is_a? Proc
          key[val]
        else
          FORMATTERS[:s][val]
        end
      end
    end
  end
end
