; --------------------------------------------------------------------
; author: lgkmkd aka lilgucciknot
; license: https://opensource.org/licenses/BSD-2-Clause
; --------------------------------------------------------------------

org 100h

; #####################
; #    VOID VALLEY    #           (a minimalist esoteric
; #####################             farming game for ms dos)

; addresses (seg 700h): 
; 50h = player x
; 51h = player y
; 52h = player direction (0 - left, increases clockwise 90 degrees)
; 53h = current tool

; sprites:
; hoe: right - 170, left - 169, down - 192, up - 191
; seed bag: 173
; player: 158
; water: 176
; wall: 177

; todo:
; buy seeds 
; plants stored in seperate segment and that can grow
; plants should be a 1 dimensional list that is turned into coords like a pixel array
; decorational tiles (farmland, water, maybe recursive trees?)
;-hoe and seeds drawn with player (variable for current direction and tool) 
; finish and implement hud
; maybe hotbar
; cute house

init:
    mov [50h], 10   ; init player position
    mov [51h], 10
    
    call update
    jmp main_loop

update:             ; clear window and redraw player / enemies    
    push ax
    push cx
    push dx
    
    mov al, 02      ; clear screen
    mov ah, 00
    int 10h
    
    mov ch, 32      ; hide cursor  
    mov ah, 1
    int 10h
    
    mov dh, [50h]   ; set cursor position
    mov dl, [51h]
    mov ah, 2
    int 10h
    
    mov al, 158     ; draw player
    mov ah, 0eh
    int 10h
    
    cmp [53h], 0    ; hoe selected
    je choosehoe
    
    cmp [53h], 1
    je chooseseedbag; seed bag selected
    
    jmp finish_update ; no tool selected

choosehoe:    
    cmp [52h], 0
    je hoeleft
    
    cmp [52h], 1
    je hoeup
    
    cmp [52h], 2
    je hoeright
    
    cmp [52h], 3
    je hoedown 

chooseseedbag:
    cmp [52h], 0
    je seedbagleft
    
    cmp [52h], 1
    je seedbagup
    
    cmp [52h], 2
    je seedbagright
    
    cmp [52h], 3
    je seedbagdown 

finish_update:    
    pop dx
    pop cx
    pop ax
    ret        

seedbagleft:
    dec [51h]
    mov dh, [50h]   ; set cursor position
    mov dl, [51h]
    mov ah, 2
    int 10h
    
    mov al, 153     ; draw hoe
    mov ah, 0eh
    int 10h
    inc [51h]
    jmp finish_update
    

seedbagup:
    dec [50h]
    mov dh, [50h]   ; set cursor position
    mov dl, [51h]
    mov ah, 2
    int 10h
    
    mov al, 153     ; draw hoe
    mov ah, 0eh
    int 10h
    
    inc [50h]
    jmp finish_update

seedbagright:
    inc [51h]
    mov dh, [50h]   ; set cursor position
    mov dl, [51h]
    mov ah, 2
    int 10h
    
    mov al, 153     ; draw hoe
    mov ah, 0eh
    int 10h
    
    dec [51h]
    jmp finish_update

seedbagdown:
    inc [50h]
    mov dh, [50h]   ; set cursor position
    mov dl, [51h]
    mov ah, 2
    int 10h
    
    mov al, 153     ; draw hoe
    mov ah, 0eh
    int 10h
    
    dec [50h]
    jmp finish_update

hoeleft:
    dec [51h]
    mov dh, [50h]   ; set cursor position
    mov dl, [51h]
    mov ah, 2
    int 10h
    
    mov al, 169     ; draw hoe
    mov ah, 0eh
    int 10h
    inc [51h]
    jmp finish_update
    

hoeup:
    dec [50h]
    mov dh, [50h]   ; set cursor position
    mov dl, [51h]
    mov ah, 2
    int 10h
    
    mov al, 191     ; draw hoe
    mov ah, 0eh
    int 10h
    
    inc [50h]
    jmp finish_update

hoeright:
    inc [51h]
    mov dh, [50h]   ; set cursor position
    mov dl, [51h]
    mov ah, 2
    int 10h
    
    mov al, 170     ; draw hoe
    mov ah, 0eh
    int 10h
    
    dec [51h]
    jmp finish_update

hoedown:
    inc [50h]
    mov dh, [50h]   ; set cursor position
    mov dl, [51h]
    mov ah, 2
    int 10h
    
    mov al, 192     ; draw hoe
    mov ah, 0eh
    int 10h
    
    dec [50h]
    jmp finish_update

main_loop:
    xor ah, ah      ; input
    int 16h
    
    cmp al, 'w'
    je up
    
    cmp al, 's'
    je down
    
    cmp al, 'a'
    je left
    
    cmp al, 'd'
    je right
    
    cmp al, '1'     ; hoe
    je selecthoe
    
    cmp al, '2'     ; seedbag     
    je selectseedbag
    
    call update    
    jmp main_loop

left:               ; move player position and direction    
    dec [51h]
    mov [52h], 0
    call update    
    jmp main_loop

up:                 
    dec [50h]
    mov [52h], 1
    call update
    jmp main_loop

right:
    inc [51h]
    mov [52h], 2 
    call update
    jmp main_loop

down:
    inc [50h]
    mov [52h], 3
    call update
    jmp main_loop

selecthoe:
    mov [53h], 0
    jmp main_loop

selectseedbag:
    mov [53h], 1
    jmp main_loop

hud1: db 'gold: ', 0
hud2: db 'seeds: ', 0

sprint:
    mov ah, 0eh
    lodsb
    
    cmp al, 0
    je .done
    
    int 10h
    jmp sprint

.done:
    ret        

drawhud:
    push dx
    push ax
    
    xor dx, dx      ; move cursor
    mov ah, 2
    int 10h
    
    mov si, hud1    ; print gold
    call sprint
    
    mov dh, 1       ; move cursor
    mov ah, 2
    int 10h
    
    mov si, hud2    ; print seeds
    call sprint
    
    pop ax
    pop dx
    
    ret

ret