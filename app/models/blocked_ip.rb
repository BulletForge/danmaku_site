class BlockedIp < ActiveRecord::Base
  def self.include?(ip)
    !!self.where(:ip_address => ip).first
  end
end
