module ActionView
    module Helpers
        module AssetTagHelper
            def image_path(source, options = {})
                filename = super
                return filename if (Rails.env.development? || Rails.env.test? || !options.key?(:optimized))
            
                (folder, name) = File.split(filename)
                "#{folder}/small/#{name}"
            end

            # Overriding asset_path may be a better option
            def image_tag(source, options = {})
                options = options.symbolize_keys
                check_for_image_tag_errors(options)
                skip_pipeline = options.delete(:skip_pipeline)

                if skip_pipeline
                    options[:src] = resolve_image_source(source, skip_pipeline)
                else
                    # correct image path
                    options[:src] = image_path(source, options)
                end

                if options[:srcset] && !options[:srcset].is_a?(String)
                    options[:srcset] = options[:srcset].map do |src_path, size|
                    src_path = path_to_image(src_path, skip_pipeline: skip_pipeline)
                    "#{src_path} #{size}"
                    end.join(", ")
                end

                options[:width], options[:height] = extract_dimensions(options.delete(:size)) if options[:size]
                tag("img", options)
            end
        end
    end
end
