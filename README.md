# HashRing

一个灵活的 Ruby 一致性哈希实现，支持自定义哈希函数和可配置的虚拟节点。

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

### 使用自定义哈希函数

```ruby
# 定义一个简单的哈希函数
custom_hash = ->(key) { key.to_s.bytes.sum }

# 创建使用自定义哈希函数的 HashRing
ring = HashRing.new([], hash_function: custom_hash)
```

### 配置虚拟节点数量

```ruby
# 每个物理节点创建 200 个虚拟节点
ring = HashRing.new([], replicas: 200)
```

## 开发

克隆仓库后，运行 `bin/setup` 来安装依赖。然后，运行 `rake test` 来运行测试。你也可以运行 `bin/console` 来打开一个交互式提示符。

## 贡献

欢迎 Bug 报告和 Pull 请求。

## 许可证

这个 gem 使用 MIT 许可证。
