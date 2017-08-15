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

#~# ORIGINAL calls with line_length
#~# line_length: 15

x.foo.yolo.yes.(1,2,3)

#~# EXPECTED

x
  .foo
  .yolo
  .yes
  .(1, 2, 3)

#~# ORIGINAL calls inside a method definition
#~# line_length: 15

def x; y.foo.yolo.yes.(1,2,3); end

#~# EXPECTED

def x
  y
    .foo
    .yolo
    .yes
    .(1, 2, 3)
end
