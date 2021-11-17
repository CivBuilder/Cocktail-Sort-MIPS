# Author: Christopher Catechis <8000945777>
# Section: 1001
# Date Last Modified: 11/9/2021
# Program Description: Creates a simple MIPS program that will utilize arrays
# and arithmetic operations.

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
    unsortedListLabel: .asciiz "Sorted List:\n"
    medianLabel: .asciiz "Median: "
    
    # System service calls
	SYSTEM_EXIT = 10
	SYSTEM_PRINT_INTEGER = 1
	SYSTEM_PRINT_CHARACTER = 11
	SYSTEM_PRINT_FLOAT = 2
	SYSTEM_PRINT_STRING = 4

.text

# ---------------------------------------------------------------
# @note traverses array from begin->end, placing the largest int
#       at the end of the array
# @param a0 array passed by reference
# @param a1 const value of the size of the array
# ---------------------------------------------------------------
.globl shakeRight
.ent shakeRight
shakeRight:
    # ignore previous largest
    # if swapcount == 0, list is sorted

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
    # ignore previous smallest
    # if swapcount == 0, list is sorted

.end shakeLeft

# ---------------------------------------------------------------
# @note sorts the array via cocktail sort algorithm
# @param a0 array passed by reference
# @param a1 const value of the size of the array
# ---------------------------------------------------------------
.globl cocktailSort
.ent cocktailSort
cocktailSort:

.end cocktailSort

# ---------------------------------------------------------------
# @note finds the median value an array
# @param a0 array passed by reference
# @param a1 const value of the size of the array
# ---------------------------------------------------------------
.globl findMedian
.ent findMedian
findMedian:
    # take two middle numbers
        # average two middle numbers

.end findMedian

.globl main
.ent main
main:

# print the unsorted list
	la $a0, array
	li $a1, ARRAY_SIZE
	jal printArray

# print the sorted list
    la $a0, array
	li $a1, ARRAY_SIZE
	jal printArray

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