	.data
fout: .asciiz "textFile3.txt"
bad: .asciiz "Data is corrupted"
good: .asciiz "Data is ok"
buf: .space 80
buf2: .space 80


	.text
main: 
	li $v0, 13			#syscall 13 - open file
	la $a0, fout			#load address of file name	
	li $a1, 0			#Flags: 0 - read , 1 - write
	li $a2, 0			#max chars read.. 0 to ignore
	syscall
	move $s6, $v0			#save file descriptor
	
	li $v0, 14			#syscall 14 - read from file
	move $a0, $s6			#holds file descriptor
	la $a1, buf			#address of input buffer
	li $a2, 80			#max chars. 0 to ignore
	syscall
	
	li $v0, 16			#sysccall 16 - close file
	move $a0, $s6
	syscall
	
	la $s1, buf			#holds adress of buffers
	la $s2, buf2
	j loop
	
	
exit: 
	li $v0, 4			#if data is not corrupted 
	la $a0, good
	syscall 
	
	li $v0, 10
	syscall
	
loop:
	lb $a0, ($s1)				#load byte from buffer1
	add $t9, $zero, $zero			#sets counter to 0
	bnez  $a0, setP				#checks for null
	
	add $s2, $zero, $zero
	la $s2, buf2
	j check
	
setP:
	andi $t1, $a0, 1			#$t1 to store parity of bit
	add $t0, $t0, $t1			#$t0 to count parity of byte
	srl $a0, $a0, 1				#shifts right 1 bit.
	addi $t9, $t9, 1			#increments counter by 1
	
	slti $t8, $t9, 7			#checks for bit 8 .. [7]
	bnez $t8, setP
	
	andi $t0, $t0, 1			#if odd, parity 1
	bnez $t0, oddP				#if odd, branch
	
	lb $a0, ($s1)				#if even
	sb $a0, ($s2)				#store bit unchanged
	
	addi $s1, $s1, 1			#increments address to next byte
	addi $s2, $s2, 1			#buf and buf2
	
	j loop
	
oddP:						#odd '1' bits in byte
	lb $a0, ($s1)				
	ori $a0, $a0, 128			#or with 128 sets MSB [7] to 1
	sb $a0, ($s2)				#stores byte to buf2
	
	addi $s1, $s1, 1			#point to next byte 
	addi $s2, $s2, 1
	j loop
	
check:
	lbu $a0, ($s2)				#load byte unsigned
	beqz $a0, exit				#if null exit
	add $t9, $zero, $zero			#intializes counter to 0
	
	
loop2:
	andi $t1, $a0, 1			#$t1 to store parity of bit
	add $t0, $t0, $t1			#$t0 to count parity of byte
	srl $a0, $a0, 1				#shifts right 1 bit.
	addi $t9, $t9, 1			#increments counter by 1
	
	slti $t8, $t9, 7			#checks for bit [7]
	bnez $t8, loop2
	
	andi $t0, $t0, 1			#check for even or odd parity
	bne $a0, $t0, fail			#compares MSB with a new check of parity
	
	addi $s2, $s2, 1			#incremements address by 1, to next byte
	j check
	
fail:						#if parity bits do not equal
	li $v0, 4				#print data is corrupted
	la $a0, bad
	syscall
	
	li $v0, 10
	syscall
	
