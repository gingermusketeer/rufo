#~# ORIGINAL break

break

#~# EXPECTED

break

#~# ORIGINAL 

break  1

#~# EXPECTED

break 1

#~# ORIGINAL 

break  1 , 2

#~# EXPECTED

break 1, 2

#~# ORIGINAL 

break  1 , 
 2

#~# EXPECTED

break 1, 2

#~# ORIGINAL break with line_length
#~# line_length: 10

break            my_really_long_value

#~# EXPECTED

break my_really_long_value
