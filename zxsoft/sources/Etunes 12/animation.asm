;--------------------------------------------------------------------
; Описание: Анимация спрайта цифры 8
; Автор порта: Тарасов М.Н.(Mick),2010
;--------------------------------------------------------------------
Animation_init:
		xor	a
		ld	(Animation_step),a
		ld	(Animation_phase),a
Animation_view:
		ld	a,(Animation_step)
		inc	a
		and	03h
		ld	(Animation_step),a
		ret 	nz
		ld	a,(Animation_phase)
		inc	a	
		cp	1Eh
		jr	c,Animation_next_phase
		xor	a
Animation_next_phase:
		ld	(Animation_phase),a
		cp	08h
		jr	c,Animation_skip_page
		ld	bc,7ffdh
		ld	e,90h
		out	(c),e
Animation_skip_page:
		ld	l,a
		ld	c,a
		ld	h,0
		ld	b,h
		add	hl,hl
		add	hl,hl
		add	hl,bc
		ld	bc,Animation_table_phase
		add	hl,bc
		ld	b,(hl)       			;число строк
		inc	hl
		ld	e,(hl)				;адрес экрана
		inc	hl
		ld	d,(hl)				;адрес экрана
		inc	hl
		ld	a,(hl)				;адрес фазы
		inc	hl
		ld	h,(hl)				;адрес фазы
		ld	l,a
Animation_loop_Y:
		ld	c,32
		push	de
		ldi
		ldi
		ldi
		ldi
		ldi
		ldi
		ldi
		ldi
		ldi
		ldi

		ldi
		ldi
		ldi
		ldi
		ldi
		ldi
		ldi
		ldi
		ldi
		ldi

		ldi
		ldi
		ldi
		ldi
		ldi
		ldi
		ldi
		ldi
		ldi
		ldi

		ldi
		ldi

		pop	de
		inc	d
		ld	a,d
		and 	7
		jr	nz,Animation_next_line
		ld	a,e
		add	20h
		ld	e,a
		jr	c,Animation_next_line
		ld	a,d
		sub	8
		ld	d,a
Animation_next_line:
		dec	b
    		jp	nz,Animation_loop_Y
		ret	    

Animation_step:
		db	0
Animation_lstep:
		db	0
Animation_phase:
		db	0
Animation_lphase:
		db	0

Animation_table_phase:
		db	29
                dw	4B00h              	;+0
                dw	Animation_phase_00	
		db	29
                dw	4B00h              	;+0
                dw	Animation_phase_01	
		db	28
                dw	4C00h	           	;+1
                dw	Animation_phase_02	
		db	26
                dw	4E00h              	;+3
                dw	Animation_phase_03	
		db	23
                dw	4820h              	;+5
                dw	Animation_phase_04	
		db	19
                dw	4B20h              	;+8
                dw	Animation_phase_05	
		db	14
                dw	4E20h		   	;+11	
                dw	Animation_phase_06	
		db	9
                dw	4940h			;+14
                dw	Animation_phase_07	
		db	12
                dw	4840h			;+13
                dw	Animation_phase_08	
		db	16
                dw	4F20h			;+12
                dw	Animation_phase_09	
		db      21
                dw	4D20h			;+10
                dw	Animation_phase_10	
		db	24
                dw	4C20h			;+9
                dw	Animation_phase_11	
		db	26
                dw	4C20h			;+9
                dw	Animation_phase_12	
		db	28
                dw	4B20h			;+8
                dw	Animation_phase_13	
		db	29
                dw	4B20h			;+8
                dw	Animation_phase_14	
		db	29
                dw	4B20h			;+8
                dw	Animation_phase_15	
		db	29
                dw	4B20h			;+8
                dw	Animation_phase_16	
		db	28
                dw	4C20h			;+9
                dw	Animation_phase_17	
		db	27
                dw	4C20h			;+9
                dw	Animation_phase_18	
		db	25
                dw	4D20h			;+10
                dw	Animation_phase_19	
		db	20
                dw	4F20h			;+12
                dw	Animation_phase_20	
		db	16
                dw	4840h			;+13
                dw	Animation_phase_21	
		db	10
                dw	4A40h			;+15
                dw	Animation_phase_22	
		db	13
                dw	4E20h			;+11
                dw	Animation_phase_23	
		db	18
                dw	4A20h			;+7
                dw	Animation_phase_24	
		db	21
                dw	4F00h			;+4
                dw	Animation_phase_25	
		db	26
                dw	4D00h			;+2
                dw	Animation_phase_26	
		db	29
                dw	4B00h			;+0
                dw	Animation_phase_27	
		db	29
                dw	4B00h			;+0
                dw	Animation_phase_28	
		db	29
                dw	4B00h			;+0
                dw	Animation_phase_29	

