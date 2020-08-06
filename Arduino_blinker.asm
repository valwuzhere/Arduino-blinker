.cseg

	;rjmp delay
	.def number = r16  ;defining registers to be used in future
	.def num1 = r17
	.def num2 = r20
	.def num3 = r21
	.def num4 = r25
	.def mask = r18

	ldi number, 0x0A   ;the starting number is in r16

	ldi ZH, high(0x200<<1)
	ldi ZL, low(0x200<<1)
	ldi ZH, 0x02       ;putting the right dseg location into Z register
	ldi ZL, 0x00
	
	sts DDRL, number   ;setting up LED outputs
	out DDRB, number

	ldi r19, low(RAMEND) ; setup the stack
	out SPL, r19
	ldi r19, high(RAMEND) 
	out SPH, r19
	


after:
	st Z+, number      ;stores the numeber in a location and then increments to next location
	call output        ;outputs to LED
	dec number         ;decrements the number
	cpi number, 0      ; (count>0)
	BREQ done          ; done if count = 0
	BRNE after         ; loops if count > 0

output:
	call conversion
	sts PORTL, num1  	
	;out PORTB, num1
	call delay
	ret


conversion:
	mov num1, number
	ldi mask, 0b00000001
	;separating zero bit
	and num1, mask
	lsl num1  
	lsl mask
	;separating first bit
	mov num2, number
	and num2, mask
	lsl num2
	lsl num2
	lsl mask
	;separating second bit
	mov num3, number
	and num3, mask
	lsl num3
	lsl num3                        ;I could have done a loop but I ran out of time :(
	lsl num3
	lsl mask
	;separating third bit
	mov num4, number
	and num4, mask
	lsl num4
	lsl num4
	lsl num4
	lsl num4
	;putting all the bits together
	or num1, num2
	or num1, num3
	or num1, num4
	;roatating the number to little endian
	mov num2, num1
	ldi r18, 0b00001111
	ldi r21, 0b11110000
	and num1, r18
	lsl num1
	lsl num1
	lsl num1
	lsl num1
	and num2, r21 
	lsr num2
	lsr num2
	lsr num2
	lsr num2
	or num1, num2
	ret

delay:                 ;delay loop credits to LeAnne Jackson.
	ldi r24, 0x2A
	outer: ldi r23, 0xFF
	middle: ldi r22, 0xFF
	inner: dec r22
	brne inner
	dec r23
	brne middle
	dec r24
	brne outer     
	ret


done: rjmp done


.dseg 
.org 0x200
storage: .db 0x0A
