
	program Random
        
        double precision array(40)
        double precision M1,M2,M3,Mhd,Mhu,tanb,mu,signmu
	double precision msqii,mslii,msuii,msdii,mseii
        double precision msq33,msl33,msu33,msd33,mse33
	double precision Te33,Tu33,Td33,Yu33
        integer count, N

        open(1,file="/home/mtalia/finetuning/" //
     +    "SPheno_0/randominputgenerator/random_MSSM.dat")

        N=100000

        call IniRandom(N,40)

        do count = 1,N

        call GetRandom(array)

        M1 = 3000*array(6)
        M2 = 3000*array(35)
        M3 = 1500*array(29)+500
        Mhd = (40000**2)*array(29)+(3163**2)
        Mhu = -(3163**2)*array(27)
        msqii = (3000**2)*array(38)
        mslii = (3000**2)*array(28)
        msuii = (3000**2)*array(30)
        msdii = (3000**2)*array(40)
        mseii = (3000**2)*array(1)
        msq33 = -2*(1000**2)*array(31) + (1000**2)
        msl33 = (3000**2)*array(4)
        msu33 = -2*(1000**2)*array(30) + (1000**2)
        msd33 = (3000**2)*array(29)
        mse33 = (3000**2)*array(17)
        Te33 = -6000*array(1)+3000
        Tu33 = 3000*array(20)
        Td33 = -6000*array(11)+3000
        tanb = 4*array(3) + 1
        mu = -2*array(37) + 1
        signmu = mu/Abs(mu)

        write(1,*) M1, M2, M3, Mhd, Mhu, 
     &    msqii, mslii, msuii, msdii, mseii,
     &    msq33, msl33, msu33, msd33, mse33,
     &    Te33, Tu33, Td33, tanb, signmu

	enddo

        close(1)

	end


************************************************************************
** IniRandom sets up the random-number generator to produce a Sobol
** sequence of at most max dims-dimensional quasi-random vectors.
** Adapted from ACM TOMS algorithm 659, see
** http://www.acm.org/pubs/citations/journals/toms/1988-14-1/p88-bratley

	subroutine IniRandom(max, dims)
	implicit none
	integer max, dims

	integer v(40, 30), lastq(40)
	integer ndim, count, norm
	common /rngdata/ v, lastq, ndim, count, norm

	integer bits, powers, degree, newv, dim, bit, deg, j

	integer poly(2:40), vinit(2:40, 1:8)
	save poly, vinit

	data poly / 3, 7, 11, 13, 19, 25, 37, 59, 47,
     &    61, 55, 41, 67, 97, 91, 109, 103, 115, 131,
     &    193, 137, 145, 143, 241, 157, 185, 167, 229, 171,
     &    213, 191, 253, 203, 211, 239, 247, 285, 369, 299 /

	data (vinit(dim, 1), dim = 2, 40) / 39*1 /
	data (vinit(dim, 2), dim = 3, 40) /
     &          1, 3, 1, 3, 1, 3, 3, 1,
     &    3, 1, 3, 1, 3, 1, 1, 3, 1, 3,
     &    1, 3, 1, 3, 3, 1, 3, 1, 3, 1,
     &    3, 1, 1, 3, 1, 3, 1, 3, 1, 3 /
	data (vinit(dim, 3), dim = 4, 40) /
     &             7, 5, 1, 3, 3, 7, 5,
     &    5, 7, 7, 1, 3, 3, 7, 5, 1, 1,
     &    5, 3, 3, 1, 7, 5, 1, 3, 3, 7,
     &    5, 1, 1, 5, 7, 7, 5, 1, 3, 3 /
	data (vinit(dim, 4), dim = 6, 40) /
     &                  1, 7, 9, 13, 11,
     &    1, 3, 7, 9, 5, 13, 13, 11, 3, 15,
     &    5, 3, 15, 7, 9, 13, 9, 1, 11, 7,
     &    5, 15, 1, 15, 11, 5, 3, 1, 7, 9 /
	data (vinit(dim, 5), dim = 8, 40) /
     &                            9, 3, 27,
     &    15, 29, 21, 23, 19, 11, 25, 7, 13, 17,
     &    1, 25, 29, 3, 31, 11, 5, 23, 27, 19,
     &    21, 5, 1, 17, 13, 7, 15, 9, 31, 9 /
	data (vinit(dim, 6), dim = 14, 40) /
     &            37, 33, 7, 5, 11, 39, 63,
     &    27, 17, 15, 23, 29, 3, 21, 13, 31, 25,
     &    9, 49, 33, 19, 29, 11, 19, 27, 15, 25 /
	data (vinit(dim, 7), dim = 20, 40) /
     &                                  13,
     &    33, 115, 41, 79, 17, 29, 119, 75, 73, 105,
     &    7, 59, 65, 21, 3, 113, 61, 89, 45, 107 /
	data (vinit(dim, 8), dim = 38, 40) / 7, 23, 39 /

	j = max
	bits = 0
	do while( j .ne. 0 )
	  bits = bits + 1
	  j = ishft(j, -1)
	enddo

	do bit = 1, bits
	  v(1, bit) = 1
	enddo

	do dim = 2, dims
	  powers = poly(dim)

	  j = powers
	  degree = -1
	  do while( j .ne. 0 )
	    degree = degree + 1
	    j = ishft(j, -1)
	  enddo

	  do bit = 1, degree
	    v(dim, bit) = vinit(dim, bit)
	  enddo

	  do bit = degree + 1, bits
	    newv = v(dim, bit - degree)
	    j = powers
	    do deg = degree, 1, -1
	      if( btest(j, 0) )
     &          newv = ieor(newv, ishft(v(dim, bit - deg), deg))
	      j = ishft(j, -1)
	    enddo
	    v(dim, bit) = newv
	  enddo
	enddo

	do bit = 1, bits - 1
	  do dim = 1, dims
	    v(dim, bit) = ishft(v(dim, bit), bits - bit)
	  enddo
	enddo
	norm = ishft(1, bits)

	count = 0
	ndim = dims
	do dim = 1, dims
	  lastq(dim) = 0
	enddo
	end


************************************************************************
** GetRandom generates a vector of random numbers

	subroutine GetRandom(array)
	implicit none
	double precision array(*)

	integer v(40, 30), lastq(40)
	integer ndim, count, norm
	common /rngdata/ v, lastq, ndim, count, norm

	integer c, zerobit, dim

	c = count
	zerobit = 1
	do while( btest(c, 0) )
	  zerobit = zerobit + 1
	  c = ishft(c, -1)
	enddo

	do dim = 1, ndim
	  lastq(dim) = ieor(lastq(dim), v(dim, zerobit))
	  array(dim) = dble(lastq(dim))/norm
	enddo

	count = count + 1
	end

