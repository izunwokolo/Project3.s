.data

   data: .space 1001
  answer: .asciiz"\n"
  invalid: .asciiz "Invalid"
  comma: .asciiz ","

.text
  main:
   li $v0, 8
   la $a0, data #Getting User Input
   li $a1, 1001
   syscall

