module DbClustering
  module Models
    class Point
      attr_accessor :cluster, :is_noise, :datasource_point

      def initialize(datasource_point:, vector_params: nil)
        @is_noise = false
        @cluster = nil
        @datasource_point = datasource_point
        @vector_params = vector_params
      end

      def vector
        if @vector_params
          vector_object = @datasource_point.clustering_vector(@vector_params)
        else
          vector_object = @datasource_point.clustering_vector
        end

        case vector_object
        when Array, Hash
          DbClustering::Models::Vector.new(object: vector_object)
        else
          vector_object
        end
      end

      def visited?
        self.is_noise || !self.cluster.nil?
      end

      def is_edge_point?
        self.is_noise && !self.cluster.nil?
      end

      def is_core_point?
        !self.is_noise && !self.cluster.nil?
      end

      def is_noise_point?
        self.is_noise && self.cluster.nil?
      end
    end
  end
end
