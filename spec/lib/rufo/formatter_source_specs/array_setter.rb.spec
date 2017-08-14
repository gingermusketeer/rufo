#~# ORIGINAL

foo[ ]  =  1

#~# EXPECTED

foo[] = 1

#~# ORIGINAL

foo[ 1 , 2 ]  =  3

#~# EXPECTED

foo[1, 2] = 3

#~# ORIGINAL skip
#~# line_length: 10

foo[ 1 , 2 , 3, 4 , 5 , 6 ]  =  7

#~# EXPECTED

foo[
  1,
  2,
  3,
  4,
  5,
  6,
] = 7
