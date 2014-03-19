class ImageOptimizer
  class PNGOptimizer
    attr_reader :path

    def initialize(path, quality=-1)
      @path = path
      @quality = quality
    end

    def optimize
      return unless png_format?

      if png_optimizer_present?
        optimize_png
      else
        warn 'Attempting to optimize a png without optipng installed. Skipping...'
      end
    end

  private

    def png_format?
      ['png', 'gif'].include? extension(path)
    end

    def extension(path)
      path.split(".").last.downcase
    end

    def optimize_png
      if quality < -1 || quality > 7
        # if outside range, call with 'default' quality
        system "#{png_optimizer_bin} #{path}"

      elsif quality == -1
        # if -1, optimize full quality (for backwards-compatibility)
        system "#{png_optimizer_bin} -o7 #{path}"

      else
        # if we're between 0 and 7, pass it on to optipng
        system "#{png_optimizer_bin} -o#{quality} #{path}"
      end
    end

    def png_optimizer_present?
      !png_optimizer_bin.nil? && !png_optimizer_bin.empty?
    end

    def png_optimizer_bin
      @png_optimzer_bin ||= ENV['OPTIPNG_BIN'] || `which optipng`.strip
    end

  end
end
