# This is copied from voxpupuli/json-schema
require "addressable/uri"
module Utils
  module URINormalizer
    def self.normalize_ref(ref, base)
      ref_uri = parse(ref)
      base_uri = parse(base)

      ref_uri.defer_validation do
        if ref_uri.relative?
          ref_uri.merge!(base_uri)

          # Check for absolute path
          path, fragment = ref.to_s.split("#")
          if path.nil? || path == ""
            ref_uri.path = base_uri.path
          elsif path[0, 1] == "/"
            ref_uri.path = Pathname.new(path).cleanpath.to_s
          else
            ref_uri.join!(path)
          end

          ref_uri.fragment = fragment
        end

        ref_uri.fragment = "" if ref_uri.fragment.nil? || ref_uri.fragment.empty?
      end

      ref_uri
    end

    def self.parse(uri)
      if uri.is_a?(Addressable::URI)
        uri.dup
      else
        @parse_cache ||= {}
        parsed_uri = @parse_cache[uri]
        if parsed_uri
          parsed_uri.dup
        else
          @parse_cache[uri] = Addressable::URI.parse(uri)
        end
      end
    rescue Addressable::URI::InvalidURIError => e
      raise JSON::Schema::UriError, e.message
    end
  end
end
