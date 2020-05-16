.data
buffer: .space 30				#buffer to hold input string
msg1: .asciiz "Please enter a string." 	#a asciiz variable to prompt user to enter string	
msgWord: .asciiz " word(s) "			#used to output results
msgChar: .asciiz " character(s) "		#used to output results
msgCancel: .asciiz "Cancel was choosen"	
msgNoString: .asciiz "No string was entered" 
wordCount: .word 0					#stores word count
charCount: .word 0					#stores character count

	.text
main:
	la $a0, msg1		#prompts user to enter string
	la $a1, buffer		#Syscall needs address for buffer. Buffer allocates space for string
	li $a2, 30		#$a2 sets max number of characters to read.
	li $v0, 54		#syscakk 54 "input dialog string"
	syscall
	
	la $s1, buffer		#this stores input string from buffer into $s registers
	sw $s1, ($sp)		#stores string to stack
	beq $a1, -2, cancel	#syscall 54 condition. -2 is information. 	
	beq $a1, -3, noString	#syscall 54 condition. 03 holds warning
	
	add $v0, $zero, $zero	#intializes $v0 to zero. prevent errenous results when loop runs
	add $v1, $zero, $zero
	
	jal count		#Jumps to function to count words and characters
	sw $v0, charCount	#stores results in variable. 
	sw $v0, -4($sp)		#stores it to stack. used later for output
	addi $v1, $v1, 1	#inaccurate method if double spaces or space at end/beginning of sentence
	sw $v1 wordCount	#stores to variable.
	sw $v1, -8($sp)		#stores it to stack. used later for output
	
	jal countComplete	#jumps to function output results. Could have J main from countcomplete
				#Did this for assignment reasons... just for practice.
	j main			#Jump to main. Loops back to ask for new string
	
exit:				#Syscall 10 terminates program.
	li $v0, 10
	syscall
	
count: 			
	lb $t0, ($s1)		#moves 1 byte to $t0
	beq $t0, 10, return	#If byte value = 10, which is end of line "line feed". signals end of string
	addi $v0, $v0, 1	#adds one to char count. counts every character including space
				#follows same precedence as example in instructions
	addi $s1, $s1, 1	#increments to the next byte of the string
	bne $t0, 32, count	#if byte != 32 (ascii value for space) loop back to count function
	addi $v1, $v1, 1	#add 1 to word count
	j count			#loops back to count function.
	
return:
	jr $ra			#returns to jal call
	
cancel:
	la $a0, msgCancel		#$a0 hold message. Cancel message
	li $a1, 1			#$a1 holds type of message. 1 is an information msg
	li $v0, 55
	syscall
	j exit
	
noString:				#if not string is entered
	la $a0, msgNoString		# $a0 hold message to output. no string entered message
	li $a1, 0			# $a1 holds type of message. 0 is a warning
	li $v0, 55
	syscall
	j exit
	
countComplete:
	lw $a0, ($sp)			#pops string from stack
	li $v0, 4
	syscall 
	
	lw $a0, -8($sp)		#pops word count from stack and outputs value
	li $v0, 1		#count based on spaces. Does not handle cases of double spaces
	syscall
	la $a0, msgWord		#outputs the word "word"
	li $v0, 4
	syscall
	
	lw $a0, -4($sp)		#pops character count from stack and outputs value
	li $v0,1 		
	syscall			
	la $a0, msgChar		#outputs word character
	li $v0, 4
	syscall
	
	li $a0, 10		#outputs newline
	li $v0, 11
	syscall 
	
	jr $ra			#returns after jal countComplete call