Animation_phase_00:
		db	00h,00h,00h,0AAh,0A0h,02h,0A8h,00h,2Ah,02h,0A0h,0AAh,02h,00h,02h,20h,08h,00h,00h,00h,18h,08h,08h,00h,20h,0Ah,80h,00h,0F8h,18h,00h,00h
		db	00h,00h,00h,75h,57h,75h,5Ch,00h,15h,75h,57h,55h,03h,0D5h,5Fh,3Fh,7Ch,0Dh,00h,00h,3Fh,78h,1Fh,55h,7Fh,0D5h,40h,07h,0FEh,70h,00h,00h
		db	00h,00h,00h,0Ah,0AEh,0EEh,0AEh,00h,2Ah,0FAh,0AFh,0ABh,80h,0EAh,0BEh,0Fh,0F0h,0Ah,80h,00h,1Fh,0E0h,0Fh,0AAh,0BFh,0EAh,80h,3Ah,0FFh,0F8h,00h,00h
		db	00h,00h,00h,05h,57h,01h,5Eh,00h,15h,0E5h,56h,15h,80h,55h,50h,01h,0C0h,00h,40h,00h,03h,80h,03h,0D5h,41h,0F5h,40h,74h,1Fh,0F0h,00h,00h
		db	00h,00h,00h,0Ah,8Eh,03h,0AEh,00h,2Bh,0CAh,0AEh,2Bh,80h,2Ah,0B0h,00h,80h,00h,0C0h,00h,03h,80h,03h,0AAh,80h,0FAh,80h,0E8h,0Fh,0F8h,00h,00h
		db	00h,00h,00h,05h,05h,00h,0DEh,00h,17h,85h,56h,15h,80h,55h,70h,01h,00h,00h,60h,00h,03h,80h,01h,0D5h,40h,7Dh,41h,0D4h,07h,0F8h,00h,00h
		db	00h,00h,00h,08h,0Fh,80h,2Eh,00h,2Fh,0Ah,0AEh,0Bh,80h,2Ah,0B0h,01h,80h,00h,78h,00h,03h,80h,01h,0AAh,80h,3Eh,83h,0EAh,03h,0E8h,00h,00h
		db	00h,00h,00h,04h,57h,10h,5Eh,00h,17h,05h,56h,05h,80h,55h,70h,01h,00h,00h,7Ch,00h,03h,80h,01h,0D5h,41h,3Fh,43h,0D5h,01h,0F8h,00h,00h
		db	00h,00h,00h,08h,0AFh,9Eh,2Eh,00h,2Eh,0Ah,0AEh,0Bh,80h,2Ah,0B0h,01h,80h,00h,7Eh,00h,03h,80h,01h,0AAh,87h,1Eh,87h,0AAh,0E1h,0F8h,00h,00h
		db	00h,00h,00h,01h,57h,1Eh,0Eh,00h,1Eh,05h,56h,01h,80h,55h,70h,01h,00h,00h,6Fh,40h,03h,80h,01h,0D5h,47h,0Fh,47h,0D5h,5Dh,0F8h,00h,00h
		db	00h,00h,00h,02h,0AFh,0BEh,0Eh,00h,3Eh,0Ah,0AEh,03h,80h,2Ah,0B0h,01h,80h,00h,66h,0A0h,03h,80h,01h,0AAh,87h,0Fh,83h,0AAh,0AAh,0F8h,00h,00h
		db	00h,00h,00h,05h,57h,3Eh,06h,00h,3Ch,05h,56h,03h,80h,55h,70h,01h,00h,00h,67h,50h,03h,80h,01h,0D5h,47h,07h,87h,0D5h,55h,0C0h,00h,00h
		db	00h,00h,00h,0Ah,0AFh,0BEh,02h,00h,38h,0Ah,0AEh,01h,80h,2Ah,0B0h,01h,80h,00h,63h,0AAh,03h,80h,01h,0AAh,8Eh,02h,07h,0EAh,0ABh,0F0h,00h,00h
		db	00h,00h,00h,05h,57h,0DEh,00h,00h,10h,05h,56h,00h,00h,55h,70h,01h,00h,00h,61h,0D5h,03h,80h,01h,0D5h,5Dh,00h,03h,0D5h,55h,0F8h,00h,00h
		db	00h,00h,00h,0Ah,0AFh,0BEh,00h,00h,00h,0Ah,0AEh,00h,00h,2Ah,0B0h,01h,80h,00h,60h,0EAh,83h,80h,01h,0AAh,0BEh,00h,03h,0EAh,0AAh,0F8h,00h,00h
		db	00h,00h,00h,05h,57h,5Eh,00h,00h,00h,05h,56h,00h,00h,55h,70h,01h,00h,00h,60h,75h,53h,80h,01h,0D5h,1Ch,00h,07h,0FDh,55h,0FCh,00h,00h
		db	00h,00h,00h,0Ah,0AFh,0BEh,06h,08h,2Eh,0Ah,0AEh,00h,00h,2Ah,0B0h,01h,80h,00h,60h,3Ah,0ABh,80h,01h,0AAh,0Ah,00h,0C7h,0FEh,0AAh,0FEh,00h,00h
		db	00h,00h,00h,05h,57h,1Eh,17h,05h,07h,05h,56h,00h,00h,55h,70h,01h,00h,00h,60h,3Dh,55h,80h,01h,0D4h,07h,01h,07h,0FFh,0D5h,0FEh,00h,00h
		db	00h,00h,00h,0Ah,0AFh,9Eh,0Fh,0Ah,0A2h,0Ah,0AEh,00h,00h,2Ah,0B0h,01h,80h,00h,60h,1Eh,0AAh,80h,01h,0A8h,07h,83h,87h,8Fh,0FAh,0FEh,00h,00h
		db	00h,00h,00h,05h,57h,1Eh,17h,05h,54h,05h,56h,00h,00h,55h,70h,01h,00h,00h,60h,0Dh,55h,80h,00h,0C0h,07h,87h,07h,0C1h,0FDh,7Fh,00h,00h
		db	00h,00h,00h,0Ah,0AFh,8Eh,2Fh,0Ah,0AEh,02h,0AEh,00h,00h,2Ah,0B0h,00h,80h,00h,60h,0Eh,0AAh,80h,00h,00h,83h,8Fh,83h,0A0h,7Fh,0FEh,00h,00h
		db	00h,00h,00h,05h,57h,00h,57h,0Fh,0FFh,01h,56h,00h,00h,15h,70h,01h,00h,00h,60h,07h,55h,80h,01h,05h,40h,0Fh,45h,00h,1Fh,0FEh,00h,00h
		db	00h,00h,00h,0Ah,0AFh,80h,6Fh,03h,0FEh,02h,0AEh,00h,00h,2Ah,0B0h,01h,00h,00h,60h,03h,0AAh,80h,01h,8Ah,80h,1Eh,82h,00h,0Fh,0FEh,00h,00h
		db	00h,00h,00h,05h,57h,00h,57h,00h,00h,01h,56h,00h,00h,15h,50h,01h,00h,00h,40h,01h,0D5h,80h,01h,95h,40h,1Dh,47h,00h,07h,0FCh,00h,00h
		db	00h,00h,00h,0Ah,0AFh,80h,0AFh,00h,00h,08h,0AEh,00h,00h,1Ah,0B0h,02h,00h,00h,60h,00h,0EAh,80h,01h,0AAh,80h,3Ah,87h,0F8h,03h,0F8h,00h,00h
		db	00h,00h,00h,05h,57h,01h,57h,00h,00h,01h,56h,00h,00h,05h,50h,06h,00h,00h,40h,00h,75h,80h,01h,0D5h,40h,75h,47h,0FCh,07h,0F0h,00h,00h
		db	00h,00h,00h,1Ah,0AFh,82h,0AFh,00h,00h,08h,0AEh,00h,00h,02h,0A8h,0Ch,00h,00h,0A0h,00h,7Ah,80h,03h,0AAh,80h,0EAh,87h,0BEh,07h,0E0h,00h,00h
		db	00h,00h,00h,7Fh,0FFh,0FFh,0F7h,00h,00h,71h,55h,40h,00h,01h,0D5h,0F0h,00h,07h,54h,00h,3Fh,80h,0Fh,55h,0FFh,0FFh,0C7h,87h,0C6h,00h,00h,00h
		db	00h,00h,00h,3Fh,0FFh,0FFh,0FFh,00h,00h,7Fh,0FFh,0E0h,00h,00h,3Fh,0E0h,00h,0Fh,0FEh,00h,1Eh,00h,1Fh,0FFh,0FFh,0FEh,06h,80h,0F0h,00h,00h,00h

