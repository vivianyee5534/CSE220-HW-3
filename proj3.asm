# CSE 220 Programming Project #3
# VIVIAN YEE
# VIYEE
# 112145534

#################### DO NOT CREATE A .data SECTION ####################
#################### DO NOT CREATE A .data SECTION ####################
#################### DO NOT CREATE A .data SECTION ####################

.text
initialize:
    addi $sp, $sp, -24
    sw $s0, 0($sp)
    sw $s1, 4($sp)
    sw $s2, 8($sp)
    sw $s3, 12($sp)
    sw $s4, 16($sp)
    sw $s5, 20($sp)
    move $s0, $a0 # struct
    move $s1, $a1 # num of rows
    move $s2, $a2 # num of cols
    move $s3, $a3 # chars
    bltz $s1, initialize_error
    bltz $s2, initialize_error
    sb $s1, 0($s0) # set first byte as row
    addi $s0, $s0, 1
    sb $s2, 0($s0) # set second byte as column
    addi $s0, $s0, 1
    li $s4, 0 # counter
    mul $s5, $s2, $s1
    initialize_loop:
        beq $s4, $s5, initialize_end
        sb $s3, 0($s0)
        addi $s0, $s0, 1
        addi $s4, $s4, 1
        j initialize_loop
    initialize_error:
        li $v0, -1
        li $v1, -1
        lw $s0, 0($sp)
        lw $s1, 4($sp)
        lw $s2, 8($sp)
        lw $s3, 12($sp)
        lw $s4, 16($sp)
        lw $s5, 20($sp)
        addi $sp, $sp, 24
        jr $ra
    initialize_end:
        move $v0, $s1
        move $v1, $s2
        lw $s0, 0($sp)
        lw $s1, 4($sp)
        lw $s2, 8($sp)
        lw $s3, 12($sp)
        lw $s4, 16($sp)
        lw $s5, 20($sp)
        addi $sp, $sp, 24
        jr $ra


load_game:
    addi $sp, $sp, -36
    sw $s0, 0($sp)
    sw $s1, 4($sp)
    sw $s2, 8($sp)
    sw $s3, 12($sp) #t0
    sw $s4, 16($sp)
    sw $s5, 20($sp)
    sw $s6, 24($sp)
    sw $s7, 28($sp)
    sw $t5, 32($sp)
    move $s0, $a0 # state
    move $s1, $a1 # filename
    li $v0, 13 # read filename call
    move $a0, $s1 # file name
    li $a1, 0 # open for read
    li $a2, 0 # mode is ignored
    syscall # open a file
    move $s2, $v0 # save file descriptor
    bltz $s2, load_game_fail
    addi $sp, $sp, -1
    li $v0, 14 # read contents of file
    move $a0, $s2 # file descriptor
    move $a1, $sp # hold character
    li $a2, 1 # max size of character
    li $s7, 0 # counter for row/col
    load_game_loop_row:
        li $v0, 14
        syscall
        lb $s6, 0($a1)
        li $s3, '\n'
        beq $s3, $s6, load_game_loop_row2
        addi $s6, $s6, -48
        li $t5, 10
        mul $s7, $s7, $t5
        add $s7, $s7, $s6
        j load_game_loop_row
        load_game_loop_row2:
            sb $s7, 0($s0)
            li $s7, 0
            addi $s0, $s0, 1
    load_game_loop_col:
        li $v0, 14
        syscall
        lb $s6, 0($a1)
        li $s3, '\n'
        beq $s3, $s6, load_game_loop_col2
        addi $s6, $s6, -48
        li $t5, 10
        mul $s7, $s7, $t5
        add $s7, $s7, $s6
        j load_game_loop_col
        load_game_loop_col2:
            sb $s7, 0($s0)
            li $s4, 0 # counter for O
            li $s5, 0 # counter for invalid
            addi $s0, $s0, 1
    load_game_loop:
        beqz $v0, load_game_endloop # if end of file, end loo
        li $v0, 14
        syscall
        lb $s6, 0($a1)
        li $s3, '\n'
        beq $s3, $s6, load_game_back_to_loop # if its an end line, skip storing
        li $s3, 'O'
        beq $s3, $s6, load_game_loop_storeO # if it's equal to 'O', store it
        li $s3, '.'
        beq $s3, $s6, load_game_loop_store # if it's equal to '.', store it
        move $s6, $s3 # if it's not equal to neither, then change it to '.'
        addi $s5, $s5, 1 # add counter to invalid chars
        load_game_loop_store:
            sb $s6, 0($s0)
            j load_game_loop_add
        load_game_loop_storeO:
            sb $s6, 0($s0)
            addi $s4, $s4, 1
        load_game_loop_add:
            addi $s0, $s0, 1 # counter++
        load_game_back_to_loop:
            j load_game_loop # go back to loop   
    load_game_endloop:
        li $v0, 16
        move $a0, $s2
        syscall
        addi $sp, $sp, 1
    load_game_end:
        move $v0, $s4
        move $v1, $s5
        lw $s0, 0($sp)
        lw $s1, 4($sp)
        lw $s2, 8($sp)
        lw $s3, 12($sp) #t0
        lw $s4, 16($sp)
        lw $s5, 20($sp)
        lw $s6, 24($sp)
        lw $s7, 28($sp)
        lw $t5, 32($sp)
        addi $sp, $sp, 36
        jr $ra
    load_game_fail:
        li $v0, -1
        li $v1, -1
        lw $s0, 0($sp)
        lw $s1, 4($sp)
        lw $s2, 8($sp)
        lw $s3, 12($sp) #t0
        lw $s4, 16($sp)
        lw $s5, 20($sp)
        lw $s6, 24($sp)
        lw $s7, 28($sp)
        lw $t5, 32($sp)
        addi $sp, $sp, 36
        jr $ra


