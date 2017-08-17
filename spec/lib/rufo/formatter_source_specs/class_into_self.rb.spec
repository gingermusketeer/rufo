#~# ORIGINAL 

class  <<  self 
 1 
 end

#~# EXPECTED

class << self
  1
end

#~# ORIGINAL

class << self
end

#~# EXPECTED

class << self; end
