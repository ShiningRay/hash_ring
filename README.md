# HashRing

一个灵活的 Ruby 一致性哈希实现，支持自定义哈希函数和可配置的虚拟节点。

## 特性

- 支持自定义哈希函数
- 可配置的虚拟节点数量
- 动态添加/删除节点
- O(log n) 的查找时间复杂度
- 使用 MD5 作为默认哈希函数

## 安装

添加这一行到你的应用程序的 Gemfile:

```ruby
gem 'hash_ring'
```

然后执行:

    $ bundle install

或者直接安装:

    $ gem install hash_ring

## 使用方法

### 基本使用

```ruby
require 'hash_ring'

# 创建一个新的 HashRing 实例
ring = HashRing.new

# 添加节点
ring.add_node('server1')
ring.add_node('server2')
ring.add_node('server3')

# 获取键对应的节点
node = ring.get_node('some_key')
puts "Key 'some_key' maps to node: #{node}"

# 移除节点
ring.remove_node('server2')
```

### 自定义哈希函数

你可以通过提供自己的哈希函数来自定义哈希算法。哈希函数需要满足以下要求：

1. 接受一个字符串参数（键）
2. 返回一个整数值
3. 对相同的输入总是返回相同的输出
4. 输出应该在整个整数范围内均匀分布

以下是一些自定义哈希函数的示例：

```ruby
# 1. 使用简单的字节求和哈希函数
byte_sum_hash = ->(key) { key.to_s.bytes.sum }
ring = HashRing.new([], hash_function: byte_sum_hash)

# 2. 使用 FNV-1a 哈希算法
fnv_hash = ->(key) {
  hash = 0x811c9dc5
  key.to_s.each_byte do |byte|
    hash ^= byte
    hash *= 0x01000193
  end
  hash
}
ring = HashRing.new([], hash_function: fnv_hash)

# 3. 使用 SHA-256 哈希
require 'digest'
sha256_hash = ->(key) { 
  Digest::SHA256.hexdigest(key.to_s).hex
}
ring = HashRing.new([], hash_function: sha256_hash)

# 4. 使用 MurmurHash3
require 'murmurhash3'
murmur_hash = ->(key) { 
  MurmurHash3::V32.str_hash(key.to_s) 
}
ring = HashRing.new([], hash_function: murmur_hash)
```

选择哈希函数时的注意事项：

1. **分布均匀性**：哈希函数应该产生均匀分布的哈希值，以确保负载均衡
2. **性能**：哈希函数的计算速度应该足够快，因为它会被频繁调用
3. **碰撞率**：较低的碰撞率有助于更好的负载分布
4. **一致性**：相同的输入必须产生相同的输出

默认情况下，HashRing 使用 MD5 哈希算法，这在大多数情况下都能提供良好的性能和分布。

### 配置虚拟节点数量

虚拟节点（replicas）可以提高哈希环的均匀性。你可以在创建 HashRing 实例时指定虚拟节点的数量：

```ruby
# 每个物理节点创建 200 个虚拟节点
ring = HashRing.new([], replicas: 200)
```

虚拟节点数量的选择考虑因素：
- 更多的虚拟节点会带来更均匀的分布
- 但也会消耗更多的内存
- 默认值（100）适用于大多数场景

## 开发

克隆仓库后，运行 `bin/setup` 来安装依赖。然后，运行 `rake test` 来运行测试。你也可以运行 `bin/console` 来打开一个交互式提示符。

## 贡献

欢迎 Bug 报告和 Pull 请求。

## 许可证

这个 gem 使用 MIT 许可证。
