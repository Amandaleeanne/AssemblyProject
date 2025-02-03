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
# Test by running from_base10_test.asm
li $v0, -1
jr $ra