Animation_phase_01:
		db	00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
		db	00h,00h,00h,17h,0F0h,00h,00h,00h,00h,00h,00h,00h,01h,0FFh,0FFh,1Fh,0F8h,00h,00h,00h,07h,0F0h,17h,0F0h,00h,00h,00h,05h,40h,00h,00h,00h
		db	00h,00h,00h,0Fh,0FFh,0FFh,0FFh,00h,0Ah,0BEh,0ABh,0EAh,81h,0EAh,0AFh,1Eh,0FCh,0Ah,00h,00h,3Eh,0F0h,3Eh,0AAh,0FEh,0FEh,00h,3Fh,0FBh,80h,00h,00h
		db	00h,00h,00h,03h,0FFh,0FFh,0FFh,0C0h,15h,7Dh,57h,0F5h,0C1h,0F5h,5Fh,1Fh,0F8h,1Fh,00h,00h,7Fh,0E0h,7Fh,55h,0FFh,0FEh,00h,7Fh,0FFh,0C0h,00h,00h
		db	00h,00h,00h,03h,0FFh,0FFh,0FFh,80h,0Ah,0FAh,0ABh,0EAh,0C0h,6Ah,0BEh,0Fh,0E0h,0Fh,80h,00h,3Fh,80h,2Fh,0AAh,0FFh,0FEh,00h,0E3h,0FFh,0C0h,00h,00h
		db	00h,00h,00h,01h,0FFh,0E0h,7Fh,80h,05h,0F1h,57h,15h,0C0h,35h,50h,01h,80h,01h,0C0h,00h,07h,00h,07h,55h,07h,0FFh,03h,0F0h,7Fh,0C0h,00h,00h
		db	00h,00h,00h,03h,0FFh,0E0h,3Fh,80h,1Bh,0E6h,0ABh,0Ah,0C0h,2Ah,0B0h,01h,80h,00h,0E0h,00h,07h,00h,07h,0AAh,81h,0FEh,07h,0F8h,3Fh,0E0h,00h,00h
		db	00h,00h,00h,03h,0FDh,0C0h,1Fh,80h,17h,0C5h,57h,05h,0C0h,35h,50h,01h,00h,00h,60h,00h,07h,00h,07h,55h,80h,0FFh,0Fh,0FCh,1Fh,0E0h,00h,00h
		db	00h,00h,00h,03h,0FFh,0EEh,1Fh,80h,0Fh,82h,0ABh,06h,0C0h,2Ah,0B0h,01h,80h,00h,0FAh,00h,03h,00h,03h,0AAh,86h,0FFh,0Fh,0FEh,8Fh,0E0h,00h,00h
		db	00h,00h,00h,07h,0FFh,0EFh,0Fh,80h,1Fh,05h,57h,01h,80h,35h,50h,01h,00h,00h,0DDh,40h,03h,00h,01h,55h,0Eh,7Fh,0Fh,0FFh,0F7h,0F0h,00h,00h
		db	00h,00h,00h,03h,0FFh,0CFh,0Fh,80h,2Fh,02h,0AFh,03h,80h,2Ah,0B0h,01h,80h,00h,0CEh,0A0h,02h,00h,03h,0AAh,8Eh,3Eh,0Fh,0FFh,0FFh,0E0h,00h,00h
		db	00h,00h,00h,07h,0FFh,0DFh,07h,00h,1Eh,05h,57h,01h,80h,15h,50h,01h,00h,00h,0C7h,54h,01h,00h,01h,55h,4Fh,1Fh,0Fh,7Fh,0FFh,80h,00h,00h
		db	00h,00h,00h,07h,0FBh,0FFh,03h,00h,1Eh,0Ah,0AFh,01h,80h,2Ah,0B0h,01h,80h,00h,0C3h,0AAh,03h,80h,03h,0Ah,8Eh,0Eh,0Fh,0FFh,0FFh,0E0h,00h,00h
		db	00h,00h,00h,07h,0FFh,0FFh,01h,00h,1Ch,05h,57h,00h,80h,15h,70h,01h,00h,00h,0C3h,0D5h,03h,00h,03h,05h,5Dh,04h,0Fh,0FFh,0FFh,0F0h,00h,00h
		db	00h,00h,00h,0Fh,0FFh,0FFh,00h,00h,00h,02h,0AEh,00h,00h,2Ah,0B0h,00h,00h,00h,0C1h,0EAh,03h,00h,03h,80h,0FEh,00h,07h,0FFh,0FFh,0F8h,00h,00h
		db	00h,00h,00h,07h,0FFh,0DFh,00h,05h,54h,05h,56h,00h,00h,15h,70h,00h,00h,00h,40h,0F4h,13h,00h,03h,0D0h,17h,00h,03h,0FFh,0FFh,0FCh,00h,00h
		db	00h,00h,00h,0Fh,0FFh,0AFh,0Eh,0Ah,0AEh,0Ah,0AEh,00h,00h,2Ah,0B0h,00h,00h,00h,40h,7Ah,2Bh,80h,03h,0A8h,02h,00h,8Fh,0FFh,0FFh,0FEh,00h,00h
		db	00h,00h,00h,0Fh,0F7h,9Eh,07h,15h,57h,0Dh,56h,00h,00h,55h,70h,01h,00h,00h,40h,3Ch,55h,00h,03h,0D5h,40h,03h,0C7h,0FFh,0FFh,0FEh,00h,00h
		db	00h,00h,00h,0Fh,0FFh,9Eh,1Fh,0Ah,0AFh,0Ah,0AEh,00h,00h,2Ah,0B0h,00h,80h,00h,60h,1Eh,2Ah,80h,03h,0AAh,86h,03h,87h,0FFh,0FFh,0FEh,00h,00h
		db	00h,00h,00h,1Fh,0FFh,1Eh,1Fh,05h,57h,05h,56h,00h,00h,55h,70h,01h,80h,00h,40h,1Eh,55h,80h,01h,0D5h,47h,07h,0C7h,0E7h,0FFh,0FFh,00h,00h
		db	00h,00h,00h,0Fh,0FFh,8Eh,2Fh,1Ah,0AFh,0Ah,0AEh,00h,00h,2Ah,0B0h,00h,80h,00h,60h,0Fh,2Ah,80h,01h,0EAh,0A3h,82h,0A7h,0B0h,0FFh,0FEh,00h,00h
		db	00h,00h,00h,1Fh,0FFh,02h,5Fh,1Fh,0FFh,15h,5Eh,00h,00h,15h,70h,01h,00h,00h,40h,07h,55h,00h,01h,0D5h,42h,04h,07h,0F0h,1Fh,0DFh,00h,00h
		db	00h,00h,00h,1Fh,0FFh,00h,0AFh,07h,0FEh,0Ah,0AEh,00h,00h,2Ah,0B0h,03h,00h,00h,60h,02h,0AAh,80h,01h,0EAh,80h,0Ch,03h,0F8h,0Fh,0FEh,00h,00h
		db	00h,00h,00h,1Fh,0FFh,01h,5Fh,00h,00h,05h,5Eh,00h,00h,15h,50h,01h,00h,00h,40h,01h,0D5h,00h,01h,0D5h,60h,1Dh,07h,0FCh,03h,0FEh,00h,00h
		db	00h,00h,00h,3Fh,0EFh,06h,0AEh,00h,00h,0Ah,0AEh,00h,00h,1Ah,0A0h,02h,00h,00h,60h,00h,0EAh,80h,01h,0EAh,0A0h,3Ah,83h,0FFh,03h,0FCh,00h,00h
		db	00h,00h,00h,1Fh,0FFh,0Dh,5Eh,00h,00h,15h,5Eh,00h,00h,0Dh,50h,06h,00h,00h,40h,00h,75h,40h,01h,0D5h,40h,3Dh,41h,0FFh,83h,0F8h,00h,00h
		db	00h,00h,00h,0FFh,0FEh,0EAh,0BEh,00h,00h,0AAh,0AEh,00h,00h,07h,0AAh,0BCh,00h,02h,0A8h,00h,3Ah,80h,01h,0AAh,0A0h,0EAh,0A2h,4Fh,0EBh,0E0h,00h,00h
		db	00h,00h,01h,0FFh,0FFh,0FFh,0FEh,00h,01h,0FFh,0FFh,0C0h,00h,01h,0FFh,0F8h,00h,0Fh,0FFh,00h,1Fh,80h,0Fh,0FFh,0FFh,0FFh,0C1h,07h,0FFh,80h,00h,00h
		db	00h,00h,00h,7Fh,0FFh,0FFh,0FEh,00h,00h,0FFh,0FFh,0E0h,00h,00h,3Fh,0E0h,00h,0Fh,0E6h,00h,0Fh,00h,0Fh,0FFh,0FFh,0FFh,82h,00h,0FEh,00h,00h,00h

