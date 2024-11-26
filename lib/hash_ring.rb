require 'digest'
require_relative 'hash_ring/version'

class HashRing
  class Node
    attr_reader :key, :hash_value
    
    def initialize(key, hash_value)
      @key = key
      @hash_value = hash_value
    end
  end

  DEFAULT_REPLICAS = 100

  def initialize(nodes = [], replicas: DEFAULT_REPLICAS, hash_function: nil)
    @replicas = replicas
    @hash_function = hash_function || method(:default_hash)
    @nodes = []
    @ring = []
    nodes.each { |node| add_node(node) }
  end

  def add_node(node)
    @replicas.times do |i|
      hash = @hash_function.call("#{node}:#{i}")
      @ring << Node.new(node, hash)
    end
    @ring.sort_by!(&:hash_value)
    node
  end

  def remove_node(node)
    @ring.reject! { |n| n.key == node }
    node
  end

  def get_node(key)
    return nil if @ring.empty?
    
    hash = @hash_function.call(key.to_s)
    node_index = binary_search(hash)
    @ring[node_index].key
  end

  private

  def binary_search(hash)
    left = 0
    right = @ring.size - 1

    while left <= right
      mid = (left + right) / 2
      if @ring[mid].hash_value >= hash
        right = mid - 1
      else
        left = mid + 1
      end
    end

    left >= @ring.size ? 0 : left
  end

  def default_hash(key)
    Digest::MD5.hexdigest(key.to_s).hex
  end
end
