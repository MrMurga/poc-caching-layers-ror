require "benchmark"

module BenchmarkHelper
    IN_MEMORY_CACHE_KEY = 'BenchmarkHelperCache'

    def benchmark
        bms = Benchmark.bm(30) do |x|
            yield x
        end

        arr = ["Time: #{Time.now}", ""]
        bms.each do |test|
            arr << "#{test.label.ljust(40, ' ')} #{test.real.to_d.round(5)}"
        end
        arr
    end
    
    def reset_cache
        Rails.cache.delete(IN_MEMORY_CACHE_KEY)
    end

    def cache
        Benchmark.measure do
            Rails.cache.fetch IN_MEMORY_CACHE_KEY, expires_in: 5.seconds do
                long_memory_task
            end
        end
    end

    def no_cache
        Benchmark.measure do
            long_memory_task
        end
    end

    def long_memory_task
        sum = 0
        (1..10000000).each do |x|
            sum = sum + x
        end
    end
end