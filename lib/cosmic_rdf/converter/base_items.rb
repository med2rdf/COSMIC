# coding: utf-8
module CosmicRdf
  module Converter
    class Base_Items
      def self.accessors
        @accessors ||= begin
          method_names = instance_methods.map(&:to_s)
          method_names.select do |method_name|
            method_name.match(/\A\w+\z/) && method_names.include?("#{method_name}=")
          end.map(&:to_sym)
        end
      end
      def initialize()
        self.class.accessors.each do |item|
          self.send("#{item}=", Array.new)
          # p self.send item
        end
      end
    end
  end
end