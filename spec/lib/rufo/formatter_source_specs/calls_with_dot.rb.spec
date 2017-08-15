#~# ORIGINAL

foo.()

#~# EXPECTED

foo.()

#~# ORIGINAL

foo.( 1 )

#~# EXPECTED

foo.(1)

#~# ORIGINAL

foo.( 1, 2 )

#~# EXPECTED

foo.(1, 2)

#~# ORIGINAL

x.foo.( 1, 2 )

#~# EXPECTED

x.foo.(1, 2)

#~# ORIGINAL leading dot style

x
  .foo.
  bar

#~# EXPECTED

x.foo.bar

#~# ORIGINAL skip

x.
  foo.
  (1,2)

#~# EXPECTED

x.foo.(1, 2)

#~# ORIGINAL skip calls with line_length
#~# line_length: 10

x.foo.yolo.yes.(1,2,3)

#~# EXPECTED

x
  .foo
  .yolo
  .yes
  .(1, 2, 3)
