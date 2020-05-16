	#This project is a program that performs linear algebra on a 3x3 matrix.
	
	.data

buffer: .space 32	
eArray: .word 0, 0, 0, 0, 0, 0, 0, 0, 0
xArray: .word 0:9
bArray: .word 0:3
detA: .word 0
detD: .word 0
detG: .word 0
detMatrix: .word 0
xOne: .word 0
xTwo: .word 0
xThree: .word 0
mForm1: .asciiz "Matrix Form: \n|A   B   C |\n|D   E   F |\n|G   H   I  |"
mForm2: .asciiz "Matrix Form:\n|a1x1  a2x2 = b1|\n|a3x1  a4x2 = b2|"
menu: .asciiz "Menu:\n\n1. Determinant of 2x2\n2. Determinant of 3x3\n3. Solve system of equations 2x2\n4. Solve system of equations 3x3\n0. Exit"
msg0: .asciiz "The determinant was found to equal zero.\nNo unique solution exist."
msg1: .asciiz "Enter elements of matrix starting with..\n\nA1, A2 .. A[n] then\nB1,B2, .. B[n] so on "
msg2: .asciiz "Enter elements of matrix in the order:\n(A, B, C, D)"
msg3: .asciiz "Enter elements of matrix in the order:\n(A, B, C, D, E, F, G, H, I)"
msg4: .asciiz "Solve the system of equations for a 2x2 matrix.\nTake the form Ax=B.\nEnter matrix A, then matrix B"
msg5: .asciiz "Enter matrix A:\n\nA = |a1  a2|\n      |a3  a4|"
msg6: .asciiz "Enter matrix B:\n\nB = |b1|\n      |b2|"
msg7: .asciiz "Solve the system of equations for a 3x3 matrix.\nTake the form Ax=B.\nEnter matrix A, then matrix B"
msg8: .asciiz "Enter matrix A:\n\nA = |a1  a2  a3|\n      |a4  a5  a6|\n      |a7  a8  a9|"
msgx1: .asciiz "The value of x1 is: "
msgx2: .asciiz "The value of x2 is: "
msgx3: .asciiz "The value of x3 is: "
msgA: .asciiz  "Enter 1st element"
msgB: .asciiz  "Enter 2nd element"
msgC: .asciiz  "Enter 3rd element"
msgD: .asciiz  "Enter 4th element"
msgE: .asciiz  "Enter 5th element"
msgF: .asciiz  "Enter 6th element"
msgG: .asciiz  "Enter 7th element"
msgH: .asciiz  "Enter 8th element"
msgI: .asciiz  "Enter 9th element"
detIs: .asciiz "Determinant of matrix is:  "




	.text
main:
	la $s0, eArray
	la $s5, xArray
	la $s6, bArray
	li $v0, 51			#prints menu
	la $a0, menu
	la $a1, 1
	syscall
	move $t0, $a0			#t0 holds selected # from menu
	beq $t0, -2, exit
	beq $t0, 1, menu1			# 1 selected - Determinant
	beq $t0, 2, menu2
	beq $t0, 3, menu3
	#beq $t0, 4, menu4
	beq $t0, $zero, exit
	j main

exit: 
	li $v0, 10
	syscall
	
menu1:
	jal matrixForm
	li $v0, 55			#Prompts msg2 for 2x2 matrix
	la $a0, msg2
	la $a1, 1
	syscall
	
	jal get2x2
	li $v0, 56			#Prompts message for determinant result
	la $a0, detIs
	lw $a1, detMatrix
	syscall
	#ADD CHECK CONDITION DET = 0.
	addi $s0, $s0, 12
	
	j main	
	
menu2:
	jal matrixForm
	
	li $v0, 55			#Prompts msg3 for 3x3 matrix
	la $a0, msg3
	la $a1, 1
	syscall
	
	jal get3x3
	
	li $v0, 56			#Prompts message for determinant result
	la $a0, detIs
	lw $a1, detMatrix
	syscall
	
	j main
	
