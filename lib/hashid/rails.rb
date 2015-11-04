require 'hashid/rails/version'
require 'hashids'
require 'active_record'

module Hashid
  module Rails
    def self.included(base)
      base.extend ClassMethods
    end

    def encoded_id
      self.class.encode_id(id)
    end

    def to_param
      encoded_id
    end
    alias_method :hashid, :to_param

    module ClassMethods
      def hashids
        salt = "#{table_name}#{ENV['HASHIDS_SALT']}"
        Hashids.new(salt, 6)
      end

      def encode_id(id)
        hashids.encode(id)
      end

      def decode_id(id)
        hashids.decode(id.to_s).first
      end

      def find(hashid)
        super decode_id(hashid) || hashid
      end
    end
  end
end

ActiveRecord::Base.send :include, Hashid::Rails
