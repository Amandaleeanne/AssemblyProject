# Main program that converts between 2 bases (milestone 3).
#
# TODO: implement the following.
#   1. Read the next source base and source number from in_bases and in_numbers respectively.
#   2. Print them.
#   3. Invoke ToBase10 to convert the source number to an intermediate base 10 number
#   4. Invoke FromBase10 to convert the intermediate base 10 number to the target base
#   5. Print the target number and target base.
#   6. Repeat until the source base is < 0.

.globl strlen_loop

.data

# TODO: Add as many additional cases as you see fit.
in_bases: .word 2 16 -1
in_numbers: .asciiz "101011" "2b" ""
out_bases: .word 16 2 -1

.text

# $t9 stores the current character in the string

# TODO: implement.



strlen_loop:
    lb $t9, 0($a0)             # load the next character into t2
    beqz $t9, exit_strlen      # check for the null character
    addi $a0, $a0, 1           # increment the string pointer
    addi $v0, $v0, 1           # increment the count
    j strlen_loop              # return to the top of the loop
exit_strlen: 
jr $ra


# Terminate
li $v0, 10
syscall

