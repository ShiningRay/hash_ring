require 'minitest/autorun'
require_relative '../lib/hash_ring'

class HashRingTest < Minitest::Test
  def setup
    @ring = HashRing.new
  end

  def test_empty_ring
    assert_nil @ring.get_node('test_key')
  end

  def test_single_node
    @ring.add_node('node1')
    assert_equal 'node1', @ring.get_node('test_key')
  end

  def test_multiple_nodes
    nodes = ['node1', 'node2', 'node3']
    nodes.each { |node| @ring.add_node(node) }
    
    # 相同的key应该总是映射到相同的节点
    key = 'test_key'
    first_result = @ring.get_node(key)
    10.times do
      assert_equal first_result, @ring.get_node(key)
    end
  end

  def test_custom_hash_function
    # 使用一个简单的自定义哈希函数
    custom_hash = ->(key) { key.to_s.bytes.sum }
    ring = HashRing.new([], hash_function: custom_hash)
    
    ring.add_node('node1')
    ring.add_node('node2')
    
    assert ring.get_node('test_key')
  end

  def test_node_removal
    @ring.add_node('node1')
    @ring.add_node('node2')
    
    key = 'test_key'
    original_node = @ring.get_node(key)
    
    if original_node == 'node1'
      @ring.remove_node('node2')
      assert_equal 'node1', @ring.get_node(key)
    else
      @ring.remove_node('node1')
      assert_equal 'node2', @ring.get_node(key)
    end
  end
end
