=begin

=end
class GroupByHash < Hash
  
  #
  # group_by_fields is a list of symbols that MUST be available on datasets passed in via <<
  # blk is a block that returns a hash where each field will be += together 
  def initialize(group_by_fields, &blk)
    @group_by_fields = group_by_fields
    @blk = blk
  end
  
  def flatten
    a = []
    each_pair do |k,v|
      a << k.merge(v)
    end
    a
  end
  
  def <<(array_or_hash)
    h = array_or_hash.clone
    key = h.reject{|k,v| ! @group_by_fields.include?(k)}
    val = h.reject{|k,v|   @group_by_fields.include?(k)}
    if self[key]
      self[key] = add_hash_fields(self[key],@blk.call(val))
    else
      self[key] = @blk.call(val)
    end
    self
  end
  
  def add_hash_fields(h1,h2)
    h = {}
    h1.each_pair do |k,v|
      h[k] = v + h2[k]
    end
    h
  end
end