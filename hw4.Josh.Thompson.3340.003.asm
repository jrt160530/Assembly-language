	.data
height: .word 0
weight: .word 0
bmi: .float 0
b: .word 703
under: .float 18.5
norm: .float 25
over: .float 30
name: .space 20
msgName: .asciiz "Please enter your name: " 
msgHt: .asciiz "Please enter your height in inches: " 
msgWt: .asciiz "Please enter your weight in pounds. Round to nearest whole number: "
msgB: .asciiz "Your BMI is: "
msgU: .asciiz "This is considered underweight. "
msgN: .asciiz "This is considered normal weight. "
msgOv: .asciiz "This is considered over weight "
msgOb: .asciiz "This is considered obese "

	.text
main: 
	li $v0, 4		#Syscall 4 prints string
	la $a0, msgName		#prompts to enter name
	syscall 

	li $v0, 8		#syscall 8 reads string
	la $a0, name 		#load address of buffer to hold string
	li $a1, 20		#max chars read set to equal space of buffer
	syscall
	
	li $a0, 10		#outputs newline
	li $v0, 11		#syscall 11 prints char
	syscall 

	li $v0, 4		#syscall 4 print string
	la $a0, msgHt		#prompts to enter height
	syscall 

	li $v0, 5		#syscall 5 reads integer 
	syscall
	sw $v0, height		#store input to height
	
	li $a0, 10		#outputs newline
	li $v0, 11
	syscall 

	li $v0, 4		#syscall 4 prints string
	la $a0, msgWt		#prompts to enter weight
	syscall 

	li $v0, 5		#syscall 5 reads integer
	syscall
	sw $v0, weight		#store input to weight variable
	
	li $a0, 10		#outputs newline
	li $v0, 11
	syscall 
	
	l.s $f0, height		#loads integer from height into float point register
	cvt.s.w $f0, $f0	#convert integer to single point
	l.s $f1, weight		#load inter to fp register
	cvt.s.w $f1, $f1	#convert to single point
	l.s $f2, b		#load inter to fp register
	cvt.s.w $f2, $f2	#convert to single point
	
	mul.s $f0, $f0, $f0	#multiply single point 
	mul.s  $f12, $f1, $f2	#multiply single point 
	div.s $f12, $f12, $f0	#divide single point		
	
	li $v0, 4		#prints name entered earlier
	la $a0, name 
	syscall
	
	li $v0, 4		#prints message
	la $a0, msgB
	syscall
	
	li $v0, 2		#prints floating point fronm $f12 register
	syscall 		#bmi was calculated and already stored in $f12
	
	li $a0, 10		#outputs newline
	li $v0, 11
	syscall 
	 
	l.s $f4, under		#loads integer into fp register. bmi index for under weight
	c.lt.s $f12, $f4	#checks if bmi is less than bmi index
	bc1t underW		#branch if true. c = 1
	
	l.s $f4, norm		#loads integer into fp register. bmi index for normal weight
	c.lt.s $f12, $f4	#checks if bmi is less than bmi index
	bc1t normW		#branch if true. c = 1
	
	l.s $f4, over		#loads integer into fp register. bmi index for normal weight
	c.lt.s $f12, $f4	#checks if bmi is less than bmi index
	bc1t overW		#branch if true. c = 1
	
	li $v0, 4		#if no conditions were met.Obese 
	la $a0, msgOb
	syscall
	j exit	

	
	
exit: 
	li $v0, 10
	syscall
	
underW:
	li $v0, 4		#prints message for under weight index
	la $a0, msgU
	syscall
	j exit

normW:
	li $v0, 4		#prints message for normal weight index
	la $a0, msgN
	syscall
	j exit	
	
overW:
	li $v0, 4		#prints message for over weight index
	la $a0, msgOv
	syscall
	j exit	