menu3:
	li $v0, 55			#Prompts msg for menu3
	la $a0, msg4
	la $a1, 1
	syscall
	
	
	li $v0, 55			#Prompts msg for matrix form
	la $a0, mForm2
	la $a1, 1
	syscall
	
	li $v0, 55			#Prompts msg matrix form of A in Ax = B
	la $a0, msg5
	la $a1, 1
	syscall
	
	jal get2x2
	
	li $v0, 55			#Prompts msg matrix form of B in Ax = B
	la $a0, msg6
	la $a1, 1
	syscall
	
	jal getB2x1
	
	lw $t0, detMatrix
	beq $t0, $zero, detZero
	
	add $t0, $zero, $zero
	addi $s0, $s0, 12
	addi $s5, $s5, -4
	
	jal copyMatrix2
	jal solveMatrix2
	
	li $v0, 56			#Prompts message for results
	la $a0, msgx1
	lw $a1, xOne
	syscall
	
	li $v0, 56			#Prompts message for results
	la $a0, msgx2
	lw $a1, xTwo
	syscall 
	
	jal main
	
menu4:
	li $v0, 55			#Prompts msg for menu3
	la $a0, msg4
	la $a1, 1
	syscall
	
get2x2: 
	addi $sp, $sp, -4
	sw $ra, ($sp)
	
	jal printMsgA
	addi $s0, $s0, -4
	sw $a0, ($s0)
	jal printMsgB
	addi $s0, $s0, -4
	sw $a0, ($s0)
	jal printMsgC
	addi $s0, $s0, -4
	sw $a0, ($s0)
	jal printMsgD
	addi $s0, $s0, -4
	sw $a0, ($s0)
	
	lw $t1, 12($s0)
	lw $t2, 8($s0)
	lw $t3, 4($s0)
	lw $t4, 0($s0)
	
	jal det2x2
	sw $s1, detMatrix
	
	lw $ra, ($sp)
	addi $sp, $sp, 4
	jr $ra
	
	
	
	
det2x2:
	mul $t5, $t1, $t4		#(AD-BC) = det of a 2x2 matrix
	mul $t6, $t3, $t2
	sub $s1, $t5, $t6		#det of 2x2 -> $s1
	jr $ra
	
get3x3:
	addi $sp, $sp, -4
	sw $ra, ($sp)
	
	jal printMsgA
	addi $s0, $s0, -4
	sw $a0, ($s0)
	jal printMsgB
	addi $s0, $s0, -4
	sw $a0, ($s0)
	jal printMsgC
	addi $s0, $s0, -4
	sw $a0, ($s0)
	jal printMsgD
	addi $s0, $s0, -4
	sw $a0, ($s0)
	jal printMsgE
	addi $s0, $s0, -4
	sw $a0, ($s0)
	jal printMsgF
	addi $s0, $s0, -4
	sw $a0, ($s0)
	jal printMsgG
	addi $s0, $s0, -4
	sw $a0, ($s0)
	jal printMsgH
	addi $s0, $s0, -4
	sw $a0, ($s0)
	jal printMsgI
	addi $s0, $s0, -4
	sw $a0, ($s0)
	jal det3x3
	
	lw $ra, ($sp)
	addi $sp, $sp, 4
	jr $ra
	
	
	#det3x3 finds the determinant with cofactor expansion
	#calls subrountine to find det of 2x2 matrixes
	#to be multiplied by co-factors
det3x3:
	addi $sp, $sp, -4
	sw $ra, ($sp)
	#DET OF A[E*I-H*F]
	lw $t1, 16($s0)
	lw $t2, 12($s0)
	lw $t3, 4($s0)
	lw $t4, 0($s0)
	lw $t0, 32($s0)
	jal det2x2					#det of 2x2 returned -> $s1
	mul $s1, $s1, $t0
	sw $s1 detA
	
	#DET OF D[B*I-C*H]
	lw $t1, 28($s0)			
	lw $t2, 24($s0)
	lw $t3, 4($s0)
	lw $t4, 0($s0)
	lw $t0, 20($s0)
	jal det2x2					#det of 2x2 returned -> $s1
	mul $s1, $s1, $t0
	sw $s1, detD					
	
	
	#DET OF G[B*F-C*E]
	lw $t1, 28($s0)
	lw $t2, 24($s0)
	lw $t3, 16($s0)
	lw $t4, 12($s0)
	lw $t0, 8($s0)
	jal det2x2
	mul $s1, $s1, $t0
	sw $s1, detG
	
	lw $t1, detA			#detA = cofactor expansion along element A
	lw $t2, detD			#detd = cofactor expansion along element D
	lw $t3, detG			#detG = cofactor expansion along element G
	
	sub $s1, $t1,$t2
	add $s1, $s1, $t3
	sw $s1, detMatrix
	
	lw $ra, ($sp)
	addi $sp, $sp, 4
	jr $ra
	
