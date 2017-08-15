#~# ORIGINAL comment

# foo

#~# EXPECTED

# foo

#~# ORIGINAL two_comments

# foo
# bar

#~# EXPECTED

# foo
# bar

#~# ORIGINAL comment with no space before body

#comment

#~# EXPECTED

# comment

#~# ORIGINAL comment with many spaces before body

#           comment

#~# EXPECTED

#           comment

#~# ORIGINAL integer_with_comment

1   # foo

#~# EXPECTED

1 # foo

#~# ORIGINAL comment with double line break

# a

# b

#~# EXPECTED

# a

# b

#~# ORIGINAL comment_with_triple_line_break

# a


# b

#~# EXPECTED

# a

# b

#~# ORIGINAL comment and integer

# a
1

#~# EXPECTED

# a
1

#~# ORIGINAL comment double newline integer

# a


1

#~# EXPECTED

# a

1

#~# ORIGINAL integer_with_comment_and_following_comment

1 # a
# b

#~# EXPECTED

1 # a
# b

#~# ORIGINAL integer_with_comment_and_multiline_break

1 # a

# b

#~# EXPECTED

1 # a

# b

#~# ORIGINAL integers_separated_by_comments

1 # a

2 # b

#~# EXPECTED

1 # a

2 # b

#~# ORIGINAL trailing commens with many newlines

1 # a


2 # b

#~# EXPECTED

1 # a

2 # b

#~# ORIGINAL more_trailing_comments

1 # a






2 # b

#~# EXPECTED

1 # a

2 # b

#~# ORIGINAL still_more_trailing_comments

1 # a


# b


 # c
 2 # b

#~# EXPECTED

1 # a

# b

# c
2 # b

#~# ORIGINAL comment_indentation_inside_method_call

foo(
# comment for foo
foo: 'foo'
)

#~# EXPECTED

foo(
  # comment for foo
  foo: 'foo',
)

#~# ORIGINAL comment_indentation_inside_method_call_2

foo(
 # comment for foo
foo: 'foo'
)

#~# EXPECTED

foo(
  # comment for foo
  foo: 'foo',
)

#~# ORIGINAL comment_indentation_inside_method_call_3

foo(
  # comment for foo
foo: 'foo'
)

#~# EXPECTED

foo(
  # comment for foo
  foo: 'foo',
)

#~# ORIGINAL comment_indentation_inside_method_call_4

foo(
   # comment for foo
foo: 'foo'
)

#~# EXPECTED

foo(
  # comment for foo
  foo: 'foo',
)

#~# ORIGINAL multiple_comments_inside_method_call

foo(
# comment for foo
foo: 'foo',

# comment for bar
bar: 'bar',
)

#~# EXPECTED

foo(
  # comment for foo
  foo: 'foo',

  # comment for bar
  bar: 'bar',
)

#~# ORIGINAL comment after method argument

foo(

foo: "foo" # this is important

)

#~# EXPECTED

foo(
  foo: "foo", # this is important
)

#~# ORIGINAL comments after all arguments

foo(
  foo:"foo", #thoughts
foo:"foo", # thoughts
)

#~# EXPECTED

foo(
  foo: "foo", # thoughts
  foo: "foo", # thoughts
)

#~# ORIGINAL comments after some method arguments

foo(foo:"foo",#my commentary
  bar:"baz",
    carpe: :diem,            # THOUGHTS
           final: :value)

#~# EXPECTED

foo(
  foo: "foo", # my commentary
  bar: "baz",
  carpe: :diem, # THOUGHTS
  final: :value,
)
    
#~# ORIGINAL comments inside a method definition

#my_method
def my_method

  #we need to do some work
  do_work

  # we need to talk about things

  talk_about_things


  # we need to put it back together
  put_it_back_together
end

#~# EXPECTED

# my_method
def my_method
  # we need to do some work
  do_work

  # we need to talk about things

  talk_about_things

  # we need to put it back together
  put_it_back_together
end

#~# ORIGINAL a comment in an operation

1 + # math is so hard
2

#~# EXPECTED

1 + # math is so hard
  2
