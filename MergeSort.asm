	.data
length: .word 8
nums: 	.word  0, 12, 3, 5, 0, 99, 7, 10
sorted: .word 0:8
space: 	.asciiz " "
	.text
# adding adciiz dresses
	lui $s1, 0x1001
	ori $s1, $s1, 0		# address of length in $s1
	addi $s0, $s1, 4	# address of nums in 					$s0		const
	lw $s1, 0($s1)		# length value in 					$s1		const
	sll $at, $s1, 2
	add $s2, $at, $s0	# address of sorted in 					$s2		const
	add $ra, $at, $s2	# address of space in					$ra		const
# end adding addresses
	
# initialization
	addi $s3, $s0, 0	# moving pointer #1 points to the first array 		$s3		const
	addi $s4, $s2, 0	# boundary on pointer #1 				$s4		const
	addi $s5, $s2, 0	# moving pointer #2 points to the second array		$s5		const
	sll $at, $s1, 2
	add $s6, $s2, $at	# boundary on pointer #2				$s6		const
	addi $s7, $zero, 4	# value by which we increment the pointers		$s7
	sll $t8, $s7, 1		# double increment for pointer				$t8
	sll $t9, $s1, 1		# boundary on the outer loop				$t9		const
	addi $t0, $s3, 0	# current main pointer to first array			$t0
	addi $t1, $s4, 0	# current boundary to first boundary 			$t1
	addi $t7, $s5, 0	# writing pointer to second array			$t7
	addi $fp, $zero, 0	# our tracker of which array to use			$fp	
# end initialization

#sort first half
addi $t2, $t0, 0
loop:	
#	addi $t2, $t0, 0	# address of the first value 				$t2
	add $t3, $t0, $s7	# address of the second value 				$t3
	add $t0, $t0, $t8	# increment our pointer by 2 * single increment
	addi $t4, $t3, 0	# temporary boundary for the address of first value	$t4
	slt $at, $t1, $t0	# if statement
	beq $at, $zero, merge	# branch if the boundary is above or equal to the current main pointer
	 lw $t5, 0($t2)
	addi $t0, $t1, 0	# set current main pointer to the boundary
# merge
merge:	
#	lw $t5, 0($t2)		# retrieve the first value 				$t5
	lw $t6, 0($t3)		# retrieve the second value				$t6
	slt $at, $t5, $t6	# if statement
	bne $at, $zero, first	# branch if first value is smaller than second
#	 nop
second: sw $t6, 0($t7)		# store second value at the address of the moving pointer
	addi $t7, $t7, 4	# increment moving pointer
	addi $t3, $t3, 4	# increment address of the second value
	j check1
#	 nop
first:	sw $t5, 0($t7)		# store first value at the address of the moving pointer
	addi $t7, $t7, 4	# increment moving pointer
	addi $t2, $t2, 4	# increment address of the first value
check1:	slt $at, $t2, $t4	# if statement
	bne $at, $zero, check2	# branch if first value address is less than boundary
	 slt $at, $t3, $t0
copy2:	lw $t6, 0($t3)		# retrieve the second value
	sw $t6, 0($t7)		# store second value at the address of the writing pointer
	addi $t7, $t7, 4	# increment writing pointer
	addi $t3, $t3, 4 	# increment address of the second value
	slt $at, $t3, $t0	# if statement
	bne $at, $zero, copy2	# branch if the second value address is less than boundary
	 nop
	j out
	 add $at, $t0, $s7
check2: 
#	slt $at, $t3, $t0	# if statement
	bne $at, $zero, merge	# branch if second value address is less than boundary
	 lw $t5, 0($t2)
copy1:	lw $t5, 0($t2)		# retrieve the first value
	sw $t5, 0($t7)		# store the first value at the address of the writing pointer
	addi $t7, $t7, 4	# increment writing pointer
	addi $t2, $t2, 4	# increment address of the first value
	slt $at, $t2, $t4	# if statement
	bne $at, $zero, copy1	# branch if the first value address is less than boundary
	 add $at, $t0, $s7
# end merge
out:	
#	add $at, $t0, $s7
	slt $at, $at, $t1	# if statement
	bne $at, $zero, loop	# branch if current pointer is less than or equal to the boundary
	 addi $t2, $t0, 0
	slt $at, $t0, $t1
finish:	
#	slt $at, $t0, $t1	# if statement
	beq $at, $zero, reset	# branch if the main pointer is greater than or equal to the boundary
	 lw $at, 0($t0)	
