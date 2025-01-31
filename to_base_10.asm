# Make the function visible to all assembled files.
.globl ToBase10

.text
# Returns the base 10 integer value for a source number in a base bewteen 2 and 36 (inclusive).
# Args:
#   $a0: source number base (1 < base < 37)
#   $a1: address of the first letter in the null-terminated ascii string of the source whole number
#        (with possible digits '0', '1', ..., '9', 'a', 'b', ..., 'z', depending on the source base).
# Return value:
#   $v0: base 10 whole number (or -1 on invalid args)  

# $t0 stores a copy of $a1 for modifying
# $t1 stores the current power (which starts out as the length of the string)
# $t2 stores the current character of the string
# $t3 stores a copy of $a0 for raising to the current power
# $t4 stores a copy of $t1 for modifying

ToBase10:

move $t0, $a1 #Copy the value of a1 to t0 for changing things around
li $v0, 0 # Reset return value to zero
li $t1, 0 # initialize the loop counter to zero

strlen_loop:
    lb $t2, 0($t0)             # load the next character into t2
    beqz $t2, exit_strlen      # check for the null character
    addi $t0, $t0, 1           # increment the string pointer
    addi $t1, $t1, 1           # increment the count
    j strlen_loop              # return to the top of the loop
exit_strlen: 
subi $t1, $t1, 1 # Power = length of the string - 1

#Next section of the function:
# Loop condition: i >= 0
for_loop:
    bltz $t1, for_loop_end    # if i < 0, exit loop
    lbu $t2, 0($a1) # Load next character into $t2
    NumericTest:
	blt $t2, 48, Failure # Fails if ASCII value < 48
	bgt $t2, 57, AlphaTest # If ASCII value > 57 jump to next test
	subi $t2, $t2, 48 # If ASCII value in range, convert to number equivalent
	j PowerTest
    AlphaTest:
    	blt $t2, 97, Failure # Fails if ASCII value < 97
    	bgt $t2, 122, Failure # Fails if ASCII value > 122
    	subi $t2, $t2, 87 # If ASCII value in range, convert to number equivalent
    	j PowerTest
    PowerTest: # Branches if power is 0 or 1
    	beqz $t1, Power0 # Branches if power == 0
    	move $t3, $a0 # Sets $t3 to the base (any base raised to the power of 1)
    	beq $t1, 1, MultiplyDigit # Jumps to end if power == 1
    	j PowerX
    Power0: # Sets $t3 to 1 (any base aised to the power of 0)
	li $t3, 1
	j MultiplyDigit
    PowerX:
	move $t4, $t1 # Copy value of $t1 into $t4
	PowerLoop:
	    ble $t4, 1, MultiplyDigit # Breaks if power counter <= 1
	    mult $t3, $a0 # lo = $t3 * $a0
	    mflo $t3 # $t3 = lo
	    subi $t4, $t4, 1 # Decrement power counter
	    j PowerLoop
    MultiplyDigit:
	mult $t2, $t3 # Multiplies digit by the base raised to the current power
	mflo $t4 # Stores result in $t4
	add $v0, $v0, $t4 # v0 += $t4
    
	sub $t1, $t1, 1 # Decrement the current power
	addi $a1, $a1, 1 # Increment string address
	j for_loop # Jump back to the loop condition check

for_loop_end:
# Succesful Case
# Returns base10 number
jr $ra

# Returns -1 on a failure
Failure:
li $v0, -1
jr $ra
