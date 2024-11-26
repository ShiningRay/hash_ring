require_relative '../lib/hash_ring'

# 创建一个默认的 HashRing 实例
ring = HashRing.new

# 添加一些节点
nodes = ['server1', 'server2', 'server3', 'server4']
nodes.each { |node| ring.add_node(node) }

# 测试一些键的分配
keys = ['user1', 'user2', 'user3', 'post1', 'post2']
puts "使用默认哈希函数的分配结果："
keys.each do |key|
  puts "#{key} -> #{ring.get_node(key)}"
end

puts "\n使用自定义哈希函数的分配结果："
# 创建一个使用简单哈希函数的实例
custom_ring = HashRing.new(nodes, hash_function: ->(key) { key.to_s.bytes.sum })

keys.each do |key|
  puts "#{key} -> #{custom_ring.get_node(key)}"
end

# 测试节点移除后的重新分配
puts "\n移除 server2 后的分配结果："
ring.remove_node('server2')
keys.each do |key|
  puts "#{key} -> #{ring.get_node(key)}"
end