get_slot:
    addi $sp, $sp, -20
    sw $s0, 0($sp)
    sw $s1, 4($sp)
    sw $s2, 8($sp)
    sw $s3, 12($sp)
    sw $s4, 16($sp)
    move $s0, $a0 # state or piece
    move $s1, $a1 # row
    move $s2, $a2 # col
    lb $s3, 0($s0) # row of state
    bge $s1, $s3, get_slot_error
    addi $s0, $s0, 1
    lb $s4, 0($s0) # col of state
    bge $s2, $s4, get_slot_error
    addi $s0, $s0, 1
    mul $s3, $s1, $s4 # mul col of state with row
    add $s3, $s3, $s2 # add col
    add $s3, $s3, $s0
    lb $s3, 0($s3)
    move $v0, $s3
    lw $s0, 0($sp)
    lw $s1, 4($sp)
    lw $s2, 8($sp)
    lw $s3, 12($sp)
    lw $s4, 16($sp)
    addi $sp, $sp, 20
    jr $ra
    get_slot_error:
        li $v0, -1
        lw $s0, 0($sp)
        lw $s1, 4($sp)
        lw $s2, 8($sp)
        lw $s3, 12($sp)
        lw $s4, 16($sp)
        addi $sp, $sp, 20
        jr $ra


set_slot:
    addi $sp, $sp, -24
    sw $s0, 0($sp)
    sw $s1, 4($sp)
    sw $s2, 8($sp)
    sw $s3, 12($sp)
    sw $s4, 16($sp)
    sw $s5, 20($sp)
    move $s0, $a0 # state or piece
    move $s1, $a1 # row
    move $s2, $a2 # col
    move $s3, $a3 # character
    lb $s4, 0($s0) # row of state
    bge $s1, $s4, set_slot_error
    addi $s0, $s0, 1
    lb $s5, 0($s0) # col of state
    bge $s2, $s5, set_slot_error
    addi $s0, $s0, 1
    mul $s4, $s5, $s1 # mul row by col
    add $s4, $s4, $s2 # add col to row
    add $s4, $s4, $s0
    sb $s3, 0($s4)
    move $v0, $s3
    lw $s0, 0($sp)
    lw $s1, 4($sp)
    lw $s2, 8($sp)
    lw $s3, 12($sp)
    lw $s4, 16($sp)     
    lw $s5, 20($sp)
    addi $sp, $sp, 24
    jr $ra
    set_slot_error:
        li $v0, -1
        lw $s0, 0($sp)
        lw $s1, 4($sp)
        lw $s2, 8($sp)
        lw $s3, 12($sp)
        lw $s4, 16($sp)
        lw $s5, 20($sp)
        addi $sp, $sp, 24
        jr $ra