Animation_phase_02:
		db	00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
		db	00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
		db	00h,00h,00h,03h,0FFh,0FFh,0FFh,0C0h,07h,0FFh,0FFh,0FFh,0C1h,0FFh,0F7h,1Dh,0D8h,1Ch,00h,00h,77h,0E0h,7Fh,0FFh,0FFh,0F0h,00h,7Fh,04h,00h,00h,00h
		db	00h,00h,00h,01h,0FFh,0FFh,0FFh,0C0h,03h,0FFh,0FFh,0FFh,0C0h,0FFh,0FFh,1Fh,0F8h,1Eh,00h,00h,0FFh,0E0h,0FFh,0FFh,0FFh,0F8h,00h,0FFh,0EEh,00h,00h,00h
		db	00h,00h,00h,00h,0FFh,0FFh,0FFh,0E0h,07h,0FFh,0FFh,0FFh,0C0h,0FFh,0FFh,1Fh,0F8h,1Fh,80h,00h,0FFh,0C0h,0FFh,0FFh,0FFh,0F8h,03h,0FFh,0FFh,00h,00h,00h
		db	00h,00h,00h,00h,0FFh,0FEh,0BFh,0E0h,07h,0FFh,0FFh,0BFh,0E0h,3Fh,0FAh,03h,0F0h,0Bh,0C0h,00h,7Eh,00h,7Fh,0FEh,0FFh,0F8h,07h,9Fh,0FEh,00h,00h,00h
		db	00h,00h,00h,00h,0FFh,0F8h,0Fh,0E0h,07h,0F9h,0FFh,8Fh,0C0h,1Fh,0F0h,01h,0C0h,01h,0E0h,00h,0Eh,00h,0Fh,0FEh,1Fh,0FCh,0Fh,0E7h,0FFh,00h,00h,00h
		db	00h,00h,00h,00h,0FFh,0FAh,0Fh,0E0h,0Fh,0F3h,0FFh,87h,0C0h,3Fh,0F0h,01h,80h,00h,0F8h,00h,0Eh,00h,0Fh,0FEh,07h,0FCh,1Fh,0F8h,0FFh,80h,00h,00h
		db	00h,00h,00h,01h,0FFh,0F3h,07h,0C0h,0Fh,0E3h,0FFh,87h,0C0h,1Fh,0F0h,01h,00h,00h,0FFh,00h,07h,00h,0Fh,0FFh,0Dh,0FCh,3Fh,0FFh,3Fh,80h,00h,00h
		db	00h,00h,00h,01h,0FFh,0F3h,87h,0C0h,0Fh,0C3h,0FFh,83h,0C0h,3Fh,0F0h,01h,80h,00h,0BFh,80h,06h,00h,0Fh,0FFh,1Ch,0FEh,3Fh,0FFh,0FFh,80h,00h,00h
		db	00h,00h,00h,01h,0FFh,0F7h,83h,0C0h,1Fh,87h,0FFh,01h,0C0h,1Fh,0F0h,01h,00h,00h,0DFh,0F0h,07h,00h,07h,0FFh,1Ch,7Eh,3Fh,0FFh,0FFh,80h,00h,00h
		db	00h,00h,00h,03h,0FFh,0FFh,83h,80h,1Fh,07h,0FFh,01h,0C0h,3Fh,0F0h,01h,80h,00h,0CFh,0FEh,07h,00h,07h,0FFh,9Eh,3Eh,1Fh,0FFh,0FFh,80h,00h,00h
		db	00h,00h,00h,07h,0FFh,0FFh,81h,80h,0Eh,07h,0FFh,01h,0C0h,3Fh,0F0h,01h,00h,00h,0C7h,0FFh,07h,00h,07h,0FFh,0DEh,1Ch,1Fh,0FFh,0FFh,0E0h,00h,00h
		db	00h,00h,00h,03h,0FFh,0FFh,80h,80h,04h,07h,0FFh,00h,0C0h,3Fh,0F0h,01h,80h,00h,0C3h,0FFh,0E3h,80h,07h,0FFh,0FEh,08h,0Fh,0FFh,0FFh,0F0h,00h,00h
		db	00h,00h,00h,07h,0FFh,0FFh,04h,0Fh,0FCh,07h,0FFh,00h,00h,3Fh,0F0h,01h,00h,00h,0C1h,0FFh,0F3h,00h,03h,0FFh,0FFh,00h,47h,0FFh,0FFh,0FCh,00h,00h
		db	00h,00h,00h,0Fh,0FFh,0FFh,0Eh,0Fh,0FEh,0Fh,0FFh,00h,00h,3Eh,0B0h,01h,80h,00h,0C0h,0FFh,0FFh,80h,03h,0FFh,0FFh,00h,87h,0FFh,0FFh,0FCh,00h,00h
		db	00h,00h,00h,0Ch,07h,0DFh,1Fh,1Fh,0FFh,0Fh,0FEh,00h,00h,55h,70h,01h,00h,00h,40h,7Fh,0FFh,00h,03h,0FFh,0DFh,01h,0C7h,0FFh,0FFh,0FEh,00h,00h
		db	00h,00h,00h,00h,23h,8Eh,3Fh,0Fh,0FFh,0Fh,0FEh,00h,00h,2Ah,0B0h,00h,80h,00h,60h,3Fh,0FFh,80h,03h,0FFh,0CFh,83h,0EFh,0FFh,0FFh,0FEh,00h,00h
		db	00h,00h,00h,07h,0FFh,04h,3Fh,1Fh,0FFh,0Fh,0FEh,00h,00h,55h,70h,01h,80h,00h,40h,1Fh,0FFh,80h,01h,0FFh,0C7h,0C7h,0C7h,0FFh,0FFh,0FFh,00h,00h
		db	00h,00h,00h,1Fh,0FFh,8Ah,0FFh,1Fh,0FFh,0Fh,0FEh,00h,00h,2Ah,0B0h,00h,80h,00h,60h,0Fh,0BFh,80h,01h,0FFh,0E3h,07h,0E3h,0F9h,0FFh,0FFh,00h,00h
		db	00h,00h,00h,1Fh,0FFh,01h,0FFh,0Fh,0FFh,1Fh,0FEh,00h,00h,35h,60h,01h,00h,00h,40h,07h,0D5h,0C0h,01h,0FFh,0E0h,07h,0F7h,0FCh,1Fh,0FFh,00h,00h
		db	00h,00h,00h,3Fh,0FEh,03h,0FEh,0Fh,0FEh,1Fh,8Eh,00h,00h,2Ah,0A0h,03h,00h,00h,60h,03h,0EAh,80h,01h,0FFh,0E0h,0Fh,0E3h,0FEh,07h,0FFh,00h,00h
		db	00h,00h,00h,7Fh,0FFh,05h,0FEh,00h,00h,1Fh,7Ch,00h,00h,35h,50h,07h,00h,00h,60h,01h,0F5h,40h,01h,0FFh,0F0h,0Fh,0F1h,0FFh,81h,0FEh,00h,00h
		db	00h,00h,00h,0FFh,0FEh,38h,0FEh,00h,00h,3Fh,0ECh,00h,00h,1Eh,0A8h,0Eh,00h,00h,60h,00h,0FAh,0C0h,00h,0FFh,0F0h,1Fh,0F1h,0FFh,0E1h,0FCh,00h,00h
		db	00h,00h,05h,0FFh,0FFh,0FCh,7Ch,00h,01h,0FFh,54h,00h,00h,0Fh,0D5h,1Eh,00h,05h,5Ch,00h,7Dh,40h,00h,0FFh,0F7h,0FFh,0F1h,0FFh,0FDh,0FCh,00h,00h
		db	00h,00h,07h,0FFh,0FFh,0FFh,0FCh,00h,03h,0FFh,0FFh,80h,00h,07h,0FFh,0FCh,00h,0Fh,0FFh,00h,3Fh,0C0h,03h,0FFh,0FFh,0FFh,0F0h,0E3h,0FFh,0E0h,00h,00h
		db	00h,00h,01h,0FFh,0FFh,0FFh,0DCh,00h,01h,0F7h,0FDh,0C0h,00h,01h,0FFh,0F0h,00h,07h,0FFh,00h,1Fh,80h,07h,0FFh,0FFh,0FFh,0C0h,0C1h,0FFh,0C0h,00h,00h
		db	00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,2Ah,0C0h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,80h,2Eh,00h,00h,00h

