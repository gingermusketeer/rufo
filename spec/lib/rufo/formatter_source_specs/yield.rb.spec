#~# ORIGINAL yield

yield

#~# EXPECTED

yield

#~# ORIGINAL 

yield  1

#~# EXPECTED

yield 1

#~# ORIGINAL 

yield  1 , 2

#~# EXPECTED

yield 1, 2

#~# ORIGINAL 

yield  1 , 
 2

#~# EXPECTED

yield 1, 2

#~# ORIGINAL 

yield( 1 , 2 )

#~# EXPECTED

yield(1, 2)

#~# ORIGINAL yield with line_length
#~# line_legnth: 10

yield                    really_long_operator

#~# EXPECTED

yield really_long_operator
