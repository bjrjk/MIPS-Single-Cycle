ori $0,0x1403 # Test whether the value in $zero can be changed
lui $at,0x1804
ori $at,0x1403 # Write Student ID to $at
addu $sp,$0,$0 # Clear stack pointer
addu $s1,$0,$0
addiu $s1,$s1,1 # Change $s1 to 1
addi $a0,$0,5 # Pass parameter to FUNC_ADD
jal FUNC_ADD # Execute funcAdd
addi $a0,$0,5 # Pass parameter to FUNC_FIB
jal FUNC_FIB # Execute funcFib
jal FUNC_FUN_ADD # Execute funcFunAdd
lui $t7,0x7fff
ori $t7,0xffff # Set $t7 to 0x7fffffff
addi $t7,$t7,1 # Get $t7 Overflow
SELFLOOP:
j SELFLOOP
FUNC_ADD: # int funcAdd(int x){if(x==0)return 0;else return funcAdd(x-1)+1;}
beq $a0,$0,FUNC_ADD_TRIVIAL_RET # When x==0, jump to trivial branch
sw $a0,0($sp) # Save paramater x to stack
sw $ra,4($sp) # Save return address to stack
subu $a0,$a0,$s1 # Decrease x
addi $sp,$sp,8 # Add $sp
jal FUNC_ADD
addi $sp,$sp,-8 # Minus $sp
lw $ra,4($sp) # Load return address to register
lw $a0,0($sp) # Load paramater x to register
addu $v0,$v0,$s1 # Increase return value
j FUNC_ADD_RET # Return
FUNC_ADD_TRIVIAL_RET:
addu $v0,$0,$0
FUNC_ADD_RET:
jr $ra
FUNC_FIB: # int funcFib(int n){int x=0,y=0,z=1;for(int i=0;i<n;i++){x=y;y=z;z=x+y;}return z;}
addu $t0,$0,$0 # x=0
addu $t1,$0,$0 # y=0
addiu $t2,$0,1 # z=1
addu $t8,$0,$0 # i=0
FUNC_FIB_LOOP:
slt $t9,$t8,$a0 # i<n?
beq $t9,$0,FUNC_FIB_RET # i>=n return
addu $t0,$0,$t1 # x=y
addu $t1,$0,$t2 # y=z
addu $t2,$t0,$t1 # z=x+y
addu $t8,$t8,$s1 # i++
j FUNC_FIB_LOOP
FUNC_FIB_RET:
addu $v0,$0,$t2
jr $ra
FUNC_FUN_ADD: # void funcFunADD(){for(int i=0;i<10;i++)funcAdd(i);}
addu $t4,$0,$0 # i=0
addi $t5,$0,5 # n=5
FUNC_FUN_ADD_LOOP:
slt $t6,$t4,$t5 # i<n?
beq $t6,$0,FUNC_FUN_ADD_RET # i>=n return
sw $ra,0($sp) # Save return address to stack
addi $sp,$sp,4 # Add $sp
addu $a0,$0,$t4 # Pass parameter i
jal FUNC_ADD # Call funcAdd
addi $sp,$sp,-4 # Minus $sp
lw $ra,0($sp) # Load return address to register
addu $t4,$t4,$s1 # i++
j FUNC_FUN_ADD_LOOP
FUNC_FUN_ADD_RET:
jr $ra