Animation_phase_03:
		db	00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
		db	00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
		db	00h,00h,00h,00h,55h,55h,55h,40h,01h,54h,55h,10h,00h,55h,55h,15h,40h,14h,00h,00h,15h,40h,15h,51h,55h,40h,01h,0F0h,00h,00h,00h,00h
		db	00h,00h,00h,00h,7Fh,0FFh,0FFh,0F0h,01h,0FFh,0FFh,0FFh,0E0h,0FFh,0FFh,9Fh,0F8h,1Fh,00h,00h,0FFh,80h,0FFh,0FFh,0FFh,0E0h,0Fh,0FFh,0B0h,00h,00h,00h
		db	00h,00h,00h,00h,3Fh,0FFh,0FFh,0F0h,01h,0FFh,0FFh,0FFh,0E0h,7Fh,0FFh,1Fh,0F8h,1Fh,00h,01h,0FFh,81h,0FFh,0FFh,0FFh,0F0h,0Fh,0FFh,0F8h,00h,00h,00h
		db	00h,00h,00h,00h,3Fh,0FFh,0FFh,0F8h,03h,0FFh,0FFh,0FFh,0E0h,7Fh,0BFh,9Fh,0F8h,1Fh,0C0h,00h,0FFh,83h,0FFh,0FFh,0FFh,0F0h,1Fh,0FFh,0FCh,00h,00h,00h
		db	00h,00h,00h,00h,3Fh,0FEh,0Fh,0F8h,07h,0FFh,0FFh,0CFh,0E0h,1Fh,1Ch,01h,0C0h,07h,0F8h,00h,3Ch,00h,7Fh,0FDh,7Fh,0F8h,3Fh,0FFh,0FEh,00h,00h,00h
		db	00h,00h,00h,00h,7Fh,0FFh,83h,0F0h,07h,0FFh,0FFh,0C7h,0E0h,1Fh,00h,01h,80h,01h,0FEh,00h,0Eh,00h,1Fh,0FEh,1Fh,0F8h,3Fh,0FFh,0FFh,00h,00h,00h
		db	00h,00h,00h,00h,0FFh,0FFh,0C1h,0F0h,07h,0F1h,0FFh,0C3h,0E0h,1Ch,50h,01h,00h,00h,0FFh,0C0h,0Eh,00h,1Fh,0FFh,1Fh,0FCh,7Fh,0FFh,0FFh,00h,00h,00h
		db	00h,00h,00h,00h,0FFh,0FFh,0E1h,0E0h,0Fh,0E3h,0FFh,81h,0E0h,3Dh,0E0h,01h,80h,00h,0BFh,0F8h,0Eh,00h,0Fh,0FFh,3Fh,0FCh,7Fh,0FFh,0FEh,00h,00h,00h
		db	00h,00h,00h,01h,0FFh,0FFh,0C1h,0E0h,0Fh,0C7h,0FFh,81h,0C0h,1Dh,0D0h,01h,00h,00h,0DFh,0FEh,07h,00h,0Fh,0FFh,3Ch,0FCh,7Fh,0FFh,0FFh,80h,00h,00h
		db	00h,00h,00h,03h,0FFh,0FFh,0C0h,0C0h,0Fh,07h,0FFh,80h,0C0h,0Ah,0F0h,01h,80h,00h,0CFh,0FFh,0E7h,00h,0Fh,0FFh,0FEh,38h,3Fh,0FFh,0FFh,0E0h,00h,00h
		db	00h,00h,00h,04h,07h,0FFh,80h,47h,0FFh,07h,0FFh,00h,40h,30h,0F0h,01h,00h,00h,0C3h,0FFh,0FFh,00h,07h,0FFh,0FFh,10h,1Fh,0FFh,0FFh,0FCh,00h,00h
		db	00h,00h,00h,00h,03h,0FFh,86h,0Fh,0FEh,0Fh,0FFh,00h,00h,30h,0F0h,01h,80h,00h,0C1h,0FFh,0FFh,80h,07h,0FFh,0FFh,00h,8Fh,0FFh,0FFh,0FCh,00h,00h
		db	00h,00h,00h,01h,51h,0DFh,1Fh,1Fh,0FFh,0Fh,0FFh,00h,00h,4Eh,70h,01h,00h,00h,0C0h,0FFh,0FFh,80h,03h,0FFh,0FFh,01h,0CFh,0FFh,0FFh,0FFh,00h,00h
		db	00h,00h,00h,1Fh,0FEh,9Fh,3Fh,9Fh,0FFh,0Fh,0FEh,00h,00h,2Eh,30h,00h,80h,00h,0E0h,3Fh,0FFh,80h,03h,0FFh,0FFh,83h,0EFh,0FFh,0FFh,0FFh,00h,00h
		db	00h,00h,00h,1Fh,0FFh,1Fh,7Fh,1Fh,0FFh,1Fh,0FEh,00h,00h,58h,10h,01h,80h,00h,40h,1Fh,0FFh,80h,03h,0FFh,0EFh,87h,0E7h,0FFh,0FFh,0FFh,00h,00h
		db	00h,00h,00h,3Fh,0FFh,0Fh,0FFh,1Fh,0FFh,1Fh,0FEh,00h,00h,3Eh,0E0h,03h,80h,00h,60h,0Fh,0FFh,80h,01h,0FFh,0E7h,07h,0F3h,0FFh,0FFh,0FFh,80h,00h
		db	00h,00h,00h,7Fh,0FFh,07h,0FEh,0Fh,0FEh,1Fh,0FEh,00h,00h,3Dh,0E0h,03h,00h,00h,60h,07h,0FFh,0C0h,01h,0FFh,0F1h,07h,0F3h,0FFh,1Fh,0FFh,00h,00h
		db	00h,00h,00h,0FFh,0FEh,03h,0FEh,0Fh,0FEh,3Fh,0FCh,00h,00h,33h,0F0h,03h,00h,00h,60h,03h,0FFh,0C0h,00h,0FFh,0F0h,07h,0FBh,0FFh,0E3h,0FFh,00h,00h
		db	00h,00h,05h,0FFh,0FFh,61h,0FCh,00h,01h,7Fh,0FCh,00h,00h,1Fh,0FCh,5Fh,00h,01h,7Ch,00h,0FFh,0C0h,00h,0FFh,0FFh,0DFh,0FDh,0FFh,0F9h,0FFh,00h,00h
		db	00h,00h,1Fh,0FFh,0FFh,0F1h,0FCh,00h,02h,3Fh,0FFh,00h,00h,1Fh,0FFh,0FEh,00h,07h,0FFh,00h,7Fh,0E0h,01h,0FFh,0FFh,0FFh,0F8h,0FFh,0FFh,0FCh,00h,00h
		db	00h,00h,0Fh,0FFh,0FFh,0F8h,0F8h,00h,00h,1Fh,0FFh,00h,00h,0Fh,0FFh,0FEh,00h,07h,0FFh,00h,3Fh,0C0h,03h,0FFh,0FFh,0FFh,0F8h,0F7h,0FFh,0F8h,00h,00h
		db	00h,00h,07h,0FFh,0FFh,0FCh,38h,00h,03h,8Fh,0FFh,80h,00h,03h,0FFh,0F8h,00h,0Fh,0FFh,00h,0Fh,0C0h,03h,0FFh,0FFh,0FFh,0F0h,60h,0FFh,0F0h,00h,00h
		db	00h,00h,00h,00h,00h,00h,00h,00h,01h,0F7h,0FFh,80h,00h,00h,15h,40h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,40h,15h,40h,00h,00h
		db	00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h

