class Image < Asset
  has_attached_file :attachment, :styles => { :normal => "400x300>", :thumb => "160x120>" }
end