rotate:
    addi $sp, $sp, -40
    sw $s0, 0($sp)
    sw $s1, 4($sp)
    sw $s2, 8($sp)
    sw $s3, 12($sp) #
    sw $s4, 16($sp)
    sw $s5, 20($sp)
    sw $s6, 24($sp)
    sw $s7, 28($sp) #
    sw $ra, 32($sp)
    sw $t4, 36($sp)
    move $s0, $a0 # piece
    move $s1, $a1 # the number of 90 ?clockwise turns that should be performed
    move $s2, $a2 # address of buffer to write the rotated version of piece
    bltz $s1, rotate_error
    lb $s3, 0($s0)
    li $s4, 1
    beq $s3, $s4, rotate_sing
    li $s4, 2
    beq $s3, $s4, rotate_sq1
    addi $s0, $s0, 1
    lb $s3, 0($s0)
    beq $s3, $s4, rotate_sing
    addi $s0, $s0, -1
    rotate_mod:
    li $s3, 4
    div $s1, $s3
    mfhi $s3
    li $s4, 0
    beq $s4, $s3, rotate_loop_set0
    li $s4, 1
    beq $s4, $s3, rotate_loop_set1
    li $s4, 2
    beq $s4, $s3, rotate_loop_set2
    li $s4, 3
    beq $s4, $s3, rotate_loop_set3
    rotate_sq1:
        addi $s0, $s0, 1
        lb $s3, 0($s0)
        li $s4, 2
        addi $s0, $s0, -1
        beq $s4, $s3, rotate_loop_set0
        j rotate_mod
    rotate_sing:
        li $s3, 2
        div $s1, $s3
        mfhi $s3
        li $s4, 0
        beq $s4, $s3, rotate_loop_set0
        li $s4, 1
        beq $s4, $s3, rotate_sing_loop
        rotate_sing_loop:
            lb $s3, 0($s0)
            addi $s0, $s0, 1
            lb $s4, 0($s0)
            sb $s3, 0($s0)
            addi $s0, $s0, -1
            sb $s4, 0($s0)
            j rotate_loop0
    rotate_loop_set0:
        move $a0, $s2
        lb $a1, 0($s0)
        addi $s0, $s0, 1
        lb $a2, 0($s0)
        addi $s0, $s0, 1
        li $a3, 'x'
        jal initialize
        addi $s2, $s2, 2
        rotate_loop0:
            lb $s4, 0($s0)
            beqz $s4, rotate_exit
            sb $s4, 0($s2)
            addi $s0, $s0, 1
            addi $s2, $s2, 1
            j rotate_loop0
    rotate_loop_set1:
        addi $s0, $s0, 1
        lb $s5, 0($s0) # col of piece
        move $a1, $s5
        addi $s0, $s0, -1
        lb $s4, 0($s0) # row of piece
        move $a2, $s4
        move $a0, $s2
        li $a3, 'x'
        jal initialize
        addi $s5, $s5, -1 # (col-1) col = row (1)
        li $s6, -1 # col first
        move $s7, $s4
        move $t4, $s5
        rotate_loop_1i:
            addi $s6, $s6, 1 # (0)
            addi $s4, $s4, -1 # (2)
            move $s5, $t4
            bge $s6, $s7, rotate_exit
            rotate_loop_1j:
                bltz $s5, rotate_loop_1i
                move $a0, $s0 # piece
                move $a1, $s4 # row (2)
                move $a2, $s5 # col (1)
                jal get_slot
                move $s3, $v0
                move $v0, $s3
                move $a0, $s2 # buffer
                move $a1, $s5 # row
                move $a2, $s6 # col
                move $a3, $v0 # char
                jal set_slot
                addi $s5, $s5, -1
                j rotate_loop_1j
    rotate_loop_set2:
        move $a0, $s2
        lb $a1, 0($s0)
        addi $s0, $s0, 1
        lb $a2, 0($s0)
        addi $s0, $s0, -1
        li $a3, 'x'
        jal initialize
        li $s4, -1
        li $s5, 0
        move $s6, $a1
        addi $s7, $a2, -1
        move $t4, $s7
        rotate_loop_2i:
            addi $s4, $s4, 1
            addi $s6, $s6, -1
            li $s5, 0
            move $s7, $t4
            bltz $s6, rotate_exit
            rotate_loop_2j:
                bltz $s7, rotate_loop_2i
                move $a0, $s0
                move $a1, $s6
                move $a2, $s7
                jal get_slot
                move $a0, $s2
                move $a1, $s4
                move $a2, $s5
                move $a3, $v0
                jal set_slot
                addi $s5, $s5, 1
                addi $s7, $s7, -1
                j rotate_loop_2j
    rotate_loop_set3:
        addi $s0, $s0, 1
        lb $s5, 0($s0) # col of piece
        move $a1, $s5
        addi $s0, $s0, -1
        lb $s4, 0($s0) # row of piece
        move $a2, $s4
        move $a0, $s2
        li $a3, 'x'
        jal initialize
        li $s4, 0
        addi $s7, $s5, -1
        move $s6, $s7
        j rotate_loop_3j
        rotate_loop_3i:
           addi $s5, $s5, -1
           li $s4, 0
           move $s7, $s6
           bltz $s5, rotate_exit
           rotate_loop_3j:
               bltz $s7, rotate_loop_3i
               move $a0, $s0
               move $a1, $s5
               move $a2, $s7
               jal get_slot
               move $a0, $s2
               move $a1, $s4
               move $a2, $s5
               move $a3, $v0
               jal set_slot
               addi $s7, $s7, -1
               addi $s4, $s4, 1
               j rotate_loop_3j
    rotate_exit:
        move $v0, $s1    
        lw $s0, 0($sp)
        lw $s1, 4($sp)
        lw $s2, 8($sp)
        lw $s3, 12($sp)
        lw $s4, 16($sp)
        lw $s5, 20($sp)
        lw $s6, 24($sp)
        lw $s7, 28($sp)
        lw $ra, 32($sp)
        lw $t4, 36($sp)
        addi $sp, $sp, 40
        jr $ra
    rotate_error:
        li $v0, -1
        lw $s0, 0($sp)
        lw $s1, 4($sp)
        lw $s2, 8($sp)
        lw $s3, 12($sp)
        lw $s4, 16($sp)
        lw $s5, 20($sp)
        lw $s6, 24($sp)
        lw $s7, 28($sp)
        lw $ra, 32($sp)
        lw $t4, 36($sp)
        addi $sp, $sp, 40
        jr $ra
    

