totalIncome:
#Author of center code: Phung, Isabella
#			1702285
#			November 23, 2022
#finds the total income from the file
#arguments:	a0 contains the file record pointer array location (0x10040000 in our example) But your code MUST handle any address value
#		a1:the number of records in the file
#returns:	a0:the total income (add up all the record incomes)

#Regsiters:
#t0 = stores a1 initially then decrements
#t1 = address cursor, stores a0 initially
#t2 = sum

	#if empty file, return 0 for  a0
	bnez a1, totalIncome_fileNotEmpty
	li a0, 0
	ret

totalIncome_fileNotEmpty:
	add t0, a1, zero 	# # of loops to perform
	add t1, a0, zero 	#table address
	add t2, zero, zero 	#sum = 0
	addi t1, t1, 4		#shift value by 4 bits to get to number value
loop:
	beqz t0, finish 	#if # of loops finished, go to done
	add a0, t1, zero 	#load address +4 into a0 for upcoming function
	
	#need to store values before function
	addi sp, sp, 16 	#order will be ra, t0, t1, t2 <- sp
	sw ra, 12(sp)
	sw t0, 8(sp)
	sw t1, 4(sp)
	sw t2, 0(sp)
	jal income_from_record 	#output value in a0
	#need to restore values
	lw ra, 12(sp)
	lw t0, 8(sp)
	lw t1, 4(sp)
	lw t2, 0(sp)
	addi sp, sp, -16
	
	add t2, t2, a0		#add value from income_from_record to sum value t2
	addi t0, t0, -1 	#decrement number of loops to perform
	addi t1, t1, 8		#move t1 cursor value by 8 bytes
j loop
	
finish:
	add a0, t2, zero	#store final value in output

	ret
#######################end of nameOfMaxIncome_totalIncome###############################################
