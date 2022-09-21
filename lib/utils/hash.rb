module Utils
  module Hash
    def self.deep_merge(hash_1, hash_2)
      hash_1.merge(hash_2) do |_key, value_1, value_2|
        if value_1.is_a?(::Hash) && value_2.is_a?(::Hash)
          deep_merge(value_1, value_2)
        else
          value_2
        end
      end
    end
  end
end
