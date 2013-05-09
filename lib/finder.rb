class Finder
  attr_accessor :distances, :verbose
  def initialize(distances, opts = {})
    self.distances = distances
    self.verbose = opts[:verbose]
  end

  def find_minimum
    infinity = 1.0/0
    current_minimum = [infinity, 0, 0]

    distances.each_with_clusters do |distance, cluster1, cluster2|
      next unless cluster1.mergable_with?(cluster2)
      if distance < current_minimum[0]
        current_minimum = [distance, cluster1.id, cluster2.id]
      end
    end

    return current_minimum
  end

  def find_maximum
    current_minimum = [0, 0, 0]

    distances.each_with_clusters do |distance, cluster1, cluster2|
      next unless cluster1.mergable_with?(cluster2)
      if distance > current_minimum[0]
        current_minimum = [distance, cluster1.id, cluster2.id]
      end
    end

    return current_minimum
  end

  def clusters
    until distances.done?
      # result = find_minimum
      result = find_maximum
      if verbose
        distances.pretty_print
        puts "Current Min: #{result[1]},#{result[2]} has distance #{result[0]}"
        puts "Merging clusters #{result[1, 2]}"
        puts
      end
      distances.merge_clusters!(*result[1, 2])
    end

    if verbose
      distances.pretty_print
      puts
    end
    return distances.clusters
  end
end
