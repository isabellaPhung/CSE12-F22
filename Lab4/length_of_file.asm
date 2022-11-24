length_of_file:
#Author of center code: Phung, Isabella
#			1702285
#			November 23, 2022
#function to find length of data read from csv file
#arguments: a1=bufferAddress holding file data
#returns: file length in a0

#Registers:
#t0 = cursor, shifted up and down as needed
#t1 = char at t0
#t2 = size
	
	add t0, a1, zero 		#load starting address in t0
	lb t1, 0(t0) 			# load char at address into t1
	add t2, zero, zero 		#t2 = size = 0
throughFile:
	beqz t1, endOfFile 		#is char 0?
	addi t2, t2, 1 			# +1 byte
	lb t1, 0(t0) 			# load char at address into t1

	#add a0, zero, t1 		#print current char
	#li a7, 11
	#ecall

	#add a0, zero, t2 		#print current size
	#li a7, 1
	#ecall

	addi t0, t0, 1 #shift cursor down a char
	j throughFile
endOfFile:
	addi a0, t2, -1
	
	ret
#######################end of length_of_file###############################################	
