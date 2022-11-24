maxIncome:
#Author of center code: Phung, Isabella
#			1702285
#			November 23, 2022
#finds the total income from the file
#arguments:	a0 contains the file record pointer array location (0x10040000 in our example) But your code MUST handle any address value
#		a1:the number of records in the file
#returns:	a0: heap memory pointer to actual  location of the record stock name in the file buffer

#Registers:
#t0 = stores a1 initially then decrements
#t1 = stores a0 initially, address cursor
#t2 = maximum value
#t3 = name of maximum stock

	#if empty file, return 0 for both a0, a1
	bnez a1, maxIncome_fileNotEmpty
	li a0, 0
	ret

 maxIncome_fileNotEmpty:
	add t0, a1, zero 	# # of loops to perform
	add t1, a0, zero 	#table address
	add t2, zero, zero 	#max = 0
	add t3, zero, zero 	#maxAddress=0
	addi t1, t1, 4
	maxLoop:
	beqz t0, maxFinish 	#if # of loops finished, go to done
	add a0, t1, zero 	#load address +4 into a0 for upcoming function
	
	#need to store values before function
	addi sp, sp, 20 	#order will be t3, ra, t0, t1, t2 <- sp
	sw t3, 16(sp)
	sw ra, 12(sp)
	sw t0, 8(sp)
	sw t1, 4(sp)
	sw t2, 0(sp)
	jal income_from_record 	#output value in a0
	#need to restore values
	lw t3, 16(sp)
	lw ra, 12(sp)
	lw t0, 8(sp)
	lw t1, 4(sp)
	lw t2, 0(sp)
	addi sp, sp, -20
	
	bgt a0, t2, maxFound	#if value retrieved is > current max, go to maxFound
	j skip
maxFound:
	add t2, zero, a0	#change current max value to new max value
	add t3, zero, t1
	addi t3, t3, -4		#store address of company name with max value
j skip
skip:
	
	
	addi t0, t0, -1 	#decrement number of loops to perform
	addi t1, t1, 8		#shift cursor to next number value
j maxLoop
	
maxFinish:
	add a0, t3, zero	#store final value in output
	
	ret
#######################end of maxIncome###############################################
