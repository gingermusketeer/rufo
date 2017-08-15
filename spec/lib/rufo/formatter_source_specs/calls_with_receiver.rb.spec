#~# ORIGINAL

foo . bar . baz

#~# EXPECTED

foo.bar.baz

#~# ORIGINAL

foo . bar( 1 , 2 )

#~# EXPECTED

foo.bar(1, 2)

#~# ORIGINAL

foo . 
 bar

#~# EXPECTED

foo.bar

#~# ORIGINAL

foo . 
 bar . 
 baz

#~# EXPECTED

foo.bar.baz

#~# ORIGINAL

foo 
 . bar

#~# EXPECTED

foo.bar

#~# ORIGINAL

foo 
 . bar 
 . baz

#~# EXPECTED

foo.bar.baz

#~# ORIGINAL

foo.bar
.baz

#~# EXPECTED

foo.bar.baz

#~# ORIGINAL

foo.bar(1)
.baz(2)
.qux(3)

#~# EXPECTED

foo.bar(1).baz(2).qux(3)

#~# ORIGINAL

foobar.baz
.with(
1
)

#~# EXPECTED

foobar.baz.with(1)

#~# ORIGINAL

foo.bar 1, 
 x: 1, 
 y: 2

#~# EXPECTED

foo.bar 1, x: 1, y: 2

#~# ORIGINAL keyword args with line length
#~# line_length: 8

foo.bar 1, 
 x: 1, 
 y: 2

#~# EXPECTED

foo
  .bar(
    1,
    x: 1,
    y: 2,
  )

#~# ORIGINAL

foo
  .bar # x
  .baz

#~# EXPECTED

foo
  .bar # x
  .baz

#~# ORIGINAL skip 

c.x w 1

#~# EXPECTED

c.x w 1

#~# ORIGINAL skip 

foo.bar
  .baz
  .baz

#~# EXPECTED

foo.bar
  .baz
  .baz

#~# ORIGINAL skip 

foo.bar
  .baz
   .baz

#~# EXPECTED

foo.bar
  .baz
  .baz

#~# ORIGINAL skip 

foo.bar(1)
   .baz([
  2,
])

#~# EXPECTED

foo.bar(1)
   .baz([
     2,
   ])

#~# ORIGINAL skip 

foo.bar(1)
   .baz(
  2,
)

#~# EXPECTED

foo.bar(1)
   .baz(
     2,
   )

#~# ORIGINAL skip 

foo.bar(1)
   .baz(
  qux(
2
)
)

#~# EXPECTED

foo.bar(1)
   .baz(
     qux(
       2
     )
   )

#~# ORIGINAL skip 

foo.bar(1)
   .baz(
  qux.last(
2
)
)

#~# EXPECTED

foo.bar(1)
   .baz(
     qux.last(
       2
     )
   )

#~# ORIGINAL skip 

foo.bar(
1
)

#~# EXPECTED

foo.bar(
  1
)

#~# ORIGINAL skip 

foo 1, [
  2,

  3,
]

#~# EXPECTED

foo 1, [
  2,

  3,
]

#~# ORIGINAL skip 

foo :x, {
  :foo1 => :bar,

  :foo2 => bar,
}

multiline :call,
          :foo => :bar,
          :foo => bar

#~# EXPECTED

foo :x, {
  :foo1 => :bar,

  :foo2 => bar,
}

multiline :call,
          :foo => :bar,
          :foo => bar

#~# ORIGINAL skip 

x
  .foo.bar
  .baz

#~# EXPECTED

x
  .foo.bar
  .baz

#~# ORIGINAL skip 

x
  .foo.bar.baz
  .qux

#~# EXPECTED

x
  .foo.bar.baz
  .qux

#~# ORIGINAL skip 

x
  .foo(a.b).bar(c.d).baz(e.f)
  .qux.z(a.b)
  .final

#~# EXPECTED

x
  .foo(a.b).bar(c.d).baz(e.f)
  .qux.z(a.b)
  .final

#~# ORIGINAL skip 

x.y  1,  2

#~# EXPECTED

x.y  1,  2

#~# ORIGINAL skip 

x.y \
  1,  2

#~# EXPECTED

x.y \
  1,  2