count_overlaps:
    addi $sp, $sp, -36
    sw $s0, 0($sp)
    sw $s1, 4($sp)
    sw $s2, 8($sp)
    sw $s3, 12($sp) 
    sw $s4, 16($sp) #
    sw $s5, 20($sp)
    sw $s6, 24($sp)
    sw $s7, 28($sp) #
    sw $t5, 32($sp)
    sw $t6, 36($sp)
    sw $t7, 40($sp)
    sw $ra, 44($sp)
    move $s0, $a0 # state
    move $s1, $a1 # row
    move $s2, $a2 # col 
    move $s3, $a3 # piece
    move $t6, $s2 # holder
    bltz $s1, count_overlaps_error
    bltz $s2, count_overlaps_error
    lb $s4, 0($s0)
    lb $s5, 0($s3)
    add $t5, $s5, $s1
    bgt $t5, $s4, count_overlaps_error
    addi $s0, $s0, 1
    addi $s3, $s3, 1
    lb $s4, 0($s0)
    lb $s5, 0($s3)
    add $t5, $s5, $s2
    bgt $t5, $s4, count_overlaps_error
    addi $s0, $s0, -1
    addi $s3, $s3, -1
    addi $s1, $s1, -1
    count_overlaps_loop:
        li $t5, 0 # num of X
        li $s4, -1 # go through rows
        li $s5, 0 # go through cols
        lb $s6, 0($s3) # row limit of piece
        addi $s3, $s3, 1
        lb $s7, 0($s3) # col limit of piece
        addi $s3, $s3, -1
        count_overlaps_loopi:
            li $s5, 0
            move $s2, $t6
            addi $s4, $s4, 1
            addi $s1, $s1, 1
            beq $s4, $s6, count_overlaps_endloop
            count_overlaps_loopj:
                beq $s5, $s7, count_overlaps_loopi
                move $a0, $s3
                move $a1, $s4
                move $a2, $s5
                jal get_slot
                li $t7, 'O'
                beq $v0, $t7, count_overlaps_sameO
                j count_overlaps_loopset
                count_overlaps_sameO:
                    move $a0, $s0
                    move $a1, $s1
                    move $a2, $s2
                    jal get_slot
                    beq $t7, $v0, count_overlaps_x
                    j count_overlaps_nox
                    count_overlaps_x:
                        move $a0, $s0
                        move $a1, $s1
                        move $a2, $s2
                        li $a3, 'X'
                        jal set_slot
                        addi $t5, $t5, 1
                        j count_overlaps_loopset
                    count_overlaps_nox:
                        move $a0, $s0
                        move $a1, $s1
                        move $a2, $s2
                        li $a3, 'O'
                        jal set_slot
                count_overlaps_loopset:
                    addi $s5, $s5, 1
                    addi $s2, $s2, 1
                    j count_overlaps_loopj
    count_overlaps_endloop:
        move $v0, $t5
        lw $s0, 0($sp)
        lw $s1, 4($sp)
        lw $s2, 8($sp)
        lw $s3, 12($sp)
        lw $s4, 16($sp)
        lw $s5, 20($sp)
        lw $s6, 24($sp)
        lw $s7, 28($sp)
        lw $t5, 32($sp)
        lw $t6, 36($sp)
        lw $t7, 40($sp)
        lw $ra, 44($sp)
        addi $sp, $sp, 36
        jr $ra
    count_overlaps_error:
        li $v0, -1
        lw $s0, 0($sp)
        lw $s1, 4($sp)
        lw $s2, 8($sp)
        lw $s3, 12($sp)
        lw $s4, 16($sp)
        lw $s5, 20($sp)
        lw $s6, 24($sp)
        lw $s7, 28($sp)
        lw $t5, 32($sp)
        lw $t6, 36($sp)
        lw $t7, 40($sp)
        lw $ra, 44($sp)
        addi $sp, $sp, 36
        jr $ra


