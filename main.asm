# Main program that converts between 2 bases (milestone 3).
.globl strlen_loop

.data
# TODO: Add as many additional cases as you see fit.
in_bases: .word 2 16 10 -1
in_numbers: .asciiz "101011" "2b" "64" ""
out_bases: .word 16 2 8 -1
result: .space 33  # Stores the actual output of the program

# Messages
input_message: .asciiz "\n\nThe number: "
base_message: .asciiz "\nIn base: "
output_message: .asciiz "\nEquals the number: "
error: .asciiz "\nA function failed\n"
success: .asciiz "\n\nProgram ran successfully\n"


.text
# $s0 stores the pointer of the current in_base and out_base
# $s1 stores the pointer of the current in_number
# Don't ask what happened to $s2 through $s4
# $s5 stores the current value of in_base
# $s6 stores the current value of in_number
# $s7 stores the current value of out_base
# $t9 stores the current character in the string for the strlen_loop procedure

# Initialize starting values
Initialize:
li $s0, 0  # 4 * index of test case
li $s1, 0  # offset into in_numbers asciiz for test case
li $v0, 0  # Initialize return value to 0 as a precaution

# Read next in_base and in_number
ReadInputs:
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

# Get length of string to increment pointer
la $a0, in_numbers($s1)
jal strlen_loop

add $s1, $s1, $v0 # Increment pointer for in_numbers
addi $s0, $s0, 4 # Increment pointer for in_bases and out_bases

j ReadInputs # Loop to next input

# Loop that gets the length of a string
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

Success:
li $v0, 4
la $a0, success
syscall
j Terminate

Terminate:
li $v0, 10
syscall