Animation_phase_04:
		db	00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
		db	00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
		db	00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
		db	00h,00h,00h,00h,1Fh,0FFh,0FFh,0E8h,00h,0FFh,0FFh,0FFh,0E0h,7Fh,0FFh,9Fh,0E8h,1Eh,00h,00h,0BFh,82h,0BFh,0FBh,0FFh,80h,0Fh,0F0h,80h,00h,00h,00h
		db	00h,00h,00h,00h,1Fh,0FFh,0FFh,0F8h,01h,0FFh,0FFh,0FFh,0F0h,7Fh,0FFh,1Fh,0F8h,1Fh,80h,01h,0FFh,01h,0FFh,0FFh,0FFh,0C0h,3Fh,0D5h,0E0h,00h,00h,00h
		db	00h,00h,00h,00h,0Fh,0FFh,0FFh,0F8h,01h,0FFh,0FFh,0FFh,0F0h,7Fh,0FFh,9Fh,0F8h,3Fh,0C0h,01h,0FFh,83h,0FFh,0FFh,0FFh,0E0h,3Fh,0EBh,0F0h,00h,00h,00h
		db	00h,00h,00h,00h,1Fh,0FFh,0FFh,0FCh,03h,0FFh,0FFh,0FFh,0F0h,7Fh,0FFh,1Fh,0F8h,1Fh,0FCh,01h,0FFh,03h,0FFh,0FFh,0FFh,0F0h,7Fh,0F7h,0FCh,00h,00h,00h
		db	00h,00h,00h,00h,7Fh,0FFh,0C3h,0FCh,07h,0FFh,0FFh,0E7h,0F0h,1Fh,0F8h,01h,80h,03h,0FFh,0C0h,3Eh,00h,7Fh,0FEh,0FFh,0F8h,0FFh,0FFh,0FEh,00h,00h,00h
		db	00h,00h,00h,00h,7Fh,0FFh,0E1h,0F8h,07h,0FDh,0FFh,0C3h,0E0h,1Fh,0F8h,01h,00h,01h,0FFh,0F4h,1Eh,00h,3Fh,0FEh,3Fh,0FCh,0FFh,0FFh,0FCh,00h,00h,00h
		db	00h,00h,00h,01h,0FFh,0FFh,0E0h,0F0h,02h,0F3h,0FFh,0C1h,0E0h,3Fh,0F0h,01h,80h,00h,0FFh,0FFh,8Eh,00h,1Fh,0FFh,0FFh,0F8h,0FFh,0FFh,0FFh,80h,00h,00h
		db	00h,00h,00h,07h,0FFh,0FFh,0E0h,65h,54h,47h,0FFh,80h,0C0h,3Fh,0F0h,01h,00h,00h,0DFh,0FFh,0FFh,00h,0Fh,0FFh,0FFh,0F0h,7Fh,0DFh,0FFh,0F0h,00h,00h
		db	00h,00h,00h,07h,0FFh,0FFh,0E6h,6Fh,0FFh,83h,0BFh,80h,0C0h,3Fh,0F0h,01h,80h,00h,0C7h,0FFh,0FFh,00h,0Fh,0FFh,0FFh,31h,0FFh,0BBh,0FFh,0FCh,00h,00h
		db	00h,00h,00h,0Fh,0FFh,0FFh,0DFh,1Fh,0FFh,0Fh,0D7h,00h,40h,7Fh,0F0h,01h,80h,00h,0C3h,0FFh,0FFh,80h,07h,0FFh,0FFh,81h,0DFh,0FFh,0F7h,0FEh,00h,00h
		db	00h,00h,00h,3Fh,0FFh,0FFh,0FFh,0BFh,0FFh,1Fh,0FFh,00h,00h,3Fh,0F0h,01h,80h,00h,0E0h,0FFh,0FFh,80h,03h,0FFh,0FFh,83h,0EFh,0FFh,0FFh,0BFh,80h,00h
		db	00h,00h,00h,3Fh,0FFh,0DFh,0FFh,9Fh,0FFh,1Fh,0FFh,00h,00h,7Fh,0F0h,01h,80h,00h,40h,3Fh,0FFh,0C0h,03h,0FFh,0FFh,83h,0FFh,0FFh,0FFh,7Fh,80h,00h
		db	00h,00h,00h,0FFh,0FFh,9Fh,0FFh,0Fh,0FFh,3Fh,0FEh,00h,00h,3Fh,0F0h,03h,80h,00h,60h,1Fh,0FFh,0E0h,01h,0FFh,0FFh,83h,0FFh,0FEh,0FFh,0FFh,80h,00h
		db	00h,00h,07h,0FFh,0FFh,0FFh,0FEh,0Fh,0FFh,7Fh,0FCh,00h,00h,3Fh,0FCh,0Fh,00h,01h,74h,07h,0FFh,0E0h,01h,0FFh,0FFh,0F7h,0FFh,0FFh,0F5h,0FFh,80h,00h
		db	00h,00h,3Fh,0FFh,0FFh,0FFh,0FEh,0Fh,0FFh,0FFh,0FAh,00h,00h,3Fh,0BFh,0BFh,00h,02h,0AAh,81h,0FFh,0E0h,00h,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,00h,00h
		db	00h,00h,1Fh,0FFh,0FFh,0FFh,0FCh,00h,07h,0FFh,0FFh,00h,00h,3Fh,0FFh,0FFh,00h,07h,0FFh,00h,7Fh,0E0h,01h,0FFh,0FFh,0FFh,0FCh,0FFh,0FFh,0FEh,00h,00h
		db	00h,00h,1Fh,0FFh,0FFh,0FFh,0F8h,00h,07h,0FFh,0FFh,00h,00h,0Fh,0FFh,0FEh,00h,07h,0FFh,00h,3Fh,0E0h,03h,0FFh,0FFh,0FFh,0F8h,7Bh,0FFh,0FEh,00h,00h
		db	00h,00h,0Fh,0FFh,0FFh,0FFh,0F0h,00h,07h,0FFh,0FFh,00h,00h,07h,0FFh,0F8h,00h,07h,0FFh,00h,0Fh,0C0h,01h,0FFh,0FFh,0FFh,0F8h,30h,7Fh,0FCh,00h,00h
		db	00h,00h,07h,0FFh,0FFh,80h,00h,00h,03h,0FFh,0FFh,80h,00h,00h,2Ah,80h,00h,07h,0FEh,00h,00h,00h,03h,0FFh,0FFh,0E0h,00h,00h,06h,0A0h,00h,00h
		db	00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h

