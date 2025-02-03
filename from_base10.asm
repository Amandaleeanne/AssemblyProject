# Implementation of FromBase10 function (milestone 2).

# Make the function visible to all assembled files.
.globl FromBase10

.text

# Returns the representation of a base 10 source number in a specified base between 2 and 36 (inclusive).
# Args:
#   $a0: base 10 whole number
#   $a1: target number base (1 < $a1 < 37)
#   $a2: address where the target number asciiz should be stored.
# Return value:
#   $v0: 0 on success, -1 on invalid args  
FromBase10:
# TODO: replace the following lines with an implemention of the function
# Convert Base 10 to given base ($a1) by repeatedly dividing it by base and storing remainder
    # Initialize registers
    add $t0, $zero, $zero  # Initialize remainder variable
    add $t1, $zero, $zero  # Initialize temporary buffer pointer
    add $t2, $zero, $zero  # Initialize intermediate ASCII storage
    add $t3, $zero, $zero  # Initialize pointer for appending characters

    la $t1, buffer         # Load the address of temp string buffer into $t1
    move $t3, $t1          # $t3 starts at the beginning of buffer

FromBase10_while_loop:
beqz $a0, FromBase10_end_while  # If $a0 == 0, exit loop
    #Obtain the remainder and quotient
    div $a0, $a1
    mflo $a0 # update $a0
    mfhi $t0 # Store remainder in $t0
    # 3b. Convert remainder to ASCII character
    ble $t0, 9, else_to_ascii_letters  # If remainder <= 9, go to digit conversion
        # Convert to ASCII number ('0'-'9')
        addi $t2, $t0, 48 # ASCII for numbers: '0' = 48
        j while_continue # Skip else
    else_to_ascii_letters:
        sub $t2, $t0, 10 # Convert to letter ('A'-'Z')
        addi $t2, $t2, 97 # ASCII for 'a' = 65
    while_continue:
    sb $t2, 0($t3) # Store ASCII character in buffer at position $t3
    addi $t3, $t3, 1 # Move pointer to next position in buffer
    j FromBase10_while_loop # Repeat loop

FromBase10_end_while:
sb $zero, 0($t3) # Append null terminator at end of string
# Step 4: Reverse the string
sub $t4, $t3, $t1     # $t4 = length of string (difference between $t3 and $t1)
la $a2, final_string   # Load the address of the final output buffer into $a2

reverse_loop:
    beqz $t4, reverse_done     # If length is 0, exit loop (we're done)
    
        sub $t3, $t3, 1 # point to the next backwards character in $t1
        lb $t2, 0($t3) # Copy character $t1 into $t2
    
        sb $t2, 0($a2) # Store the character in $a2
        addi $a2, $a2, 1 # Move pointer to next position in $a2
    
        addi $t4, $t4, -1 # Decrement string length
    j reverse_loop
reverse_done:
sb $zero, 0($a2)  # Append null byte at the end of the final string
# Step 5: Exit function
    li $v0, 0
    jr $ra   # Return from function
 
# Test by running from_base10_test.asm
li $v0, -1
jr $ra