drop_piece:
    lw $t0, 0($sp)
    addi $sp, $sp, -48
    sw $s0, 0($sp)
    sw $s1, 4($sp)
    sw $s2, 8($sp)
    sw $s3, 12($sp)
    sw $ra, 16($sp)
    sw $s4, 20($sp) #
    sw $s5, 24($sp)
    sw $s6, 28($sp)
    sw $s7, 32($sp)
    sw $t5, 36($sp)
    sw $t6, 40($sp)
    sw $t7, 44($sp)
    move $s0, $a0 # state
    move $s1, $a1 # col
    move $s2, $a2 # piece
    move $s3, $a3 # rotation
    # $t0 is rotated piece
    bltz $s3, drop_piece_error
    bltz $s1, drop_piece_error
    addi $s0, $s0, 1
    lb $s4, 0($s0)
    bge $s1, $s4, drop_piece_error
    addi $s0, $s0, -1
    drop_piece_rotate:
        move $a0, $s2
        move $a1, $s3
        move $a2, $t0
        jal rotate
    addi $t0, $t0, 1
    lb $s4, 0($t0)
    move $t5, $s4 # col of rotated piece
    lb $s5, 0($s0) # row of state
    add $s4, $s4, $s1 # col user + col of rotated piece
    bgt $s4, $s5, drop_piece_error_oob
    lb $s5, 0($t0) # num of cols piece has
    addi $t0, $t0, -1
    lb $t5, 0($t0) # num of rows piece has
    lb $s6, 0($s0) # num of rows state has
    sub $s6, $s6, $t5 
    move $t7, $s1 # col user
    li $s7, 0 #
    li $s4, 0
    drop_piece_fit:
        drop_piece_fit_yes:
            beq $s4, $s6, drop_piece_fit_drop_oop
            move $a0, $s0
            move $a1, $s4
            move $a2, $s1
            move $a3, $t0
            jal count_overlaps
            move $t3, $s4 # row that theyre on
            li $t2, 0 # row of piecee
            li $t4, 0 # col of piece
            move $t1, $s1 # col user
            bnez $v0, drop_piece_fit_drop_oop # if there is an overlap, go back 1
            li $a0, 's'
             li $v0, 11
             syscall
            j drop_piece_fit_no
            drop_piece_fit_yes_s:
                 li $t4, 0
                 move $t1, $s1
                 addi $t2, $t2, 1
                 addi $t3, $t3, 1
                 beq $t2, $t5, drop_piece_ok # drop_piece_ok
                 drop_piece_fit_no:
                     beq $s5, $t4, drop_piece_fit_yes_s
                     move $a0, $t0
                     move $a1, $t2
                     move $a2, $t4
                     jal get_slot
                     li $t6, 'O'
                     beq $v0, $t6, drop_piece_fit_o
                     j drop_piece_inc
                     drop_piece_fit_o:
                          move $a0, $s0
                          move $a1, $t3
                          move $a2, $t1
                          li $a3, '.'
                          jal set_slot
                  drop_piece_inc:
                     addi $t1, $t1, 1
                     addi $t4, $t4, 1
                     j drop_piece_fit_no
            drop_piece_ok:
                bnez $s7, drop_piece_fit_drop_oops
                addi $s4, $s4, 1
                j drop_piece_fit_yes
        drop_piece_fit_drop_oop:
            li $s7, 1
            j drop_piece_fit_yes_s
            drop_piece_fit_drop_oops:
            beqz $s4, drop_piece_nofit
            move $t4, $s0
            addi $s4, $s4, -1
            move $a0, $t4
            move $a1, $s4
            move $a2, $s1
            move $a3, $t0
            jal count_overlaps
            j drop_piece_woo
    drop_piece_error:
        li $v0, -2
        j drop_piece_error_end
    drop_piece_error_oob:
        li $v0, -3
        j drop_piece_error_end
    drop_piece_error_fit:
        beqz $s5, drop_piece_nofit
        j drop_piece_fits
        drop_piece_nofit:
            li $v0, -1
            j drop_piece_error_end
        drop_piece_fits:
            move $v0, $s5
            j drop_piece_error_end
    drop_piece_woo:
        beqz $s4, drop_piece_nofit
        move $v0, $t5
        j drop_piece_error_end
    drop_piece_error_end:
        lw $s0, 0($sp)
        lw $s1, 4($sp)
        lw $s2, 8($sp)
        lw $s3, 12($sp)
        lw $ra, 16($sp)
        lw $s4, 20($sp) #
        lw $s5, 24($sp)
        lw $s6, 28($sp)
        lw $s7, 32($sp)
        lw $t5, 36($sp)
        lw $t6, 40($sp)
        lw $t7, 44($sp)
        addi $sp, $sp, 48
        jr $ra


