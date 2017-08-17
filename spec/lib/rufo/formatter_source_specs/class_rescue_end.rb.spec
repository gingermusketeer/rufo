#~# ORIGINAL 

  class Foo 
 raise 'bar' 
 rescue Baz =>  ex 
 # do something
 end 

#~# EXPECTED

class Foo
  raise 'bar'
rescue Baz => ex
  # do something
end

#~# ORIGINAL

class Foo
raise            'bar'
    rescue Baz =>   ex            #ex is important
      ok
end

#~# EXPECTED

class Foo
  raise 'bar'
rescue Baz => ex # ex is important
  ok
end
