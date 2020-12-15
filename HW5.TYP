cat typescripts 
Script started on Tue Jul 10 21:59:46 1990
ra% gcc -o pointer1 pointer1.c
ra% 
ra% 
ra% 
ra% pointer1
external ptr: 0x0	external var: 0.000000e+00
local ptr:    0x0	local var     1.856322e-310

external ptr: 0x23120	external var: 1.000000e+01
local ptr:    0xefffbc4	local var     2.000000e+01

external ptr: 0x23120	external var: 1.100000e+01
local ptr:    0x23120	local var     3.000000e+01

ra% 
ra% 
ra% cat pointer1.c
/* Eric Gates - HW 1 part 1 - cs240 - 7/8/90 */
#include <stdio.h>

double *ep;            /* external pointer */
double ex;             /* external variable */
void printval(double *, double, double *, double);
		    /* function to print values */

/* prints garbage values of vars and ptrs then prints values after assign */
main()
{
    double *lp;        /* local pointer */
    double lx;         /* local variable */

    printval(ep,ex,lp,lx);
    ex = 10;
    lx = 20;
    ep = &ex;
    lp = &lx;
    printval(ep,ex,lp,lx);
    *lp = 30;
    lp = &ex;
    (*lp)++;
    printval(ep,ex,lp,lx);
}

/* printval - prints the values for this program */
void printval(double *ep, double ex, double *lp, double lx) 
{
    printf("external ptr: 0x%x\texternal var: %e\n",ep,ex);
    printf("local ptr:    0x%x\tlocal var     %e\n",lp,lx);
    printf("\n");
}     

ra% 
ra% 
ra% 
ra% ll
total 63
drwxr-xr-x  2 egates        512 Jul 10 22:00 ./
drwxrwx---  8 egates        512 Jul  8 23:09 ../
-rwxr-xr-x  1 egates      28961 Jul 10 20:47 a.out*
-rw-r--r--  1 egates       1025 Jul 10 21:59 meminfo.doc
-rwxr-xr-x  1 egates      27643 Jul 10 22:00 pointer1*
-rw-r--r--  1 egates        864 Jul  9 22:09 pointer1.c
-rw-r--r--  1 egates       1865 Jul 10 20:47 testptr.c
-rw-r--r--  1 egates          0 Jul 10 21:59 typescript
ra% 
ra% 
ra% 
ra% 
ra% cat meminfo.doc
code:
   main  : (0x21f8) = main()
   subr  : (0x2328) = subr()
   printf: (0x2590) = printf()

data segment
   a     : (0x20034) = 1 in subr0
   b     : (0x20038) = 20 in subr0
   scount: (0x2003c) = 1 in subr0
   c     : (0x2312c) = 0 in subr0

   a     : (0x20034) = 1 in subr1
   b     : (0x20038) = 20 in subr1
   scount: (0x2003c) = 2 in subr1
   c     : (0x2312c) = 0 in subr1

stack

   lcount: (0xefffb7c) = 1 in subr1
   t     : (0xefffb88) = 0 in subr1
   lcount: (0xefffb8c) = 10 in subr0
   t     : (0xefffb98) = 3 in subr0
   dp    : (0xefffb9e)  in main
   d     : (0xefffba2) = 0.3333333333333 in main
   x     : (0xefffbaa) = 3 in main
   p     : (0xefffbac)  in main



Memory Map of these items

           code               data segment                        stack
0      |-----------|         |------------|                  |<<<----------|
|-----------------------------------------------------------------------------|
    0x21f8       0x2590    0x20034      0x23126           0xefffb7c   0xefffbac

ra% exit
ra% 
script done on Tue Jul 10 22:00:54 1990

script done on Tue Jul 10 22:00:54 1990
ra% logout

Xyplex -011- Session 1 disconnected from RA.UMB.EDU

Server> logout

Xyplex -020- Logged out port 2 at 10 Jul 1990  22:02:08
NO CARRIER
