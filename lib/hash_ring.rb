require 'digest'
require_relative 'hash_ring/version'

# HashRing implements consistent hashing with support for custom hash functions
# and configurable virtual node counts. This implementation uses a binary search
# to find the appropriate node for a given key, providing O(log n) lookup time.
class HashRing
  # Internal class representing a node (physical or virtual) in the hash ring
  class Node
    attr_reader :key, :hash_value
    
    # @param key [String] The identifier of the physical node
    # @param hash_value [Integer] The hash value determining the node's position on the ring
    def initialize(key, hash_value)
      @key = key
      @hash_value = hash_value
    end
  end

  # Default number of virtual nodes to create per physical node
  DEFAULT_REPLICAS = 100

  # Initialize a new HashRing
  #
  # @param nodes [Array<String>] Initial list of nodes to add to the ring
  # @param replicas [Integer] Number of virtual nodes to create per physical node
  # @param hash_function [Proc] Custom hash function to use (must return an integer)
  def initialize(nodes = [], replicas: DEFAULT_REPLICAS, hash_function: nil)
    @replicas = replicas
    @hash_function = hash_function || method(:default_hash)
    @nodes = []
    @ring = []
    nodes.each { |node| add_node(node) }
  end

  # Add a new node to the ring
  #
  # @param node [String] The identifier of the node to add
  # @return [String] The added node's identifier
  def add_node(node)
    @replicas.times do |i|
      hash = @hash_function.call("#{node}:#{i}")
      @ring << Node.new(node, hash)
    end
    @ring.sort_by!(&:hash_value)
    node
  end

  # Remove a node from the ring
  #
  # @param node [String] The identifier of the node to remove
  # @return [String] The removed node's identifier
  def remove_node(node)
    @ring.reject! { |n| n.key == node }
    node
  end

  # Get the node responsible for the given key
  #
  # @param key [String] The key to look up
  # @return [String, nil] The node responsible for the key, or nil if the ring is empty
  def get_node(key)
    return nil if @ring.empty?
    
    hash = @hash_function.call(key.to_s)
    node_index = binary_search(hash)
    @ring[node_index].key
  end

  private

  # Perform a binary search to find the first node with a hash value
  # greater than or equal to the given hash
  #
  # @param hash [Integer] The hash value to search for
  # @return [Integer] The index of the appropriate node
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

    # If we've gone past the end of the ring, wrap around to the first node
    left >= @ring.size ? 0 : left
  end

  # Default hash function using MD5
  #
  # @param key [String] The key to hash
  # @return [Integer] A 128-bit integer hash value
  def default_hash(key)
    Digest::MD5.hexdigest(key.to_s).hex
  end
end
