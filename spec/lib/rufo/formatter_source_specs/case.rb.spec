#~# ORIGINAL basic then

case 
 when 1 then 2 
 end

#~# EXPECTED

case
when 1 then 2
end

#~# ORIGINAL multiple when then

case 
 when 1 then 2 
 when 3 then 4 
 end

#~# EXPECTED

case
when 1 then 2
when 3 then 4
end

#~# ORIGINAL when then else

case 
 when 1 then 2 else 3 
 end

#~# EXPECTED

case
when 1 then 2
else 3
end

#~# ORIGINAL

case 
 when 1 ; 2 
 end

#~# EXPECTED

case
when 1
  2
end

#~# ORIGINAL when then with multiple statements

case
  when 1 then 2; 3
    end

#~# EXPECTED

case
when 1
  2
  3
end

#~# ORIGINAL if one then needs to break, all should break

case
when 1 then 2
when 2 then 3; 4
end

#~# EXPECTED

case
when 1
  2
when 2
  3
  4
end

#~# ORIGINAL breaks then if the line is too long
#~# line_length: 10

case
when 1 then 1000
end

#~# EXPECTED

case
when 1
  1000
end

#~# ORIGINAL

case 
 when 1 
 2 
 end

#~# EXPECTED

case
when 1
  2
end

#~# ORIGINAL

case 
 when 1 
 2 
 3 
 end

#~# EXPECTED

case
when 1
  2
  3
end

#~# ORIGINAL

case 
 when 1 
 2 
 3 
 when 4 
 5 
 end

#~# EXPECTED

case
when 1
  2
  3
when 4
  5
end

#~# ORIGINAL skip 

case 123 
 when 1 
 2 
 end

#~# EXPECTED

case 123
when 1
  2
end

#~# ORIGINAL skip 

case  # foo 
 when 1 
 2 
 end

#~# EXPECTED

case  # foo
when 1
  2
end

#~# ORIGINAL skip 

case 
 when 1  # comment 
 2 
 end

#~# EXPECTED

case
when 1 # comment
  2
end

#~# ORIGINAL skip 

case 
 when 1 then 2 else 
 3 
 end

#~# EXPECTED

case
when 1 then 2
else
  3
end

#~# ORIGINAL skip 

case 
 when 1 then 2 else ; 
 3 
 end

#~# EXPECTED

case
when 1 then 2
else
  3
end

#~# ORIGINAL skip 

case 
 when 1 then 2 else  # comm 
 3 
 end

#~# EXPECTED

case
when 1 then 2
else # comm
  3
end

#~# ORIGINAL skip 

begin 
 case 
 when 1 
 2 
 when 3 
 4 
  else 
 5 
 end 
 end

#~# EXPECTED

begin
  case
  when 1
    2
  when 3
    4
  else
    5
  end
end

#~# ORIGINAL skip 

case 
 when 1 then 
 2 
 end

#~# EXPECTED

case
when 1
  2
end

#~# ORIGINAL skip 

case 
 when 1 then ; 
 2 
 end

#~# EXPECTED

case
when 1
  2
end

#~# ORIGINAL skip 

case 
 when 1 ; 
 2 
 end

#~# EXPECTED

case
when 1
  2
end

#~# ORIGINAL skip 

case 
 when 1 , 
 2 ; 
 3 
 end

#~# EXPECTED

case
when 1,
     2
  3
end

#~# ORIGINAL skip 

case 
 when 1 , 2,  # comm
 
 3 
 end

#~# EXPECTED

case
when 1, 2,  # comm
     3
end

#~# ORIGINAL skip 

begin 
 case 
 when :x 
 # comment 
 2 
 end 
 end

#~# EXPECTED

begin
  case
  when :x
    # comment
    2
  end
end

#~# ORIGINAL skip 

case 1
 when *x , *y 
 2 
 end

#~# EXPECTED

case 1
when *x, *y
  2
end

#~# ORIGINAL skip 

case 1
when *x then 2
end

#~# EXPECTED

case 1
when *x then 2
end

#~# ORIGINAL skip 

case 1
when  2  then  3
end

#~# EXPECTED

case 1
when  2  then  3
end

#~# ORIGINAL skip 

case 1
when 2 then # comment
end

#~# EXPECTED

case 1
when 2 then # comment
end

#~# ORIGINAL skip 

case 1
 when 2 then 3
 else    
  4
end

#~# EXPECTED

case 1
when 2 then 3
else
  4
end
