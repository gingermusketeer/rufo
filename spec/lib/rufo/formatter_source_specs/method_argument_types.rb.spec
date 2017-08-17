#~# ORIGINAL normal args

def meth(arg1)
end

#~# EXPECTED

def meth(arg1); end

#~# ORIGINAL normal args with line length
#~# line_length: 1

def meth(arg1)
end

#~# EXPECTED

def meth(
  arg1
)
end

#~# ORIGINAL multiple normal args

def meth(arg1,arg2)
end

#~# EXPECTED

def meth(arg1, arg2); end

#~# ORIGINAL multiple normal args with line length
#~# line_length: 1

def meth(arg1,arg2)
end

#~# EXPECTED

def meth(
  arg1,
  arg2
)
end

#~# ORIGINAL args with defaults

def meth    x = nil
end

#~# EXPECTED

def meth(x = nil); end

#~# ORIGINAL args with defaults and line length
#~# line_length: 1

def meth(    x = nil)
end

#~# EXPECTED

def meth(
  x = nil
)
end

#~# ORIGINAL rest params

def meth(*args)



end

#~# EXPECTED

def meth(*args); end

#~# ORIGINAL rest params with line length
#~# line_length: 1

def meth(



      *args)

end

#~# EXPECTED

def meth(
  *args
)
end

#~# ORIGINAL post rest params

def meth(        *args,    second_to_last,last
        )
end

#~# EXPECTED

def meth(*args, second_to_last, last); end

#~# ORIGINAL post rest params with line length
#~# line_length: 1

def meth(        *args    ,    last
        )
end

#~# EXPECTED

def meth(
  *args,
  last
)
end

#~# ORIGINAL keyword args

def meth(fallback:       nil)
end

#~# EXPECTED

def meth(fallback: nil); end

#~# ORIGINAL keyword args with line length
#~# line_length: 1

def meth(fallback:       nil)
end

#~# EXPECTED

def meth(
  fallback: nil
)
end

#~# ORIGINAL skip double star params

def meth      **options
end

#~# EXPECTED

def meth(**options); end

#~# ORIGINAL skip double star params with line length
#~# line_length: 1

def meth      **options
end

#~# EXPECTED

def meth(
  **options
)
end

#~# ORIGINAL skip commented args

def meth(
      # this is important
      important_arg,
  # a default, because we're not animals!
  default=nil)
end

#~# EXPECTED

def meth(
  # this is important
  important_arg,
  # a default, because we're not animals!
  default = nil
)
end

#~# ORIGINAL skip all together now

def meth(
      arg1,
   arg2 , arg3    = 7     , *rest,


            last,
   required:,
   not_required: 7, **options)
end

#~# EXPECTED

def meth(arg1, arg2, arg3, *rest, last, required:, not_required: 7, **options); end

#~# ORIGINAL skip all together now with line length

def meth(
      arg1,
   arg2 , arg3    = 7     , *rest,


            last,
   required:,
   not_required: 7, **options)
end

#~# EXPECTED

def meth(
  arg1,
  arg2,
  arg3 = 7,
  *rest,
  last,
  required:,
  not_required: 7,
  **options
)
end
