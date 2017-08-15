#~# ORIGINAL return

return            

#~# EXPECTED

return

#~# ORIGINAL 

return  1

#~# EXPECTED

return 1

#~# ORIGINAL 

return  1 , 2

#~# EXPECTED

return 1, 2

#~# ORIGINAL 

return  1 , 
 2

#~# EXPECTED

return 1, 2

#~# ORIGINAL 

return a b

#~# EXPECTED

return a b

#~# ORIGINAL return with line length
#~# line_length: 10

return                looooong_identifier

#~# EXPECTED

return looooong_identifier
