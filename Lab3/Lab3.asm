#Created by: Phung, Isabella
#	     1702285
#	     November 9, 2022
#
#Assignment: Lab 3: Creating Loops in RARS
#	     CSE12: Comp Systems and Assembly language
#            UCSC, Fall 2022
#
#	     Program generates a hollow right triangle from a user-given height
#	     Triangle is printed to the console and is put in lab3_output.txt file.
#	     Program intended to run on RARS
#
#Registers:  a0, a1, a7, t6, and sp are restricted
#	     t0: user input
#	     t1: line counter
#	     t2: number of spaces to print inside the triangle
#	     t3: iterator to count number of stars to print for the final line


.macro exit #macro to exit program
	li a7, 10
	ecall
	.end_macro	

.macro print_str(%string1) #macro to print any string
	li a7,4 
	la a0, %string1
	ecall
	.end_macro
	
	
.macro read_n(%x)#macro to input integer n into register x
	li a7, 5
	ecall 		
	#a0 now contains user input
	addi %x, a0, 0
	.end_macro
	

.macro 	file_open_for_write_append(%str)
	la a0, %str
	li a1, 1
	li a7, 1024
	ecall
.end_macro
	
.macro  initialise_buffer_counter
	#buffer begins at location 0x10040000
	#location 0x10040000 to keep track of which address we store each character byte to 
	#actual buffer to store the characters begins at 0x10040008
	
	#initialize mem[0x10040000] to 0x10040008
	addi sp, sp, -16
	sd t0, 0(sp)
	sd t1, 8(sp)
	
	li t0, 0x10040000
	li t1, 0x10040008
	sd t1, 0(t0)
	
	ld t0, 0(sp)
	ld t1, 8(sp)
	addi sp, sp, 16
	.end_macro
	

.macro write_to_buffer(%char)
	
	
	addi sp, sp, -16
	sd t0, 0(sp)
	sd t4, 8(sp)
	
	
	li t0, 0x10040000
	ld t4, 0(t0)#t4 is starting address
	#t4 now points to location where we store the current %char byte
	
	#store character to file buffer
	li t0, %char
	sb t0, 0(t4)
	
	#update address location for next character to be stored in file buffer
	li t0, 0x10040000
	addi t4, t4, 1
	sd t4, 0(t0)
	
	ld t0, 0(sp)
	ld t4, 8(sp)
	addi sp, sp, 16
	.end_macro

.macro fileRead(%file_descriptor_register, %file_buffer_address)
#macro reads upto first 10,000 characters from file
	addi a0, %file_descriptor_register, 0
	li a1, %file_buffer_address
	li a2, 10000
	li a7, 63
	ecall
.end_macro 

.macro fileWrite(%file_descriptor_register, %file_buffer_address,%file_buffer_address_pointer)
#macro writes contents of file buffer to file
	addi a0, %file_descriptor_register, 0
	li a1, %file_buffer_address
	li a7, 64
	
	#a2 needs to contains number of bytes sent to file
	li a2, %file_buffer_address_pointer
	ld a2, 0(a2)
	sub a2, a2, a1
	
	ecall
.end_macro 

.macro print_file_contents(%ptr_register)
	li a7, 4
	addi a0, %ptr_register, 0
	ecall
	#entire file content is essentially stored as a string
.end_macro
	


.macro close_file(%file_descriptor_register)
	li a7, 57
	addi a0, %file_descriptor_register, 0
	ecall
.end_macro

.data
	prompt1: .asciz  "Enter n (must be greater than 0):"
	error_msg: .asciz "Invalid Entry!"
	outputMsg: .asciz  " display pattern saved to lab3_output.txt "
	newline: .asciz  "\n"  #this prints a newline
	star: .asciz "*"
	blackspace: .asciz " " 
	filename: .asciz "lab3_output.txt"


.text

	file_open_for_write_append(filename)
	#a0 now contaimns the file descriptor (i.e. ID no.)
	#save to t6 register
	addi t6, a0, 0
	
	initialise_buffer_counter
	
	#for utilsing macro write_to_buffer, here are tips:
	#0x2a is the ASCI code input for star(*)
	#0x20  is the ASCI code input for  blankspace
	#0x0a  is the ASCI code input for  newline (/n)

	
	#START WRITING YOUR CODE FROM THIS LINE ONWARDS
	#DO NOT use the registers a0, a1, a7, t6, sp anywhere in your code.
	
	#................ your code here..........................................................#
	
#prompts user for input
userPrompt:
	print_str(newline)
	print_str(prompt1)
	read_n(t0)		#uses macro to read user input into t0
	bgtz t0, continue	#checks t0 for invalid inputs
	print_str(error_msg)
	j userPrompt		#if invalid input, continually ask again

#begins with the tip of the star
continue:
	addi t1, t1, 1 		#set t1 to 1, this will be the line counter
	print_str(newline)
	print_str(star) 	#print star at tip
	write_to_buffer(0x2a)
	print_str(newline) 
	write_to_buffer(0x0a)
	
	beq t0, t1, write 	#if n = 1, end
	addi t1, t1, 1		#increments line counter
	
#prints the lines with spaces in between
lineLoop:
	bge t1, t0, printDone 	#are we at line n? if so, finish triangle
	print_str(star) 	#print first star of line
	write_to_buffer(0x2a)
				#t2 keeps track of the # of spaces to print
	add t2, t1, zero 	#put t1 in t2
	addi t2, t2, -2 	#subtract 2 from t2
#prints spaces inside triangle
printSpaces:
	blez t2 lineEnd		#if t2=0, end
	print_str(blackspace)	#print space
	write_to_buffer(0x20)
	addi t2, t2, -1		#decrement t2
	j printSpaces

#prints star at the end of the line
lineEnd:
	addi t1, t1, 1 		#add 1 to line counter t1
	print_str(star) 	#print star at end of line
	write_to_buffer(0x2a)
	print_str(newline)
	write_to_buffer(0x0a)
	j lineLoop

#last line to print of triangle
printDone:
	add t3, t0, zero	#initialize t3 with n
printStars:
	beq t3, zero, end	#if t3=0, tringle is finished
	print_str(star)		#print star
	write_to_buffer(0x2a)
	addi t3, t3, -1		#decrement t3
	j printStars

#for n != 1, /n needs to be added to end of file
end:
	print_str(newline)	
	write_to_buffer(0x0a)
#for n = 1, no /n is necessary so buffer is finished
write:
	
	
	#END YOUR CODE ABOVE THIS COMMENT
	#Don't cvhange anything below this comment!
	
	#write null character to end of file
	write_to_buffer(0x00)
	
	#write file buffer to file
	fileWrite(t6, 0x10040008,0x10040000)
	addi t5, a0, 0
	
	print_str(newline)
	print_str(outputMsg)
	
	exit
	
	
	

