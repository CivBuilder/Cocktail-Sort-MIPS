# Author: Christopher Catechis <8000945777>
# Section: 1001
# Date Last Modified: 11/17/2021
# Program Description: This program utilizes the cocktail sort algorithm
# on an array of size 100 and finds the median. 

.data
    # Array declaration/const size
    array: .word 57, 307, 757,  64, 335, 832, 885, 475,  25, 309
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

    # uninitialized variable
    median: .space 4

    # labels
    unsortedListLabel: .asciiz "Unsorted List:\n"
    sortedListLabel: .asciiz "Sorted List:\n"
    medianLabel: .asciiz "Median: "
    
    # System service calls
	SYSTEM_EXIT = 10
	SYSTEM_PRINT_INTEGER = 1
	SYSTEM_PRINT_CHARACTER = 11
	SYSTEM_PRINT_FLOAT = 2
	SYSTEM_PRINT_STRING = 4

.text

.globl main
.ent main
main:

    # print the unsorted list
    li $v0, SYSTEM_PRINT_STRING  # print label
    li $a0, unsortedListLabel
    syscall 
	la $a0, array  # print array
	li $a1, ARRAY_SIZE
	jal printArray

    # sort the list (cocktail sort)
    cocktailSort:
        la $a0, array
        li $a1, ARRAY_SIZE
        jal shakeRight
        beqz $v0, printSortedList  # if no swaps occur, print.

        la $a0, array
        li $a1, ARRAY_SIZE
        jal shakeLeft
        beqz $v0, printSortedList  # if no swaps occur, print.

        j cocktailSort

    # print the sorted list
    printSortedList:
        li $v0, SYSTEM_PRINT_STRING  # print label
        li $a0, sortedListLabel
        syscall 
        la $a0, array  # print array
        li $a1, ARRAY_SIZE
        jal printArray

    # find/print the median
    jal findMedian  # find the median
    li $v0, SYSTEM_PRINT_STRING  # print label
    li $a0, medianLabel
    syscall
    li $vo, SYSTEM_PRINT_INTEGER  # print median
    li $a0, median
    syscall 

.end main

# ---------------------------------------------------------------
# @note prints an array to the command line
# @parameter a0 an array passed by reference
# @parameter a1 const value of the size of an array
# ---------------------------------------------------------------
.globl printArray
.ent printArray
printArray:

    move $t0, $a0  # move array into $t0

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
        
        addu $t1, $t1, 1 # Newline Counter
        addu $t0, $t0, 4  # next character
        subu $a1, $a1, 1  # --i
    bnez $a1, printLoop  # if i!=0, loop

    jr $ra
.end printArray

# ---------------------------------------------------------------
# @note traverses array from begin->end, placing the largest int
#       at the end of the array
# @param a0 array passed by reference
# @param a1 const value of the size of the array
# ---------------------------------------------------------------
.globl shakeRight
.ent shakeRight
shakeRight:

    li $t3, 0  # swapCounter.
    la $t1, $a0 # move array into $t1
    la $t2, $a0  # move array into $t2
    addu $t2, $t2, 4  # set $t2 to a leading position
    
    sortLoop:
        li $t0, 0  # bool to check if swapped. Reinitialize to 0 each loop.
        lw $t4, ($t1)
        lw $t5, ($t2)
        sgt $t0, $t4, $t5 # if $t4 > $t5 set $t0 (swapped) == true
        beq $t0, 1, swapLoop  # increment swapCounter
        beqz $t0, incrementLoop  # if $t0 == 0, jump to incrementLoop

    swapLoop:
        addu $t3, $t3, 1  # ++swapCounter   
        sw $t5,($a0)  # move array[i] into $t1
        sw $t4, 4($a0)  # move array[i+1] into $t2

    incrementLoop:
        addu $t1, $t1, 4  # array[i] = array[i+1]
        addu $t2, $t2, 4  # increment leading comparison
        subu $a1, $a1, 1  # --i
        bnez $a1, sortLoop  # if i!=0, loop
    
    move $v0, $t3  # return swapCounter

    jr $ra
.end shakeRight

# ---------------------------------------------------------------
# @note traverses array from end->begin, placing the smallest int
#       at the beginning of the array
# @param a0 array passed by reference
# @param a1 const value of the size of the array
# ---------------------------------------------------------------
.globl shakeLeft
.ent shakeLeft
shakeLeft:

    li $t3, 0  # swapCounter.
    la $t1, $a0 # move array into $t1
    la $t2, $a0  # move array into $t2
    addu $t1, $t1, 396  # set $t1 to end position - 1
    addu $t2, $t2, 400  # set $t2 to a previous position
    
    sortLoop:
        li $t0, 0  # bool to check if swapped. Reinitialize to 0 each loop.
        lw $t4, ($t1)
        lw $t5, ($t2)
        sgt $t0, $t4, $t5 # if $t4 > $t5 set $t0 (swapped) == true
        beq $t0, 1, swapLoop  # increment swapCounter
        beqz $t0, incrementLoop  # if $t0 == 0, jump to incrementLoop

    swapLoop:
        addu $t3, $t3, 1  # ++swapCounter   
        sw $t5, ($a0)  # move array[i] into $t1
        sw $t4, 4($a0)  # move array[i+1] into $t2

    incrementLoop:
        subu $t1, $t1, 4  # array[i] = array[i+1]
        subu $t2, $t2, 4  # increment leading comparison
        subu $a1, $a1, 1  # --i
        bnez $a1, sortLoop  # if i!=0, loop
    
    move $v0, $t3  # return swapCounter

    jr $ra
.end shakeLeft

# ---------------------------------------------------------------
# @note finds the median value an array
# @param a0 array passed by reference
# @param a1 const value of the size of the array
# ---------------------------------------------------------------
.globl findMedian
.ent findMedian
findMedian:
    # take two middle numbers
    la $t1, $a0
    la $t2, $a0
    li $t3, 2
    addu $t1, $t1, 200
    addu $t2, $t2, 196

    addu $t1, $t1, $t2
    divu $t1, $t1, $t3

    sw $t1, median

    jr $ra
.end findMedian