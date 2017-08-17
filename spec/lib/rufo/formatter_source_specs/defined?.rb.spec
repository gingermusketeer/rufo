#~# ORIGINAL

defined?  1

#~# EXPECTED

defined? 1

#~# ORIGINAL

defined? ( 1 )

#~# EXPECTED

defined? (1)

#~# ORIGINAL

defined?(     1)

#~# EXPECTED

defined?(1)

#~# ORIGINAL

defined?((a, b = 1, 2))

#~# EXPECTED

defined?((a, b = 1, 2))

#~# ORIGINAL defined instance variable

defined?(
  @instance_var


      )

#~# EXPECTED

defined?(@instance_var)

#~# ORIGINAL defined with line length
#~# line_length: 5

defined?(@hello)

#~# EXPECTED

defined?(@hello)
