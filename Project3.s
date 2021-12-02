.data
	input: .space 1001
	output: .asciiz"\n"
	invalid: .asciiz "-"
	comma: .asciiz ","

.text
	main:
   		li $v0, 8
   		la $a0, data				#Getting User Input
   		li $a1, 1001
   		syscall
   		jal SubA

	count:
		j print
	SubA:

		sub $sp, $sp,4 				#creates stack space
		sw $a0, 0($sp) 				#puts input in stack
		lw $t1, 0($sp) 				# stores the input into $t1
		addi $sp,$sp,4 				# moves the stack pointer up
		move $t7, $t1 				# stores beginning of input into $t7
	check1:

		li $t3,0 				#Looking for tabs or spaces
		li $t0, -1 				#used for invaild input
		lb $s0, ($t1) 				# loads the bit that $t0 is pointing to
		beq $s0, 0, insub			# check for null
		beq $s0, 10, insub 			#checks for new line
		beq $s0, 44, inval 			#check for comma
		beq $s0, 9, next1 			# checks for tabs character
		beq $s0, 32, next1 			#checksc checks for space character
		move $t7, $t1 				#stores first non-space/tab character
		j loop # starts loop over
	next1:
		addi $t1,$t1,1 				#move $t1 to the next element
		j check1

	loop:


		lb $s0, ($t1) 				# loads the bit that $t0 is pointing to
		beq $s0, 0,next2			# check for null
		beq $s0, 10, next2 			#checks for new line
		addi $t1,$t1,1 				#move the $t1 to the next element
		beq $s0, 44, substring 			#check if bit is a comma
	check2:
		bgt $t3,0, inval 			#checks to see if I have spaces or tabs between my valid characters:
		beq $s0, 9,  space 			#checks for tab characters
		beq $s0, 32, space 			#checks for  space character
		ble $s0, 47, inval 			# checks for ascii less than 48
		ble $s0, 57, valid 			# checks for integers
		ble $s0, 64, inval 			# checksfor ascii less than 64
		ble $s0, 87, valid    			# checks for my capital letters
		ble $s0, 96, inval 			# checks for ascii less than 96
		ble $s0, 119, valid     		# checks for lowercase letters
		bge $s0, 120, inval 			# checks for ascii greater than 120
	space:

		addi $t3,$t3,-1 			#tracking spaces/tabs
		j loop

	valid:

		addi $t4, $t4,1 			#tracking valid characters
		mul $t3,$t3,$t0 			#if there was a space before a valid character it will change $t3 to a positive number
		j loop 					#jumps to the beginning of loop

	inval:

		lb $s0, ($t1) 				# loads the bit that $t1 is pointing to
		beq $s0, 0, insub
		beq $s0, 10, insub
		addi $t1,$t1,1
		beq $s0, 44, insub
		j inval 				#jumps to the beginning of loop
	insub:

		addi $t2,$t2,1 				#amount of substring
		sub $sp, $sp,4				# creating space in stack
		sw $t0, 0($sp) 				#puts $t7 into the stack
		move $t7,$t1  				# store the pointer to the bit after the comma
		lb $s0, ($t1) 				# loads the bit that $t1 is -> to
		beq $s0, 0, count 
		beq $s0, 10, count
		beq $s0,44, inval
		li $t4,0 				#resets the amount of valid characters to 0
		li $t3,0				#resets my space checker  to 0
		j check1
	substring:
		mul $t3,$t3,$t0 			#if hay space before valid character $t3 is a positive number

	next2:
		bgt $t3,0,insub 			#checks for spaces or tabs in between valid characters
		bge $t4,5,insub 			#checks for  more than 4 for characters
		addi $t2,$t2,1 				# track of the amount substring
		sub $sp, $sp,4 				# creates space in  stack
		sw $t7, 0($sp) 				#stores $t7 into the stack
		move $t7,$t1  				# storing pointer
		lw $t5,0($sp) 				#load stack at that posistion to $t5
		li $s1,0 				#sets $s1 to 0
		jal SubB
		lb $s0, ($t1) 				# loads the bit that $t0 is pointing to
		beq $s0, 0, count 			# check if the bit is null
		beq $s0, 10, count 			#checks if the bit is a new line
		beq $s0,44, inval 			#checks if the next bit is a comma
		li $t3,0 				#resets my space/tabs checker back to zero
		j check1
	SubB:
		beq $t4,0,stop 				#check how many charcter are left to convert
		addi $t4,$t4,-1 			#decreases char to conert count
		lb $s0, ($t5) 				# loads bit to convert
		addi $t5,$t5,1    			# increments element in array
		j SubC

	continue:
		sw $s1,0($sp)   		 	#stores the converted number
		j SubB
	SubC:
		move $t9, $t4    			#stores the amount of characters as an exponent
		li $t8, 1    				# $t8 represents 33 to a certian power and set equal to 1
		ble $s0, 57, num			#sorts the bit to the apporiate function
		ble $s0, 88, u_c
		ble $s0, 120, l_c

	num:
		sub $s0, $s0, 48    			#converts interger
		beq $t4, 0, concatenate    		# if no hay chars exponent is zero
		li $t8, 33
		j exponent
	u_c:
		sub $s0, $s0, 55    			#converts uppercase
		beq $t4, 0, concatenate    		# if no hay chars exponent is zero
		li $t8, 33
		j exponent

	l_c:
		sub $s0, $s0, 87    			#converts lowercase
		beq $t4, 0, concatenate    		# if no hay chars exponent is zero
		li $t8, 33
		j exponent
	exponent:

		#raise my base to an exponent by multiplying it by itself
		
		ble $t9, 1, concatenate    		#if exp  is 1 dont multiply by itself
		mul $t8, $t8, 33     			# multpling my base by itself
		addi $t9, $t9, -1    			# decrement the exponent
		j exponent

	concatenate:
		mul $s2, $t8, $s0    			#multiplied the converted value and my raised base

		add $s1,$s1,$s2        			# adding the numbers
		j continue

	stop:

		jr $ra 					#goes back to substring
	print:
		mul $t2,$t2,4 				#getting space to move stack pointer
		add $sp, $sp $t2 			#pointer is at the beginning of the stack

	endloop:

		sub $t2, $t2,4    			#keeping track of elements left
		sub $sp,$sp,4 				#moving the stack pointer to the next element
		lw $s7, 0($sp)    			#storing that element into $s7
		beq $s7,-1,print_NAN 			#checks to see if element is invalid

		li $v0, 1
		lw $a0, 0($sp) 				#prints element
		syscall

	commas:
		beq $t2, 0, end 			#ends program if there arent other values.
		li $v0, 4
		la $a0, comma 				#prints comma
		syscall
		j endloop


