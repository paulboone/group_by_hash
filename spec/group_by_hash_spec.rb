require 'spec_helper'

describe GroupByHash do
  it "should be defineable" do
    g = GroupByHash.new([:col1,:col2,:col3]) {|h| {:count => 1, :random_sum => rand(500)}}    
  end
  
  describe "add_hash_fields" do
    it "should handle simple addition" do
      GroupByHash.new(nil).add_hash_fields({:count => 5},{:count => 25}).should == {:count => 30}      
    end
  end
  
  describe "when flattening" do
    before(:each) do      
      @g = GroupByHash.new([:col1]) {|h| {:count => 1}}        
    end
    
    it "flattening and empty hash should == []" do
      @g.flatten.should == []
    end
    
    it "adding one row" do
      @g << {:col1 => 'disc1'}
      fg = @g.flatten
      fg[0].has_key?(:col1).should == true
      fg[0].has_key?(:count).should == true
      fg[0][:col1].should == 'disc1'
      fg[0][:count].should == 1
    end
    
    it "adding three rows across two keys" do
      @g << {:col1 => 'disc1'}
      @g << {:col1 => 'disc2'}
      @g << {:col1 => 'disc1'}
      fg = @g.flatten
      fg.size.should == 2
      fg.each do |r|
        if r[:col1] == 'disc1'
          r[:count].should == 2
        elsif r[:col1] == 'disc2'
          r[:count].should == 1
        else
          fail
        end
      end      
    end
  end
  
  it "can use extra columns to calculate values" do
    @g = GroupByHash.new([:col1]) {|h| {:units => h[:quantity]}}
    @g << {:col1 => 1, :quantity => 4}
    @g << {:col1 => 1, :quantity => 2}
    @g << {:col1 => 1, :quantity => 5}
    @g[{:col1 => 1}][:units].should == 11
  end
  
  describe "with col1/col2/col3 count" do
    before(:each) do
      @g = GroupByHash.new([:col1,:col2,:col3]) {|h| {:count => 1}}
    end
  
    describe "<<" do
      it "should add hash key with only defined cols" do
        @g << {:col1 => 1,:col2 => 2,:col3 => 3, :extra_col1 => 123}
        @g.size.should == 1
        @g.has_key?({:col1 => 1,:col2 => 2,:col3 => 3}).should == true
      end
      
      it "should add value with only block-defined cols" do
        @g << {:col1 => 1,:col2 => 2,:col3 => 3, :extra_col1 => 123}
        @g.size.should == 1
        @g[{:col1 => 1,:col2 => 2,:col3 => 3}].should == {:count => 1}
      end
    end
  
    
    it "groups right" do
      @g << {:col1 => 1,:col2 => 2,:col3 => 3, :extra_col1 => 123}
      @g << {:col1 => 1,:col2 => 2,:col3 => 3, :extra_col1 => 123}
      @g << {:col1 => 1,:col2 => 2,:col3 => 3, :extra_col1 => 123}
      @g << {:col1 => 1,:col2 => 2,:col3 => 5, :extra_col1 => 123}
      @g << {:col1 => 1,:col2 => 4,:col3 => 5, :extra_col1 => 123}
      @g.has_key?({:col1 => 1,:col2 => 2,:col3 => 3})
      @g[{:col1 => 1,:col2 => 2,:col3 => 3}].should == {:count => 3}
      @g.has_key?({:col1 => 1,:col2 => 2,:col3 => 5})
      @g[{:col1 => 1,:col2 => 2,:col3 => 5}].should == {:count => 1}
      @g.has_key?({:col1 => 1,:col2 => 4,:col3 => 5})
      @g[{:col1 => 1,:col2 => 4,:col3 => 5}].should == {:count => 1}      
    end
  end
end