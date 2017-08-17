#~# ORIGINAL

foo . bar  =  1

#~# EXPECTED

foo.bar = 1

#~# ORIGINAL setter with line length
#~# line_length: 10

foo   . bar =   1

#~# EXPECTED

foo
  .bar = 1

#~# ORIGINAL setter with tiny line length
#~# line_length: 1

foo   . bar =   1

#~# EXPECTED

foo
  .bar =
    1

#~# ORIGINAL

foo . bar  = 
 1

#~# EXPECTED

foo.bar = 1

#~# ORIGINAL

foo . 
 bar  = 
 1

#~# EXPECTED

foo.bar = 1

#~# ORIGINAL

foo:: bar  =  1

#~# EXPECTED

foo::bar = 1

#~# ORIGINAL
#~# line_length: 1

foo::       bar = 100

#~# EXPECTED

foo::bar =
  100

#~# ORIGINAL

foo:: bar  = 
 1

#~# EXPECTED

foo::bar = 1

#~# ORIGINAL

foo:: 
 bar  = 
 1

#~# EXPECTED

foo::bar = 1