#	lw $at, 0($t0)		# retrieve the value at the main pointer
	sw $at, 0($t7)		# store the value at the main pointer at the address of the writing pointer
	addi $t0, $t0, 4
	addi $t7, $t7, 4
	j finish
	 slt $at, $t0, $t1	 
reset:	sll $s7, $s7, 1		# increment is doubled	
	sll $t8, $s7, 1		# double increment is updated
	beq $fp, $zero, zero	# if statement, branch if main pointer points to first array
#	 nop
one:	addi $t0, $s3, 0	# current main pointer to first array		
	addi $t1, $s4, 0	# current boundary to first boundary 	
	addi $t7, $s5, 0	# writing pointer to second array	
	addi $fp, $zero, 0	# set our tracker to 0
	slt $at, $s7, $t9	# if statement
	bne $at, $zero, loop	# branch if increment is less than the outer loop boundary
	 addi $t2, $t0, 0
	j cont
	 nop
zero:	addi $t0, $s5, 0	# current main pointer to second array
	addi $t1, $s6, 0	# current boundary to second array
	addi $t7, $s3, 0	# writing pointer to first array
	addi $fp, $zero, 1	# set our tracker to 1
	slt $at, $s7, $t9	# if statement
	bne $at, $zero, loop	# branch if increment is less than the outer loop boundary
	 addi $t2, $t0, 0
# end first half
	
cont:	addi $t2, $t0, 0	# address of the first value 				
	add $t3, $t0, $s7	# address of the second value 				
	add $t0, $zero, $t1	# boundary on the second value address
	addi $t4, $t3, 0	# boundary on the first value address
# second half 
# merge
zmerge:	lw $t5, 0($t2)		# retrieve the first value 				
	lw $t6, 0($t3)		# retrieve the second value				
	slt $at, $t5, $t6	# if statement
	bne $at, $zero, zfirst	# branch if first value is smaller than second
#	 nop
zsecond:sw $t6, 0($t7)		# store second value at the address of the moving pointer
	addi $t7, $t7, 4	# increment moving pointer
	addi $t3, $t3, 4	# increment address of the second value
	j zcheck1
#	 nop
zfirst:	sw $t5, 0($t7)		# store first value at the address of the moving pointer
	addi $t7, $t7, 4	# increment moving pointer
	addi $t2, $t2, 4	# increment address of the first value
zcheck1:slt $at, $t2, $t4	# if statement
	bne $at, $zero, zcheck2	# branch if first value address is less than boundary
	 slt $at, $t3, $t0
zcopy2:	lw $t6, 0($t3)		# retrieve the second value
	sw $t6, 0($t7)		# store second value at the address of the moving pointer
	addi $t7, $t7, 4	# increment moving pointer
	addi $t3, $t3, 4 	# increment address of the second value
	slt $at, $t3, $t0	# if statement
	bne $at, $zero, zcopy2	# branch if the second value address is less than boundary
	 nop
	j exit
	 nop
zcheck2:
#	slt $at, $t3, $t0	# if statement
	bne $at, $zero, zmerge	# branch if second value address is less than boundary
	 lw $t5, 0($t2)
zcopy1:
#	lw $t5, 0($t2)		# retrieve the first value
	sw $t5, 0($t7)		# store the first value at the address of the moving pointer
	addi $t7, $t7, 4	# increment moving pointer
	addi $t2, $t2, 4	# increment address of the first value
	slt $at, $t2, $t4	# if statement
	bne $at, $zero, zcopy1	# branch if the first value address is less than boundary
	 lw $t5, 0($t2)
# end merge
# end second half

#exit:	addi $v0, $zero, 10
#	syscall

exit:	beq $fp, $zero, zone
	addi $v0, $zero, 1
zzero:	lw $a0, 0($s3)		# retreive the value
#	addi $v0, $zero, 1
	syscall			# print value
	addi $a0, $ra, 0
	addi $v0, $zero, 4	
	syscall			# print space
	addi $s3, $s3, 4	# increment first array pointer
	slt $at, $s3, $s4	# if statement
	bne $at, $zero, zzero	# branch if first array pointer is less than boundary
	 addi $v0, $zero, 1	
	addi $v0, $zero, 10
	syscall
zone:	lw $a0, 0($s5)		# retreive the value
#	addi $v0, $zero, 1
	syscall			# print value
	addi $a0, $ra, 0
	addi $v0, $zero, 4	
	syscall			# print space
	addi $s5, $s5, 4	# increment second array pointer
	slt $at, $s5, $s6	# if statement
	bne $at, $zero, zone	# branch if second array pointer is less than boundary
	 addi $v0, $zero, 1
	addi $v0, $zero, 10
	syscall
# end	
