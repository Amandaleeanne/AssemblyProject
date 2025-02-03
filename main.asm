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
out_numbers: .asciiz "2b" "00101011" ""

result: .space 33  # Stores the actual output of the program

# Messages
input_message: .asciiz "The number: "
base_message: .asciiz "\nIn base: "
output_message: .asciiz "\nEquals the number: "
error: .asciiz "\nA function failed\n"
fail: .asciiz "\nA test failed\n"
success: .asciiz "\nProgram ran successfully\n"


.text

# $s0 stores the pointer of the current base--both in and out
# $s1 stores the pointer of the current number--both in and out

# $s5 stores the current value of in_base
# $s6 stores the current value of in_number
# $s7 stores the current value of out_base

# $t9 stores the current character in the string

Initialize:
li $s0, 0  # 4 * index of test case
li $s1, 0  # offset into in_numbers asciiz for test case

ReadInputs:
# Read next in_base and in_number
lw $s5, in_bases($s0)  # a0: base of source number in test case
bltz $s5, Success  # no more test cases, so terminate with success
la $s6, in_numbers($s1)  # a1: address of source number string in test case


# Prints the input number and base
PrintInputs:
li $v0, 4
la $a0, input_message
syscall
li $v0, 4
move $a0, $s6
syscall
li $v0, 4
la $a0, base_message
syscall
li $v0, 1
move $a0, $s5
syscall

# Prepares and calls ToBase10 function
PrepareToTen:
move $a0, $s5 # Loads input base into $a0
move $a1, $s6 # Loads input number into $a1
jal ToBase10 # Call ToBase10 function
bltz $v0, Error # If ToBase10 failed, this fails as well

# Prepares and calls FromBase10 function
PrepareFromTen:
move $a0, $v0 # Output of ToBase10 becomes input for FromBase10
lw $a1, out_bases($s0) # Loads output base into $a1

move $s7, $a1 # Copies out_base into $s7
la $a2, result # Loads address of result into $a2
jal FromBase10 # Call FromBase10 function
bltz $v0, Error # If FromBase10 failed, this fails as well

# Prints the output number and the output base
PrintOutputs:
li $v0, 4
la $a0, output_message
syscall
li $v0, 4
la $a0, result
syscall
li $v0, 4
la $a0, base_message
syscall
li $v0, 1
move $a0, $s7
syscall

# INCREMENT POINTERS AND COUNTERS AND LOOP UNTIL ALL TEST CASES ARE RUN
j Success

# THE FOLLOWING CODE IS FOR TESTING THE PROGRAM'S OUTPUTS
# REMOVE IT WHEN PROJECT IS FINISHED
TestCase:
lbu $s2, out_numbers($s1)

strlen_loop:
    lb $t9, 0($a0)             # load the next character into t2
    beqz $t9, exit_strlen      # check for the null character
    addi $a0, $a0, 1           # increment the string pointer
    addi $v0, $v0, 1           # increment the count
    j strlen_loop              # return to the top of the loop
exit_strlen: 
jr $ra


Error:
li $v0, 4
la $a0, error
syscall
j Terminate

Failure: # Remove allong with Test cases
li $v0, 4
la $a0, fail
syscall
j Terminate

Success:
li $v0, 4
la $a0, success
syscall
j Terminate

Terminate:
li $v0, 10
syscall

