; This is the program that allows for a Game Boy to display and play the iconic

; 'Snake Game' where a player collects apples, avoiding both themselves as well
; as the walls that snake is confined to.

; Include any files that will be needed by the program
#include "hardware.inc"

; Define any constants

; Make room for the header
Section "Header", ROM0[$100]
	jp EntryPoint
	; Statically allocate memory for header
	ds $150 - @

; Define the entrypoint
EntryPoint:
	; Do NOT turn the LCD off outside of VBlank




; Any functions used in the program go down here

; Fade the screen to black
FadeBlack:
	ret

; Update the variables if the buttons have been pressed
UpdateKeys:
	; Poll half the controller
    ld a, P1F_GET_BTN
    call .onenibble
    ld b, a ; B7-4 = 1; B3-0 = unpressed buttons
  
    ; Poll the other half
    ld a, P1F_GET_DPAD
    call .onenibble
    swap a ; A7-4 = unpressed directions; A3-0 = 1
    xor a, b ; A = pressed buttons + directions
    ld b, a ; B = pressed buttons + directions
  
    ; And release the controller
    ld a, P1F_GET_NONE
    ldh [rP1], a
  
    ; Combine with previous wCurKeys to make wNewKeys
    ld a, [wCurKeys]
    xor a, b ; A = keys that changed state
    and a, b ; A = keys that changed to pressed
    ld [wNewKeys], a
    ld a, b
    ld [wCurKeys], a
    ret
  
.onenibble
    ldh [rP1], a ; switch the key matrix
    call .knownret ; burn 10 cycles calling a known ret
    ldh a, [rP1] ; ignore value while waiting for the key matrix to settle
    ldh a, [rP1]
    ldh a, [rP1] ; this read counts
    or a, $F0 ; A7-4 = 1; A3-0 = unpressed keys
.knownret
    ret