Animation_phase_05:
		db	00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
		db	00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
		db	00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
		db	00h,00h,00h,00h,07h,0FFh,0FFh,0FCh,00h,7Ch,7Fh,0FFh,0F0h,7Fh,0DCh,07h,0D0h,1Fh,00h,01h,7Fh,01h,7Fh,0F5h,0FFh,00h,7Fh,77h,00h,00h,00h,00h
		db	00h,00h,00h,00h,07h,0FFh,0FFh,0FEh,00h,0FEh,7Fh,0EFh,0F0h,3Fh,0EAh,0Bh,0E8h,0Fh,0F0h,00h,0BFh,02h,0FFh,0FAh,0AFh,0C0h,0FFh,0AAh,0E0h,00h,00h,00h
		db	00h,00h,00h,00h,1Fh,0FFh,0FFh,0FEh,01h,0FFh,0FFh,0FFh,0F0h,7Fh,0F8h,07h,0D0h,17h,0FFh,01h,7Fh,01h,7Fh,0FDh,7Fh,0F0h,0FFh,0FDh,78h,00h,00h,00h
		db	00h,00h,00h,00h,7Fh,0FFh,0FFh,0FEh,03h,0FFh,0BFh,0EFh,0F0h,3Fh,0F8h,0Bh,0E8h,0Fh,0FFh,0FEh,0BEh,02h,0FFh,0FEh,0FFh,0F8h,0FFh,0FFh,0FEh,00h,00h,00h
		db	00h,00h,00h,01h,0FFh,0FFh,0F1h,0FFh,0FFh,0FFh,9Fh,0E7h,0F0h,3Fh,0F8h,01h,0C0h,03h,0FFh,0FFh,0FFh,00h,7Fh,0FFh,0DFh,0F1h,0FFh,7Fh,0FFh,0F0h,00h,00h
		db	00h,00h,00h,07h,0FFh,0FFh,0FEh,0FFh,0FFh,0FFh,9Fh,0E1h,0E0h,3Fh,0F8h,01h,80h,01h,0FFh,0FFh,0FFh,80h,3Fh,0FFh,0EFh,0E1h,0FFh,0EBh,0FFh,0FCh,00h,00h
		db	00h,00h,00h,1Fh,0FFh,0FFh,0FFh,7Fh,0FFh,0FFh,0DFh,0C0h,0E0h,7Fh,0F0h,01h,80h,00h,0FFh,0FFh,0FFh,0C0h,1Fh,0FFh,0FFh,0F1h,0FFh,0FDh,55h,7Fh,00h,00h
		db	00h,00h,00h,0FFh,0FFh,0FFh,0FFh,1Fh,0AFh,3Fh,0FFh,80h,40h,7Fh,0F0h,03h,80h,00h,0E3h,0FFh,0FFh,0E0h,0Fh,0FFh,0FFh,83h,0FFh,0FFh,0EAh,0BFh,0C0h,00h
		db	00h,00h,07h,0FFh,0FFh,0FFh,0FFh,1Fh,0D7h,7Fh,0FFh,00h,00h,7Fh,0F0h,07h,80h,00h,0F0h,0FFh,0FFh,0E0h,07h,0FFh,0FFh,83h,0FFh,0FDh,57h,7Fh,0C0h,00h
		db	00h,00h,7Fh,0FFh,0FFh,0FFh,0FFh,0Fh,0EAh,0AAh,0AAh,00h,00h,3Fh,0AAh,83h,80h,02h,0AAh,3Fh,0FEh,0A0h,03h,0ABh,0FFh,0FFh,0FFh,0FEh,0AAh,0BFh,80h,00h
		db	00h,00h,7Fh,0FFh,0FFh,0FFh,0FCh,1Fh,0F5h,55h,44h,00h,00h,3Fh,55h,47h,00h,05h,55h,07h,0FFh,40h,01h,57h,0FFh,0FFh,0FDh,0FDh,55h,7Fh,00h,00h
		db	00h,00h,3Fh,0FFh,0FFh,0FFh,0F8h,0Ah,0AAh,0AAh,0AAh,00h,00h,3Fh,0AAh,0A3h,00h,02h,0AAh,00h,0FEh,0A0h,00h,0AFh,0FFh,0FFh,0FEh,0FEh,0AAh,0FFh,00h,00h
		db	00h,00h,15h,57h,0FFh,0FFh,0F0h,00h,05h,55h,45h,00h,00h,1Fh,0D5h,46h,00h,05h,55h,00h,1Dh,40h,01h,7Fh,0FFh,0FFh,0FCh,7Dh,55h,0FFh,00h,00h
		db	00h,00h,0Ah,0AFh,0FFh,0FFh,0E0h,00h,07h,0FFh,0ECh,00h,00h,02h,0FFh,0E0h,00h,03h,0FFh,00h,03h,0E0h,01h,0FFh,0FFh,0FFh,0F8h,08h,1Bh,0F8h,00h,00h
		db	00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
		db	00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h

