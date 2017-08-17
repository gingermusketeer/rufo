#~# ORIGINAL 

@@foo

#~# EXPECTED

@@foo

#~# ORIGINAL

class Foo; @@foo = 100; end

#~# EXPECTED

class Foo
  @@foo = 100
end

