program FRANK
real p, t
real maths
integer ps(10), ts(10)

ps=(/1, 2, 3, 5, 8, 13, 21, 24, 45, 69 /)
ts(1)=44

! sub to do the maths.
! T1 = a
! P1 = b
! P2 = c
! (T2 = d)
subroutine maths(a,b,c,d)
	real a,b,c,d
	d=a(c/b)
	! obv. use the right maths here.
	return
end

! Iterate through the ps array, and calculate the Ts
do 10 count = 0, 10, 1
	call maths(ts(i), p(i), p(i-1))
	ts(i+1)=d
10 continue

do 20 count = 0, 10, 1
	print *, ps(i)
20 continue

end program
