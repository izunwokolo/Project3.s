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


