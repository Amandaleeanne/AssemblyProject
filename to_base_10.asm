.text
#if the base is ten, calculations are not needed
bne $a0, 10, not_base_10
	li $v1, $a1
	j end_fucntion
#Otherwise, 
not_base_10:
lw $t0, $t2 #Copy the value of a1 to t0 for changing things around
strlen:
    li $t1, 0           # initialize the count to zero
strlen_loop:
    lb $t2, 0($t0)             # load the next character into t2
    beqz $t2, exit_strlen      # check for the null character
    addi $t0, $t0, 1           # increment the string pointer
    addi $t1, $t1, 1           # increment the count
    j strlen_loop              # return to the top of the loop
exit_strlen: 
#Next section of the fucntion:
# Loop condition: i != 0
For_loop:
    # Check if i != 0
    beq $t0, $t1, for_loop_end    # if i == 0, exit loop

    	#Stuff go here TODO: Fill in

    # Decrement the loop counter (i = i - 1)
    sub $t0, $t0, 1     # i = i - 1
    # Jump back to the loop condition check
    j For_loop

for_loop_end:
    # Exit program
    li $v0, 10           # System call for exit
    syscall

end_function:
li $v0, 10
syscall
