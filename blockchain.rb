require 'digest'
require 'pp'
require 'byebug'

class Block
  attr_accessor :prev_hash, :data, :timestamp, :hash, :time_mine

  def initialize(prev_hash, data)
    @prev_hash = prev_hash
    @data = data
    @timestamp = Time.now
    @hash = calculate_hash()
    @time_mine = 0
  end

  def calculate_hash
    Digest::SHA2.new(256).hexdigest @prev_hash.to_s + Marshal.dump(@data).to_s + @timestamp.to_s + @time_mine.to_s
  end

  def mine(difficulty)
    until @hash.start_with?('0'*difficulty)
      @time_mine += 1
      @hash = calculate_hash()
    end
  end
end


class Blockchain
  attr_accessor :chain, :difficulty

  def initialize(difficulty)
    @difficulty = difficulty
    generise_block = block = Block.new('0000', {data: 'generise block'})
    @chain = [generise_block]
  end

  def last_block
    @chain[-1]
  end

  def add_block(data)
    new_block = Block.new(last_block.hash, data)
    pp('Start mine')
    new_block.mine(@difficulty)
    pp('End mine:', new_block.time_mine)
    @chain.push(new_block)
  end

  def valid?
    for i in 1..@chain.size-1 do
      return false if @chain[i].hash != @chain[i].calculate_hash || @chain[i].prev_hash != @chain[i-1].hash
    end
    true
  end
end

hoc_blockchian = Blockchain.new(5)

hoc_blockchian.add_block({
  from: 'Tom',
  to: 'Jerry',
  amount: 100
})

hoc_blockchian.add_block({
  from: 'Tom',
  to: 'Jerry',
  amount: 500
})

hoc_blockchian.add_block({
  secret: 'xxxxxxxxx'
})

pp(hoc_blockchian)
pp(hoc_blockchian.valid?) #true

# Can not modify block
hoc_blockchian.chain[1].data = {
  from: 'Tom',
  to: 'Hacker',
  amount: 1000
}
pp(hoc_blockchian.valid?) #false

