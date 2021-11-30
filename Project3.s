.data
	input: .space 1001
	output: .asciiz"\n"
	invalid: .asciiz "incorrect"
	comma: .asciiz ","

.text
	main:
   		li $v0, 8
   		la $a0, data #Getting User Input
   		li $a1, 1001
   		syscall
   		jal SubA

	count:
		j print
	SubA:

		sub $sp, $sp,4 #creates stack space
		sw $a0, 0($sp) #puts input in stack
		lw $t1, 0($sp) # stores the input into $t1
		addi $sp,$sp,4 # moves the stack pointer up
		move $t7, $t1 # stores beginning of input into $t7
	check1:

		li $t3,0 #Looking for tabs or spaces
		li $t0, -1 #used for invaild input
		lb $s0, ($t1) # loads the bit that $t0 is pointing to
		beq $s0, 0, insub# check for null
		beq $s0, 10, insub #checks for new line
		beq $s0, 44, inval #check for comma
		beq $s0, 9, next1 # checks for tabs character
		beq $s0, 32, next1 #checksc checks for space character
		move $t7, $t1 #stores first non-space/tab character
		j loop # starts loop over
	next1:
		addi $t1,$t1,1 #move $t1 to the next element
		j check1

	loop:


		lb $s0, ($t1) # loads the bit that $t0 is pointing to
		beq $s0, 0,next2# check for null
		beq $s0, 10, next2 #checks for new line
		addi $t1,$t1,1 #move the $t1 to the next element
		beq $s0, 44, substring #check if bit is a comma
	check2:
		bgt $t3,0, inval #checks to see if I have spaces or tabs between my valid characters:
		beq $s0, 9,  space #checks for tab characters
		beq $s0, 32, space #checks for  space character
		ble $s0, 47, inval # checks for ascii less than 48
		ble $s0, 57, valid # checks for integers
		ble $s0, 64, inval # checksfor ascii less than 64
		ble $s0, 87, valid    # checks for my capital letters
		ble $s0, 96, inval # checks for ascii less than 96
		ble $s0, 119, valid     # checks for lowercase letters
		bge $s0, 120, inval # checks for ascii greater than 120



