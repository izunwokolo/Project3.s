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

