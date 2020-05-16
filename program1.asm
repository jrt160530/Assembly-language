	.data
varA: .word 9            				#variables initialized
varB: .word 9
varC: .word 9
var1: .word 9
var2: .word 9
var3: .word 9
userName: .space 20      				#buffer to hold input string.
msg1: .asciiz "Please enter your name: "
msg2: .asciiz "Please enter an integer 1-100: "
msg3: .asciiz "Your answers are.. "
	
	.text
main:
	la $a0, msg1			#prompts user to enter name
	li $v0, 4			#syscall 4 prints string
	syscall
	la $a0, userName		#loads address to receive input
	li $a1, 20			#sets size. must equal buffer
	li $v0, 8			#syscall 8 reads string
	syscall
	
	
	la $a0, msg2			#prompts user enter integer
	li $v0, 4			#syscall 4 prints string	
	syscall
	li $v0, 5			#syscall 5 reads integer
	syscall
	sw $v0, varA			#input stored in $v0, then store into varA
	
	la $a0, msg2
	li $v0, 4	
	syscall
	li $v0, 5
	syscall
	sw $v0, varB			#after syscall 4 and 5, store input to varB
	
	la $a0, msg2
	li $v0, 4	
	syscall
	li $v0, 5
	syscall
	sw $v0, varC			#after syscall 4 and 5, store input to varC
	
	lw $t1, varA			#move values into temp register 
	lw $t2, varB			#for arithmetic operations
	lw $t3, varC
	
	add $t0, $t1, $t2		#add a + b + c
	add $t0, $t0, $t3
	sw $t0, var1			#store answer to var1
	sub $t0, $t0, $t0		#subtract $t0 from itself to initialize to zero
	
	add $t0, $t3, $t2		#c + b - a
	sub $t0, $t0, $t1
	sw $t0, var2			#store answer to var2
	sub $t0, $t0, $t0		#set $t0 to 0
	
	addi $t1, $t1, 2		# (a + 2)
	addi $t2, $t2, -5		# (b - 5)
	addi $t3, $t3, -1		# (c - 1)
	
	add $t0, $t1, $t2		# (a+2) + (b-5) - (c-1)
	sub $t0, $t0, $t3
	sw $t0, var3			#store answer to var3
	
	la $a0, userName		#loads address of userName to $a0 for output
	li $v0, 4			#syscall 4 prints string
	syscall
	la $a0, msg3			#load address of result message
	syscall
	
	lw $a0, var1			#load value of var1 to $a0 for output
	li $v0, 1			#syscall 1 outputs integer
	syscall
	li $a0, 32			#loads integer 32 to $a0. 32 is ASCII code for space
	li $v0, 11			#syscall 11 prints character
	syscall
	
	lw $a0, var2			#load value of var2 for output
	li $v0, 1			#syscall 1 prints integer
	syscall	
	li $a0, 32			#prints space
	li $v0, 11
	syscall
	
	lw $a0, var3			#load  value of var3 for output
	li $v0, 1			#syscall 1 prints integer
	syscall
	li $a0, 32			#prints space
	li $v0, 11
	syscall
	
	
	
exit:	
	li $v0, 10			#sysall 10 terminates program
	syscall
	
	#example 1: a = 1 , b = 2 , c = 3
	#results expected: 6 4 -2
	
	#example 2: a = 5 , b = 3 , c = 9
	#results expected: 17 7 -3
	
	
