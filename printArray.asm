.data
	array: 	.word 57, 307, 757,  64, 335, 832, 885, 475,  25, 309
			.word 258, 439, 285, 685, 934, 881, 345,  64, 742, 776
			.word 316, 778, 818, 356, 482, 628, 283, 444, 537, 921
			.word 676, 428, 288, 587, 569, 420, 706, 395,  25, 852
			.word 402, 930, 196,  68, 745,  70, 698,  87, 384, 144
			.word 353, 345, 782,  45, 510, 296, 315,   2, 309, 676
			.word 556, 794,  45, 289, 423,  79, 899, 337,  71, 525
			.word 16, 313, 291, 763, 437, 855, 125, 419, 582,  70
			.word 948, 112, 220, 131, 369, 332, 282, 196, 470, 152
			.word 935, 753, 197, 964, 362, 998, 371, 838, 338, 644
	ARRAY_SIZE = 100
			
	x1: .word 3
	x2: .word 6
	y1: .word 4
	y2: .word -3
	z1: .word 14
	z2: .word 5
			
	SYSTEM_EXIT = 10
	SYSTEM_PRINT_INTEGER = 1
	SYSTEM_PRINT_CHARACTER = 11
	SYSTEM_PRINT_FLOAT = 2
	SYSTEM_PRINT_STRING = 4
	
	vectorLengthLabel: .asciiz "Vector Length: "
	
.text
.globl main
.ent main
main:

	la $a0, array
	li $a1, ARRAY_SIZE
	jal printArray

	la $a0, x1
	la $a1, y1
	la $a2, z1
	la $a3, x2
	la $t0, y2
	la $t1, z2
	subu $sp, $sp, 8
	sw $t0, ($sp)
	sw $t1, 4($sp)
	jal add3DVectors
	addu $sp, $sp, 8
	
	li $v0, SYSTEM_PRINT_STRING
	la $a0, vectorLengthLabel
	syscall
	
	li $v0, SYSTEM_PRINT_FLOAT
	mov.s $f12, $f0
	syscall
	
	li $v0, 10
	syscall
.end main

.globl printArray
.ent printArray
printArray:

	move $t0, $a0

	li $t1, 1
	printLoop:
		li $v0, SYSTEM_PRINT_INTEGER
		lw $a0, ($t0)
		syscall
		
		li $v0, SYSTEM_PRINT_CHARACTER
		li $a0, ' '
		syscall
		
		remu $t2, $t1, 7
		bnez $t2, skipNewLine
			li $v0, SYSTEM_PRINT_CHARACTER
			li $a0, '\n'
			syscall
		skipNewLine:
		
		addu $t1, $t1, 1 #Newline Counter
		addu $t0, $t0, 4
		subu $a1, $a1, 1
	bnez $a1, printLoop

	jr $ra
.end printArray

.globl add3DVectors
.ent add3DVectors
add3DVectors:

	subu $sp, $sp, 4
	sw $fp, ($sp)
	addu $fp, $sp, 4
	
	lw $t4, ($fp) #&y2
	lw $t5, 4($fp) #&z2
	
	# Retrieve values from their references
	lw $t0, ($a0)	#x1
	lw $t1, ($a1)	#y1
	lw $t2, ($a2)	#z1
	lw $t3, ($a3)	#x2
	lw $t4, ($t4)	#y2
	lw $t5, ($t5)	#z2
	
	addu $t0, $t0, $t3
	addu $t1, $t1, $t4
	addu $t2, $t2, $t5
	
	sw $t0, ($a0)
	sw $t1, ($a1)
	sw $t2, ($a2)
	
	mul $t0, $t0, $t0
	mul $t1, $t1, $t1
	mul $t2, $t2, $t2
	add $t0, $t0, $t1
	add $t0, $t0, $t2
	
	mtc1 $t0, $f0
	cvt.s.w $f0, $f0
	sqrt.s $f0, $f0

	lw $fp, ($sp)
	addu $sp, $sp, 4
	
	jr $ra
.end add3DVectors

