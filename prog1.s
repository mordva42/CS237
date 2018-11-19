* Programmer:		Marina Pestriacheva
* Class Account:	cs237 - 01
* Assignment or Title:  Assignment #1
* Filename: 		prog1.s
* Date completed: 	10/19/2018
*----------------------------------------------------------------------
* Problem statement:		User enters date in the form MM/DD/YYYY and the program outputs "The date enetred is XXXX dd,yyyy"
* Input: 			MM/DD/YYYY
* Output:  			The date is XXXX dd,yyyy
* Error conditions tested:      None
* Included files:               None
* Method and/or pseudocode: 	Using parallel arrays in order to retrive information about month 
* References: 			None
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
* D1 for number of chrecters to be skipped to get to the month we need in the array 
* D2 for the value of of the day entered in 2s comp
* D3 for the length of the month user entered
* D4 for the length of the month to skip for our answer
* A1 for the address when we put month in date to print it out as an aswer later
* A2 for the address when we finding the length of the month 
* A3 for the address when puting date and year in the answer
*----------------------------------------------------------------------
*
start:  initIO               * Initialize (required for I/O)
	setEVT	             * Error handling routines
*	initF	             * For floating point macros only	

	lineout one	     	
	lineout ques 
	linein  buff	     *input now is in buff
	
	cvta2	buff,#2      *convert first 2 bytes of buff ASCII in 2's comp and store in D0
	move.l	D0,D1        *move value(month) to D1 to store it there
	sub.l   #1,D1        *substact 1 because array starts with 0
	move.l  D1,D4        *now we have value of month in D4 in 2's comp
	muls    #11,D1       *multiply by 11(number of charecters in 1 elemet of array).D1 now has # of char to skip to get to the month that user entered
	lea     month,A1     *moving adress of the array(months) to A1 to increment it in the future
	adda    D1,A1        *A1 now points to the month user entred
	
	cvta2   buff+3,#2    *converts day in 2 complements and puts it in D0      
	move.l  D0,D2        *D2 has 2s compliment value of thr day entered
	

	
	lea	len,A2       *loads adress of len into A2(A2 points to the array with #s of char in month
	muls	#4,D4        *we have month in D4 we multiply it by 4 to get to the array elemt of how long month is
	adda	D4,A2        *we add this amount to A2 so now it points to length of the month
	move.l	(A2),D3	     *D3 is the length of the month
	

	
	move.b	(A1),date        *moving the month to date charecter by char
	move.b	1(A1),date+1     *date in after answer in memory so it will print our date after printing answer
	move.b	2(A1),date+2
	move.b	3(A1),date+3
	move.b	4(A1),date+4
	move.b	5(A1),date+5
	move.b	6(A1),date+6
	move.b	7(A1),date+7
	move.b	8(A1),date+8
	move.b	9(A1),date+9
	move.b	10(A1),date+10
	move.b	11(A1),date+11
	
	
	lea	date,A3
	adda	D3,A3             *A3 now points to end of the month (D3 has # of char in the month entered)
	
	move.b	#' ',(A3)+ 	  *adds space after month and post-increments our pointer A3 by one
	move.l  D2,D0             *move day to D0 to further convert to ascii
	cvt2a   (A3),#2           *gets day from D0 converts to ascii and stores where A3 points
	stripp	(A3),#2           *stripps (A3) and stores number of bytes that is needed to be skipped after stipp in D0
	adda	D0,A3             *now A3 points to the end of the day
	move.b  #',',(A3)+
	move.b  #' ',(A3)+
	
	cvta2	buff+6,#4         *gets the year and stores in D0 in 2s comp
	cvt2a   (A3),#4           *gets day from D0 converts to ascii and stores in (A3) our A3 was poiting after day, 
	stripp	(A3),#4           *strips (A3)stores number of bytes that is needed to be skipped after stipp in D0
	adda	D0,A3             *now A3 points to the end of the day
	
	clr.b	(A3)              *adds null terminator in the end
	
	
	
	
	lineout    answer
	
	 
	
	
 


        break                   * Terminate execution
*
*----------------------------------------------------------------------
*       Storage declarations

buff:   ds.b	80
one:    dc.b	'Program 1, Marina Pestriacheva, cssc0943',0
ques:	dc.b 	'Please enter toady date is the form MM/DD/YYYY:',0	
month:	dc.b	'January',0,0,0,0
        dc.b	'February',0,0,0
	dc.b	'March',0,0,0,0,0,0
	dc.b	'April',0,0,0,0,0,0
	dc.b	'May',0,0,0,0,0,0,0,0
	dc.b	'June',0,0,0,0,0,0,0
	dc.b	'July',0,0,0,0,0,0,0
	dc.b	'August',0,0,0,0,0
	dc.b	'September',0,0
	dc.b	'October',0,0,0,0
	dc.b	'November',0,0,0
	dc.b	'December',0,0,0
len:	dc.l	7
	dc.l	8
	dc.l	5
	dc.l	5
	dc.l	3
	dc.l	4
	dc.l	4
	dc.l	6
	dc.l	9
	dc.l    7
	dc.l	8
	dc.l	8
	
	
	
	
	
answer: dc.b    'The date entered is '
date:   ds.b    80
		
				
        end