Animation_phase_06:
		db	00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
		db	00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
		db	00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
		db	00h,00h,00h,00h,03h,0FFh,0FFh,0FEh,00h,0FFh,0FFh,0EFh,0F0h,3Fh,0FEh,0Bh,0E8h,0Fh,0C0h,02h,0BEh,02h,0FFh,0EAh,0FFh,80h,0FAh,0B2h,80h,00h,00h,00h
		db	00h,00h,00h,00h,0FFh,0FFh,0F7h,0FEh,03h,0FFh,0FFh,0F7h,0F0h,7Fh,0FDh,05h,0D0h,17h,0FFh,0FFh,0FFh,05h,7Fh,0FFh,7Fh,0F1h,0FFh,0FFh,0FFh,80h,00h,00h
		db	00h,00h,00h,0Fh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0EFh,0F0h,3Fh,0FEh,0Bh,0E8h,0Bh,0FFh,0FFh,0FFh,82h,0FFh,0FFh,0EFh,0E1h,0FFh,0E3h,0FFh,0FEh,00h,00h
		db	00h,00h,3Fh,0FFh,0FFh,0FFh,0FFh,0F5h,57h,0FFh,0FFh,0F7h,0F0h,7Fh,0FFh,7Fh,0D0h,17h,0FFh,0FFh,0FFh,0E5h,0FFh,0FFh,0FFh,0FFh,0FFh,5Fh,0F7h,0DFh,0C0h,00h
		db	00h,00h,0FFh,0FEh,0AAh,0AAh,0FFh,0EAh,0AAh,0AAh,0ABh,0FBh,0F0h,2Eh,0AAh,0AFh,0A8h,2Ah,0AAh,0FFh,0FEh,0A2h,0FFh,0AAh,0AAh,0AAh,00h,0BEh,0AAh,0AFh,0C0h,00h
		db	00h,00h,7Fh,0FDh,55h,55h,0FFh,75h,55h,55h,55h,0C1h,0E0h,65h,15h,5Fh,80h,05h,55h,7Fh,0FFh,40h,1Fh,55h,55h,50h,01h,7Fh,55h,5Fh,0C0h,00h
		db	00h,00h,7Fh,0FEh,0AAh,0AAh,0FFh,8Ah,0AAh,0AAh,0ABh,00h,00h,7Ah,2Ah,0AFh,80h,02h,0AAh,0FFh,0FEh,0A0h,03h,00h,0AAh,0A0h,29h,0FEh,0AAh,0BFh,80h,00h
		db	00h,00h,7Fh,0FFh,55h,55h,0FCh,1Fh,0F5h,55h,54h,00h,00h,3Dh,15h,5Fh,00h,05h,55h,05h,0FFh,40h,00h,00h,51h,41h,55h,0FDh,55h,5Fh,80h,00h
		db	00h,00h,3Fh,0FFh,0AAh,0AAh,0F0h,00h,0Ah,0AAh,0AAh,00h,00h,3Eh,2Ah,0AEh,00h,02h,0AAh,00h,3Eh,0A0h,00h,20h,00h,02h,0A8h,3Eh,0EAh,0BFh,80h,00h
		db	00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
		db	00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h

Animation_phase_07:
		db	00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
		db	00h,00h,55h,55h,55h,55h,0C0h,00h,05h,55h,54h,00h,00h,15h,55h,54h,00h,01h,41h,00h,1Dh,40h,00h,55h,55h,55h,54h,0Ch,0F5h,55h,80h,00h
		db	00h,00h,0FAh,0AAh,0AAh,0AAh,0FEh,1Fh,0EAh,0AAh,0AAh,00h,00h,7Eh,0AAh,0AFh,80h,02h,80h,0AFh,0FEh,0A0h,03h,0AAh,0AAh,0AAh,0AAh,0FEh,0AAh,0AFh,0C0h,00h
		db	00h,00h,75h,55h,55h,55h,0FFh,0F5h,55h,55h,55h,0FFh,0F0h,7Dh,55h,5Fh,0F0h,7Dh,15h,7Fh,0FDh,47h,0FFh,55h,55h,55h,55h,0FFh,55h,5Fh,0C0h,00h
		db	00h,00h,0FAh,0AAh,0AAh,0AAh,0FFh,0EAh,0AAh,0AAh,0ABh,0FFh,0F8h,7Eh,0AAh,0AFh,0E8h,02h,0AAh,0FFh,0FEh,0A2h,0FFh,0AAh,0AAh,0AAh,0ABh,0FEh,0AAh,0AFh,0C0h,00h
		db	00h,00h,75h,55h,55h,55h,0FFh,0F5h,55h,55h,55h,0F7h,0F8h,7Dh,55h,57h,0D0h,01h,55h,7Fh,0FDh,45h,0FFh,55h,55h,55h,55h,0FFh,55h,5Fh,0C0h,00h
		db	00h,00h,7Ah,0AAh,0AAh,0AAh,0FFh,0EAh,0AAh,0AAh,0ABh,0FFh,0F8h,7Eh,0AAh,0AFh,0E0h,0Ah,0AAh,0FFh,0FEh,0A2h,0FFh,0AAh,0AAh,0AAh,0ABh,0FEh,0AAh,0AFh,80h,00h
		db	00h,00h,00h,00h,0FFh,0FFh,0F5h,0FFh,01h,57h,0FFh,0F5h,0F0h,1Fh,0FCh,01h,0C0h,05h,0D5h,0FFh,0FEh,00h,7Fh,0FFh,0FDh,41h,0DFh,0FFh,0FFh,0C0h,00h,00h
		db	00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h