getB2x1:
	addi $sp, $sp, -4
	sw $ra, ($sp)
	
	jal printMsgA
	addi $s6, $s6, -4
	sw $a0, ($s6)
	jal printMsgB
	addi $s6, $s6, -4
	sw $a0, ($s6)
	
	lw $ra, ($sp)
	addi $sp, $sp, 4
	jr $ra
	
getB3x1:
	addi $sp, $sp, -4
	sw $ra, ($sp)
	
	jal printMsgA
	addi $s6, $s6, -4
	sw $a0, ($s6)
	jal printMsgB
	addi $s6, $s6, -4
	sw $a0, ($s6)
	jal printMsgC
	addi $s6, $s6, -4
	sw $a0, ($s6)
	
	lw $ra, ($sp)
	addi $sp, $sp, 4
	jr $ra
	
copyMatrix2:
	lw $t8, ($s0)
	sw $t8, ($s5)
	addi $s0, $s0, -4
	addi $s5, $s5, -4
	addi $t0, $t0, 1
	blt $t0, 4, copyMatrix2
	
	jr $ra
	
copyMatrix3:
	lw $t8, ($s0)
	sw $t8, ($s5)
	addi $s0, $s0, -4
	addi $s5, $s5, -4
	addi $t0, $t0, 1
	blt $t0, 9, copyMatrix2
	
	jr $ra
	
	#Using Cramers rule solving the unknown variables for a 2x2 matrix
	#By replacing columns with B and find the determinat
	#det of the new matrix divided by det of original matrix
	#will result in the corresponding unknown x value
solveMatrix2:
	addi $sp, $sp, -4
	sw $ra, ($sp)
	#first solve for x1 by replace first column with B and finding the determinant
	lw $t1, 4($s6)
	lw $t3, 0($s6)
	lw $t2, 8($s0)
	lw $t4, 0($s0)
	
	jal det2x2
	lw $t0, detMatrix
	div $s1, $s1, $t0
	sw $s1, xOne
	
	lw $t1, 12($s0)
	lw $t2, 4($s6)
	lw $t3, 4($s0)
	lw $t4, 0($s6)
	
	jal det2x2
	lw $t0, detMatrix
	div $s1, $s1, $t0
	sw $s1, xTwo
	
	lw $ra, ($sp)
	addi $sp, $sp, 4
	jr $ra

detZero:
	li $v0, 55			#If determinant = 0. No unique solution
	la $a0, msg0
	la $a1, 1
	syscall
	j main
	
matrixForm:
	li $v0, 55			#Prints matrix form
	la $a0, mForm1
	la $a1, 1
	syscall
	jr $ra
	
	#
	#The following subroutines ask for their corresponding element of the matrix
	#The entered value is passed in $a0 and handled when called
printMsgA:
	li $v0, 51			#prints msg to get elements of matrix
	la $a0, msgA
	la $a1, 1
	syscall
	jr $ra			#t0 holds selected # from menu
printMsgB:
	li $v0, 51			#prints msg to get elements of matrix
	la $a0, msgB
	la $a1, 1
	syscall
	jr $ra			#t0 holds selected # from menu
printMsgC:
	li $v0, 51			#prints msg to get elements of matrix
	la $a0, msgC
	la $a1, 1
	syscall
	jr $ra			#t0 holds selected # from menu
printMsgD:
	li $v0, 51			#prints msg to get elements of matrix
	la $a0, msgD
	la $a1, 1
	syscall
	jr $ra			#t0 holds selected # from menu
printMsgE:
	li $v0, 51			#prints msg to get elements of matrix
	la $a0, msgE
	la $a1, 1
	syscall
	jr $ra			#t0 holds selected # from menu
printMsgF:
	li $v0, 51			#prints msg to get elements of matrix
	la $a0, msgF
	la $a1, 1
	syscall
	jr $ra			#t0 holds selected # from menu
printMsgG:
	li $v0, 51			#prints msg to get elements of matrix
	la $a0, msgG
	la $a1, 1
	syscall
	jr $ra			#t0 holds selected # from menu
printMsgH:
	li $v0, 51			#prints msg to get elements of matrix
	la $a0, msgH
	la $a1, 1
	syscall
	jr $ra			#t0 holds selected # from menu
printMsgI:
	li $v0, 51			#prints msg to get elements of matrix
	la $a0, msgI
	la $a1, 1
	syscall
	jr $ra			#t0 holds selected # from menu
	

		