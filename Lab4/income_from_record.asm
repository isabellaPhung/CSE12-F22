income_from_record:
#Author of center code: Phung, Isabella
#			1702285
#			November 23, 2022
#function to return numerical income from a specific record
#e.g. for record "Microsoft,34\r\n", income to return is 34(for which name is Microsoft)

#arguments:	a0 contains pointer to start of numerical income in record 
#returns: 	income numerical value of the asci income in a0 (34 in our example)

#Registers:
#t0 = address of ascii numbers directly from table
#t1 = ascii number
#t2 = constant for checking end of line
#t3 = mulitplication of t1*t4
#t4 = holds current 10^n value
#t5 = sum of value
#t6 = stores constant of 10

	lwu t0, 0(a0) 		#load address of number from table
	lbu t1, 0(t0)		#load ascii numbers into t1
	addi t2, zero, 0xd 	#for checking if end of line
toEndOfLine:
	beq t1, t2, endOfLine 	#is t1 = end of line?
	
	#add a0, zero, t1 	#print current char
	#li a7, 11
	#ecall
	
	addi t0, t0, 1 		#shift address of char down
	lbu t1, 0(t0) 		#load char into t1
j toEndOfLine
	
endOfLine: 
	#now gong to work back up memory starting from the ones place
	addi t2, zero, 0x2c	#stores ascii value for comma
	addi t4, zero, 1 	#t4 = 1, exponential factor of 10
	addi t6, zero, 10 	#just to store constant
	add t5, zero, zero
backUp:
	addi t0, t0, -1 	#shift t0 up one char
	lbu t1, 0(t0) 		#load char into t1
	beq t1, t2, done 	#if char is comma, exit
	addi t1, t1, -48 	#convert from ascii to integer
	
	#add a0, zero, t1 	#print current num
	#li a7, 1
	#ecall
	
	mul t3, t1, t4
	
	add t5, t5, t3
	
	#add a0, zero, t5 	#print current sum
	#li a7, 1
	#ecall
	
	mul t4, t4, t6

j backUp

done:
	add a0, zero, t5
	
	ret
#######################end of income_from_record###############################################	
