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

#~# ORIGINAL

c.x w 1

#~# EXPECTED

c.x w 1

#~# ORIGINAL

foo.bar
  .baz
  .baz

#~# EXPECTED

foo.bar.baz.baz

#~# ORIGINAL

foo.bar
  .baz
   .baz

#~# EXPECTED

foo.bar.baz.baz 

#~# ORIGINAL

foo.bar(1)
   .baz([
  2,
])

#~# EXPECTED

foo.bar(1).baz([2])

#~# ORIGINAL

foo.bar(1)
   .baz(
  2,
)

#~# EXPECTED

foo.bar(1).baz(2)

#~# ORIGINAL

foo.bar(1)
   .baz(
  qux(
2
)
)

#~# EXPECTED

foo.bar(1).baz(qux(2))

#~# ORIGINAL

foo.bar(1)
   .baz(
  qux.last(
2
)
)

#~# EXPECTED

foo.bar(1).baz(qux.last(2))

#~# ORIGINAL weird nesting with line length
#~# line_length: 19

foo.bar(1)
   .baz(
  qux.last(
2
)
)

#~# EXPECTED

foo
  .bar(1)
  .baz(qux.last(2))

#~# ORIGINAL

foo.bar(
1
)

#~# EXPECTED

foo.bar(1)

#~# ORIGINAL

foo 1, [
  2,

  3,
]

#~# EXPECTED

foo 1, [2, 3]

#~# ORIGINAL skip 

foo :x, {
  :foo1 => :bar,

  :foo2 => bar,
}

multiline :call,
          :foo => :bar,
          :foo => bar

#~# EXPECTED

foo :x, { :foo1 => :bar, :foo2 => bar }

multiline :call, :foo => :bar, :foo => bar 

#~# ORIGINAL
#~# line_length: 10

x
  .foo.bar
  .baz

#~# EXPECTED

x
  .foo
  .bar
  .baz

#~# ORIGINAL

x
  .foo.bar.baz
  .qux

#~# EXPECTED

x.foo.bar.baz.qux 

#~# ORIGINAL skip
#~# line_length: 20

x
  .foo(a.b).bar(c.d).baz(e.f)
  .qux.z(a.b)
  .final

#~# EXPECTED

x
  .foo(a.b)
  .bar(c.d)
  .baz(e.f)
  .qux
  .z(a.b)
  .final

#~# ORIGINAL skip chained call with small identifiers and line lenght
#~# line_length: 1
# this represents an edge case where the output is actually longer than it could be
# without breaking. However, this is hard to fix, because we need to be able to
# detect how long the chain tokens are in order to tell if we should add a softline
# after the first identifier

x.
f

#~# EXPECTED

x.f

#~# ORIGINAL chained calls with small identifiers and line lenght
#~# line_length: 1

x.
f.g

#~# EXPECTED

x
  .f
  .g

#~# ORIGINAL chained calls with tiny line length
#~# line_length: 1

foo
  .foo(a.b).bar(c.d).baz(e.f)
  .qux.z(a.b)
  .final

#~# EXPECTED

foo
  .foo(
    a.b,
  )
  .bar(
    c.d,
  )
  .baz(
    e.f,
  )
  .qux
  .z(
    a.b,
  )
  .final

#~# ORIGINAL

x.y  1,  2

#~# EXPECTED

x.y 1, 2

#~# ORIGINAL

x.y \
  1,  2

#~# EXPECTED

x.y 1, 2
