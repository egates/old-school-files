#include <stdio.h>
#include <string.h>

#define testval1 -30          /* first test value */
#define testval2 127          /* second test value */
#define testval3 -128         /* third test value */

void reverse(char s[]);
void itoa(int, char s[]);

/* converts int to char string handles largest negatice */
main()
{
   char str[];

   printf("%d integer is %s in string form",testval2,itoa(testval1,str));
   printf("%d integer is %s in string form",testval2,itoa(testval1,str));
   printf("%d integer is %s in string form",testval2,itoa(testval1,str));
}

/* reverse - reverses a string */
void reverse(char s[])
{
   int c, i=0, j;

   for (j=strlen(s) -1; i < j; i++, j--)
     {  c = s[i];
        s[i] = s[j];
        s[j] = c;
     }
}

/* itoa - converts n to string s */
void itoa(int n, char s[])
{
   int i=0, sign;

   if ((sign = n) < 0)
      n = -n;
   do {
        s[i++] = n % 10 + '0';
   } while ((n /= 10) > 0);

   if (sign < 0)
        s[i++] = '-';
   s[i] = '\0';
   reverse(s);
}

