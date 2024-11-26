require 'minitest/autorun'
require_relative '../lib/hash_ring'

# Test suite for the HashRing implementation
class HashRingTest < Minitest::Test
  def setup
    # Create a new HashRing instance before each test
    @ring = HashRing.new
  end

  # Test that an empty ring returns nil for any key
  def test_empty_ring
    assert_nil @ring.get_node('test_key')
  end

  # Test that a ring with a single node always returns that node
  def test_single_node
    @ring.add_node('node1')
    assert_equal 'node1', @ring.get_node('test_key')
  end

  # Test that consistent hashing properties are maintained with multiple nodes
  def test_multiple_nodes
    # Add several nodes to the ring
    nodes = ['node1', 'node2', 'node3']
    nodes.each { |node| @ring.add_node(node) }
    
    # Verify that the same key always maps to the same node
    key = 'test_key'
    first_result = @ring.get_node(key)
    10.times do
      assert_equal first_result, @ring.get_node(key)
    end
  end

  # Test that the ring works with a custom hash function
  def test_custom_hash_function
    # Create a simple custom hash function that sums byte values
    custom_hash = ->(key) { key.to_s.bytes.sum }
    ring = HashRing.new([], hash_function: custom_hash)
    
    ring.add_node('node1')
    ring.add_node('node2')
    
    # Verify that we can still get a node with the custom hash function
    assert ring.get_node('test_key')
  end

  # Test that node removal works correctly
  def test_node_removal
    @ring.add_node('node1')
    @ring.add_node('node2')
    
    key = 'test_key'
    original_node = @ring.get_node(key)
    
    # Remove one node and verify that the key still maps consistently
    if original_node == 'node1'
      @ring.remove_node('node2')
      assert_equal 'node1', @ring.get_node(key)
    else
      @ring.remove_node('node1')
      assert_equal 'node2', @ring.get_node(key)
    end
  end
end
