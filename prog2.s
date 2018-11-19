* Programmer: 			Marina Pestriacheva
* Class Account: 		cs237 - 01
* Assignment or Title:	 	Assignment #2
* Filename: 			prog2.s
* Date completed:  		11/15/2018
*----------------------------------------------------------------------
* Problem statement:		To detrmine if an input number is prime	
* Input: 			A number 3 to 5 charecters in legth 
* Output: 			'The number XXXX is/isn't a prime.'
* Error conditions tested: 	valid length and valid charecters(only digits)
* Included files: 		None
* Method and/or pseudocode: 	Using branching to test for the conditions and to create a loop that divides until it finds a divider or decides that the unput number is a prime number
* References: 			Riggins, CS237 Machine Organization & Assembly Language Programming, Supplementary Material. 
*----------------------------------------------------------------------
*
        ORG     $0
        DC.L    $3000           * Stack pointer value after a reset
        DC.L    start           * Program counter value after a reset
        ORG     $3000           * Start at location 3000 Hex
*
*----------------------------------------------------------------------
*
#minclude /home/cs/faculty/cs237/bsvc/macros/iomacs.s
#minclude /home/cs/faculty/cs237/bsvc/macros/evtmacs.s
*
*----------------------------------------------------------------------
*
* Register use
*D0-for buff size, and for the input when using cvt2a
*D1-length of the input
*D2-the input in 2s comp
*D3-divisor of the input
*D4-quotient and remainder
*D6-length of number wihtout leading zeros
*A0-to put null in the end of the buff
*A2-address of the buff and for the output
*A4-for the input number in ascii without leading zeros
*A5-for the last part of the output
*----------------------------------------------------------------------
*
start:  initIO                  * Initialize (required for I/O)
	setEVT			* Error handling routines
*	initF			* For floating point macros only	
	
	lineout	me
prompt:	lineout	ques
	linein	buff
	
	*put null terminator in the end of buff
	lea	buff,A0		
	adda.l	D0,A0
	clr.b	(A0)		*A0 points to the end of the buff where it is null
			
	
	
	move.l	D0,D1		*D1 has length of input
	lea	buff,A2		*A2 now has addresss of buff
	

	
	*check for valid length
	cmpi.l	#3,D1
	blt	bad
	cmpi.l	#5,D1
	ble	check		*length is good go to check for valid char
bad:	
	lineout	badl1	
	bra	prompt

	
	*check for valid charecters
check:	
	cmpi.b	#0,(A2)
	beq	algood	
	
	cmpi.b	#'0',(A2)
	blt	bad2
	cmpi.b	#'9',(A2)
	ble	good2
	
	
	
	
	
	
bad2:	lineout badch
	bra	prompt
	
good2: 
	adda.l	#1,A2
	bra	check
	
algood:	
	cvta2	buff,D1
	move.l	D0,D2		*D2 now has the number in 2s comp
	move.l	#2,D3		*D3 now is 2 we will start by dividing by 2 and then incrementing
	
	
	move.l	D2,D0		*movin the num to D0 to use cvt2a 
	lea	buff,A4
	cvt2a	(A4),#5		*A4 points to the num in ascii
	stripp	(A4),#5
	move.l	D0,D6		*D6 now has legth of the num w/o leading zeros
	
	lea	num,A2
	adda.l	#11,A2		*A2 points to the end of "the number "<== 11 char
	move.b	(A4),(A2)+
	move.b	1(A4),(A2)+
	move.b	2(A4),(A2)+
	move.b	3(A4),(A2)+
	move.b	4(A4),(A2)+
	
	
	
check2:	
	cmp.l	D2,D3		*use D3 for the divider 
	bge	nodiv		*if D3 became the num, meaning number has no divider
	move.l	D2,D4		*put the num in D4 so we can divide without losing it
	divs	D3,D4		*D4 now has remiender and quotient 
	swap	D4		*put reminder in a word part of the D4
	cmpi.w	#0,D4		
	beq	yesdiv
	addi.l	#1,D3
	bra	check2
	
nodiv:  
	lea	num,A2
	
	adda.l	#11,A2
	adda.l	D6,A2		*D6 has length of the num
	lea	nodi,A5		*A5 points to is a prime
	move.b	(A5),(A2)+
	move.b	1(A5),(A2)+
	move.b	2(A5),(A2)+
	move.b	3(A5),(A2)+
	move.b	4(A5),(A2)+
	move.b	5(A5),(A2)+
	move.b	6(A5),(A2)+
	move.b	7(A5),(A2)+
	move.b	8(A5),(A2)+
	move.b	9(A5),(A2)+
	move.b	10(A5),(A2)+
	
	
	
	
	lineout num
	bra	exit

yesdiv:	

	lea	num,A2
	adda.l	#11,A2
	adda.l	D6,A2
	lea	yesdi,A5
	move.b	(A5),(A2)+
	move.b	1(A5),(A2)+
	move.b	2(A5),(A2)+
	move.b	3(A5),(A2)+
	move.b	4(A5),(A2)+
	move.b	5(A5),(A2)+
	move.b	6(A5),(A2)+
	move.b	7(A5),(A2)+
	move.b	8(A5),(A2)+
	move.b	9(A5),(A2)+
	move.b	10(A5),(A2)+
	move.b	11(A5),(A2)+
	move.b	12(A5),(A2)+
	move.b	13(A5),(A2)+
	move.b	14(A5),(A2)+
	

	
	lineout	num	
	

	
exit:					


        break                   * Terminate execution
*
*----------------------------------------------------------------------
*       Storage declarations
buff:	ds.b	80
me:	dc.b	'Program #2, Marina Pestriacheva, cssc0943',0
ques:	dc.b	'Enter a 3-5 digit number:',0
badl1:	dc.b	'Incorrect input length.',0
badch:	dc.b	'Not a number.',0
good:	dc.b	'Length is good',0
goo:	dc.b	'All Good',0
nodi:	dc.b	' is prime.',0
yesdi:	dc.b	' is not prime.',0

num:	dc.b	'The number '
ber:	ds.b	80
				
        end