check_row_clear:
    addi $sp, $sp, -28
    sw $s0, 0($sp)
    sw $s1, 4($sp)
    sw $ra, 8($sp)
    sw $s2, 12($sp)#
    sw $s3, 16($sp)
    sw $s4, 20($sp)
    sw $s5, 24($sp)
    move $s0, $a0 # state
    move $s1, $a1 # row
    bltz $s1, check_row_clear_error
    lb $s2, 0($s0)
    bge $s1, $s2, check_row_clear_error
    li $s2, 0 # counter for col
    addi $s0, $s0, 1
    lb $s3, 0($s0) # col of state
    addi $s0, $s0, -1 
    check_row_clear_loop:
        beq $s2, $s3, check_row_clear_yes_loop
        move $a0, $s0
        move $a1, $s1
        move $a2, $s2
        jal get_slot
        li $s5, '.'
        beq $s5, $v0, check_row_clear_no
        addi $s2, $s2, 1
        j check_row_clear_loop
    check_row_clear_yes_loop:
        move $s5, $s3 # of col of state
        li $s2, 0 # col of state pointer
        move $s3, $s1 # row pointer
        addi $s4, $s3, -1 # row replacer
        j check_row_clear_yes_loopj
        check_row_clear_yes_loopi:
            li $s2, 0
            addi $s3, $s3, -1
            addi $s4, $s4, -1
            beqz $s3, check_row_clear_yes_last
            check_row_clear_yes_loopj:
                beq $s2, $s5, check_row_clear_yes_loopi
                move $a0, $s0
                move $a1, $s4
                move $a2, $s2
                jal get_slot
                move $a1, $s3
                move $a2, $s2
                move $a3, $v0
                jal set_slot
                addi $s2, $s2, 1
                j check_row_clear_yes_loopj
        check_row_clear_yes_last:
            beq $s2, $s5, check_row_clear_yes
            move $a1, $s3
            move $a2, $s2
            li $a3, '.'
            jal set_slot
            addi $s2, $s2, 1
            j check_row_clear_yes_last
    check_row_clear_error:
        li $v0, -1
        j check_row_clear_end
    check_row_clear_yes:
        li $v0, 1
        j check_row_clear_end
    check_row_clear_no:
        li $v0, 0
    check_row_clear_end:
        lw $s0, 0($sp)
        lw $s1, 4($sp)
        lw $ra, 8($sp)
        lw $s2, 12($sp)#
        lw $s3, 16($sp)
        lw $s4, 20($sp)
        lw $s5, 24($sp)
        addi $sp, $sp, 28
        jr $ra


simulate_game:
    lb $t0, 0($sp)
    lb $t1, 4($sp)
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    move $s0, $a0 # state
    move $s1, $a1 # filename 
    move $s2, $a2 # moves
    move $s3, $a3 # rotated piece
    # t0 num_pieces_to_drop
    # t1 pieces array
    move $a0, $s0
    move $a1, $s1
    jal load_game
    li $t0, -1
    beq $v0, $t0, simulate_game_error
    li $t2, 0 # number of successful drops 
    li $t3, 0 # number of pieces attempted to drop (move number)
    li $t4, 0
    simulate_game_getlengthmoves:
        lb $t5, 0($s2)
        beqz $t5, simulate_game_gotlengthmoves
        addi $t4, $t4, 1
        addi $s2, $s2, 1
        j simulate_game_getlengthmoves
    simulate_game_gotlengthmoves:
        li $t5, -1
        mul $t5, $t4, $t5
        add $s2, $s2, $t5 # go back to initial address
        li $t5, 4
        div $t4, $t5
        mflo $t4 # the number of moves encoded in pieces string
    li $t5, 0 # game over is "false"
    li $t6, 0 # score is 0
    addi $sp, $sp, -12
    sw $t4, 0($sp)
    sw $t2, 4($sp)
    sw $t0, 8($sp)
    simulate_game_loop:
        lw $t4, 0($sp)
        lw $t2, 4($sp)
        lw $t0, 8($sp)
        bnez $t5, simulate_game_end1 # while not game over
        beq $t2, $t0, simulate_game_end1 # while num_successful_drops < num_pieces_to_drop
        beq $t3, $t4, simulate_game_end1 # while move_number < moves_length
        lb $t7, 0($s2) # the game piece’s shape (as a character)
        addi $s2, $s2, 1
        lb $s4, 0($s2) # the game piece’s rotation
        addi $s4, $s4, -48 # convert ascii
        addi $s2, $s2, 1
        lb $s5, 0($s2)
        addi $s5, $s5, -48 # convert ascii
        li $s6, 10
        mul $s5, $s5, $s6
        addi $s2, $s2, 1
        lb $s6, 0($s2)
        addi $s6, $s6, -48
        add $s5, $s5, $s6 # the game piece’s column
        li $s6, 0 # invalid
        addi $s2, $s2, 1
        li $s7, 'T'
        beq $s7, $t7, simulate_game_array0 # array[0]
        li $s7, 'J'
        beq $s7, $t7, simulate_game_array1 # array[1]
        li $s7, 'Z'
        beq $s7, $t7, simulate_game_array2 # array[2]
        li $s7, 'O'
        beq $s7, $t7, simulate_game_array3 # array[3]
        li $s7, 'S'
        beq $s7, $t7, simulate_game_array4 # array[4]
        li $s7, 'L'
        beq $s7, $t7, simulate_game_array5 # array[5]
        li $s7, 'I'
        beq $s7, $t7, simulate_game_array6 # array[6]
        simulate_game_array0:
            li $s7, 0
            add $t1, $t1, $s7
            j simulate_game_attemptdroppiece
        simulate_game_array1:
            li $s7, 8
            add $t1, $t1, $s7
            j simulate_game_attemptdroppiece
        simulate_game_array2:
            li $s7, 16
            add $t1, $t1, $s7
            j simulate_game_attemptdroppiece
        simulate_game_array3:
            li $s7, 24
            add $t1, $t1, $s7
            j simulate_game_attemptdroppiece
        simulate_game_array4:
            li $s7, 32
            add $t1, $t1, $s7
            j simulate_game_attemptdroppiece
        simulate_game_array5:
            li $s7, 40
            add $t1, $t1, $s7
            j simulate_game_attemptdroppiece
        simulate_game_array6:
            li $s7, 48
            add $t1, $t1, $s7
        simulate_game_attemptdroppiece:
            move $a0, $s0 # state
            move $a1, $s5 # col
            move $a0, $s5
        li $v0, 1
        syscall
            move $a2, $t1 # piece
            move $a3, $s4 # rotation
            move $a0, $s4
        li $v0, 1
        syscall
        #j simulate_game_end1
            addi $sp, $sp, -4
            sw $t0, 0($sp) # rotated piece
            li $t0, 0x839313  # trashing $t0
            jal drop_piece
            move $a0, $v0
        li $v0, 1
        syscall
    j simulate_game_end1
            sub $t1, $t1, $s7
            addi $sp, $sp, 4
            li $t2, -2
            beq $t2, $v0, simulate_game_invalidt
            li $t2, -3
            beq $t2, $v0, simulate_game_invalidt
            li $t2, -1
            beq $t2, $v0, simulate_game_invalidtgameovert
        simulate_game_invalidt:
            li $s6, 1
            j simulate_game_checkinvalid
        simulate_game_invalidtgameovert:
            li $s6, 1
            li $t5, 1
        simulate_game_checkinvalid:
            bgtz $s6, simulate_game_movenum1
            j simulate_game_clearinglines
            simulate_game_movenum1:
                addi $t3, $t3, 1
                j simulate_game_loop
    # check for line clears by starting at the top of the game field and
    # working our way down
        simulate_game_clearinglines:
            li $t4, 0 # number of lines cleared by dropping this piece
            lb $t2, 0($s0)
            addi $t2, $t2, -1 # row counter
            simulate_game_checkrowscore:
                bltz $t2, simulate_game_score
                move $a0, $s0
                move $a1, $t2
                jal check_row_clear
                bgtz $v0, simulate_game_scorecount
                j simulate_game_scorenegcount
                simulate_game_scorecount:
                    addi $t4, $t4, 1
                    j simulate_game_checkrowscore
                simulate_game_scorenegcount:
                    addi $t2, $t2, -1
                    j simulate_game_checkrowscore
        simulate_game_score:
            li $t2, 1
            beq $t4, $t2, simulate_game_40
            li $t2, 2
            beq $t4, $t2, simulate_game_100
            li $t2, 3
            beq $t4, $t2, simulate_game_300
            li $t2, 4    
            beq $t4, $t2, simulate_game_1200
            simulate_game_40:
                addi $t6, $t6, 40
                j simulate_game_increment
            simulate_game_100:
                addi $t6, $t6, 100
                j simulate_game_increment
            simulate_game_300:
                addi $t6, $t6, 300
                j simulate_game_increment
            simulate_game_1200:
                addi $t6, $t6, 1200
        simulate_game_increment:
            addi $t3, $t3, 1
            lw $t2, 4($sp)
            addi $t2, $t2, 1
            sw $t2, 4($sp)
            j simulate_game_loop
    simulate_game_error:
        lw $sp, 0($sp)
        addi $sp, $sp, 4
        jr $ra
    simulate_game_end1:
        addi $sp, $sp, 12
    simulate_game_end:
        move $v0, $t2
        move $v1, $t6
        lw $ra, 0($sp)
        addi $sp, $sp, 4
        jr $ra


#################### DO NOT CREATE A .data SECTION ####################
#################### DO NOT CREATE A .data SECTION ####################
#################### DO NOT CREATE A .data SECTION ####################
