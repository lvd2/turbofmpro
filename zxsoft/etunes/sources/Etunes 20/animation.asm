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
		and	07h
		ld	(Animation_step),a
		ret	nz
		ld	a,(Animation_phase)
		inc	a	
		cp	26
		jr	c,Animation_next_phase
		xor	a
Animation_next_phase:
		ld	(Animation_phase),a

		ld	l,a
		ld	h,0
		add	hl,hl
		ld	bc,Animation_table_phase
		add	hl,bc
		ld	a,(hl)
		inc	hl
		ld	h,(hl)
		ld	l,a

		ld	b,18				;размерность по Y
		ld	de,48C7h
Animation_loop_Y:
		ld	c,h
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
    		djnz    Animation_loop_Y
		ret	    

Animation_step:
		db	0
Animation_phase:
		db	0

Animation_table_phase:
                dw	Animation_phase_000	
                dw	Animation_phase_001	
                dw	Animation_phase_002	
                dw	Animation_phase_003	
                dw	Animation_phase_004	
                dw	Animation_phase_005	
                dw	Animation_phase_006	
                dw	Animation_phase_005	
                dw	Animation_phase_004	
                dw	Animation_phase_003	
                dw	Animation_phase_002	
                dw	Animation_phase_001	
                dw	Animation_phase_000	
                dw	Animation_phase_007	
                dw	Animation_phase_008	
                dw	Animation_phase_009	
                dw	Animation_phase_010	
                dw	Animation_phase_011	
                dw	Animation_phase_012	
                dw	Animation_phase_013	
                dw	Animation_phase_012	
                dw	Animation_phase_011	
                dw	Animation_phase_010	
                dw	Animation_phase_009	
                dw	Animation_phase_008	
                dw	Animation_phase_007	

Animation_phase_000:
		db	00h,00h,00h,00h,08h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
		db	00h,00h,54h,15h,14h,00h,01h,55h,55h,40h,00h,07h,0E0h,03h,0FCh,00h,00h
		db	00h,00h,2Fh,0Bh,0CCh,00h,00h,0AAh,0B2h,0A0h,00h,03h,0E0h,01h,0FEh,00h,00h
		db	00h,00h,17h,05h,0DCh,00h,00h,5Fh,0F1h,40h,00h,01h,0F0h,00h,0DCh,00h,00h
		db	00h,00h,2Fh,8Bh,0D0h,00h,00h,0A8h,08h,0A0h,00h,00h,0E0h,00h,0BEh,00h,00h
		db	00h,00h,17h,95h,0D0h,00h,00h,58h,01h,0C0h,00h,01h,0C0h,00h,5Eh,00h,00h
		db	00h,00h,2Fh,8Bh,0C0h,00h,00h,0A8h,00h,00h,00h,00h,00h,00h,0BEh,00h,00h
		db	00h,00h,17h,0D5h,0C0h,00h,00h,5Dh,40h,00h,00h,00h,00h,01h,5Eh,00h,00h
		db	00h,00h,2Eh,0ABh,0BCh,0ACh,00h,0AAh,0A0h,0A2h,0AFh,0E2h,0F3h,0FCh,0BEh,0FCh,00h
		db	00h,00h,57h,75h,5Dh,0C6h,00h,55h,41h,41h,57h,0F1h,0F5h,0BFh,5Fh,0FEh,00h
		db	00h,00h,2Fh,0AAh,0FBh,86h,00h,0AFh,0C0h,0A0h,0A9h,0F2h,0F2h,8Ch,0BFh,0FEh,00h
		db	00h,00h,17h,95h,0C5h,40h,00h,58h,01h,41h,51h,0F1h,0F5h,0C1h,5Fh,0FEh,00h
		db	00h,00h,2Fh,8Bh,0C2h,0AEh,00h,0A8h,00h,0A0h,0A1h,0F0h,0F7h,0FEh,0BEh,0BEh,00h
		db	00h,00h,17h,95h,0C1h,55h,00h,58h,01h,61h,41h,0F1h,0F3h,0FFh,0DFh,5Eh,00h
		db	00h,00h,2Fh,8Bh,0C0h,0Bh,80h,0A8h,00h,0E0h,0A1h,0F0h,0F0h,1Fh,0BEh,0BEh,00h
		db	00h,00h,17h,05h,0C1h,85h,00h,58h,01h,61h,61h,0F1h,0F1h,07h,0FDh,5Eh,00h
		db	00h,00h,2Fh,8Bh,0C2h,0ABh,00h,0A8h,00h,0E0h,0A1h,0F1h,0F3h,0BFh,0BEh,0BEh,00h
		db	00h,00h,15h,0C5h,0F1h,54h,00h,54h,01h,0F1h,70h,0F9h,0FDh,0FEh,7Fh,0FFh,00h

Animation_phase_001:
		db	00h,00h,00h,00h,08h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
		db	00h,00h,54h,15h,1Ch,00h,01h,55h,55h,40h,00h,07h,40h,03h,0D4h,00h,00h
		db	00h,00h,2Bh,8Bh,0DCh,00h,00h,0AAh,0A2h,0A0h,00h,07h,0A0h,03h,0E8h,00h,00h
		db	00h,00h,17h,85h,0DCh,00h,00h,5Fh,0F1h,40h,00h,03h,50h,01h,0D4h,00h,00h
		db	00h,00h,2Fh,8Bh,0D8h,00h,00h,0A8h,18h,0A0h,00h,03h,0A0h,00h,0E8h,00h,00h
		db	00h,00h,17h,95h,0D0h,00h,00h,58h,01h,0C0h,00h,01h,0C0h,01h,0D4h,00h,00h
		db	00h,00h,2Fh,8Bh,0C0h,00h,00h,0A8h,00h,00h,00h,00h,00h,01h,0EAh,00h,00h
		db	00h,00h,17h,0D5h,0C0h,00h,00h,5Dh,40h,00h,00h,00h,40h,01h,0D4h,50h,00h
		db	00h,00h,2Fh,0BBh,0BEh,0A8h,00h,0AAh,0A0h,0A6h,0A2h,0A3h,0A2h,0A8h,0EBh,0ACh,00h
		db	00h,00h,17h,75h,5Dh,0F6h,00h,55h,41h,41h,57h,51h,55h,7Dh,0D5h,5Eh,00h
		db	00h,00h,2Fh,0AAh,0FEh,86h,00h,0AFh,0C0h,0A0h,0A1h,0A3h,0A6h,8Ch,0EBh,0EEh,00h
		db	00h,00h,17h,15h,0C5h,40h,00h,58h,01h,41h,51h,51h,55h,41h,0D5h,0F6h,00h
		db	00h,00h,2Fh,8Bh,0C2h,0AAh,00h,0A8h,00h,0A0h,0A1h,0A1h,0A6h,0AAh,0EBh,0FEh,00h
		db	00h,00h,17h,15h,0C1h,55h,00h,58h,01h,41h,41h,51h,53h,0D5h,0D5h,0F6h,00h
		db	00h,00h,2Fh,0Bh,0C0h,0Bh,80h,0A8h,00h,0A0h,0A1h,0A1h,0A0h,3Eh,0EAh,0FEh,00h
		db	00h,00h,17h,15h,0C1h,05h,00h,58h,01h,41h,41h,51h,53h,0Dh,0D4h,0FEh,00h
		db	00h,00h,2Fh,0Bh,0C2h,8Bh,00h,0A8h,00h,0A0h,0A1h,0A1h,0A2h,0ABh,0EAh,0FEh,00h
		db	00h,00h,15h,0C5h,61h,56h,00h,54h,00h,51h,51h,0D1h,0D7h,54h,75h,0FFh,00h

Animation_phase_002:
		db	00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
		db	00h,00h,00h,05h,0Eh,00h,00h,55h,40h,00h,00h,00h,00h,01h,50h,00h,00h
		db	00h,00h,0Fh,87h,0CEh,00h,01h,0EAh,0FFh,0E0h,00h,0Fh,0C0h,07h,0F8h,00h,00h
		db	00h,00h,0Fh,0C7h,0EEh,00h,00h,5Fh,0F1h,40h,00h,07h,0E0h,07h,0D0h,00h,00h
		db	00h,00h,0Fh,0C2h,0EEh,00h,00h,2Fh,0F9h,0A0h,00h,03h,0A0h,03h,0E8h,00h,00h
		db	00h,00h,1Fh,0C5h,0F8h,00h,00h,58h,19h,0E0h,00h,03h,0C0h,01h,0D0h,00h,00h
		db	00h,00h,0Bh,0CAh,0E0h,00h,00h,0A8h,08h,0C0h,00h,03h,80h,01h,0E8h,00h,00h
		db	00h,00h,17h,0D5h,0F0h,00h,00h,5Dh,41h,41h,41h,41h,40h,41h,0D5h,50h,00h
		db	00h,00h,2Bh,0BBh,0A9h,0A8h,00h,0AAh,0A0h,0AEh,0AAh,0A3h,0A2h,0A9h,0EAh,0A8h,00h
		db	00h,00h,17h,75h,5Dh,0FEh,00h,55h,41h,43h,47h,53h,55h,0FDh,0F7h,0D4h,00h
		db	00h,00h,2Fh,0FBh,0FEh,0C6h,00h,0AFh,0C0h,0A2h,0ABh,0A3h,0A6h,0BDh,0EBh,0EAh,00h
		db	00h,00h,17h,95h,0E5h,40h,00h,5Ch,01h,41h,51h,53h,55h,5Dh,0F7h,0F4h,00h
		db	00h,00h,2Fh,8Bh,0C2h,0AAh,00h,0A8h,00h,0A1h,0A1h,0A3h,0A6h,0ABh,0EBh,0FAh,00h
		db	00h,00h,57h,15h,0C1h,0F5h,00h,58h,01h,41h,41h,51h,53h,0FDh,0F5h,0F4h,00h
		db	00h,00h,2Fh,0Bh,0C2h,2Bh,00h,0A8h,00h,0A1h,0A1h,0A1h,0A1h,0BEh,0EAh,0FAh,00h
		db	00h,00h,57h,15h,0C5h,05h,00h,58h,01h,41h,41h,0D1h,0D3h,0Dh,0F5h,0F5h,00h
		db	00h,00h,2Fh,0Bh,82h,0ABh,00h,0A8h,00h,0A1h,0A1h,0A9h,0AAh,0AAh,0EAh,0FAh,00h
		db	00h,00h,1Fh,07h,0C1h,5Eh,00h,7Ch,01h,0F9h,0FDh,0FDh,0FFh,0D4h,7Fh,0FFh,80h

Animation_phase_003:
		db	00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
		db	00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
		db	00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
		db	00h,00h,07h,0C3h,0E7h,00h,01h,0FFh,0FFh,0E0h,00h,1Fh,0C0h,0Fh,0E0h,00h,00h
		db	00h,00h,07h,0E3h,0F7h,80h,00h,0FFh,0FBh,0E0h,00h,0Fh,0C0h,0Fh,0E0h,00h,00h
		db	00h,00h,07h,0E3h,0F7h,00h,00h,7Fh,0F1h,0E0h,00h,07h,0C0h,07h,0F0h,00h,00h
		db	00h,00h,0Fh,0E7h,0FCh,00h,00h,7Fh,0F8h,0E0h,00h,07h,80h,07h,0F8h,00h,00h
		db	00h,00h,1Fh,0FFh,0F0h,00h,00h,7Fh,0C1h,0C0h,41h,07h,0C0h,03h,0F9h,0F0h,00h
		db	00h,00h,1Fh,0FFh,0F8h,0FCh,00h,7Ah,0E0h,0EFh,0EFh,0E3h,0E3h,0FBh,0FFh,0F8h,00h
		db	00h,00h,1Fh,0FFh,0FFh,0FEh,00h,5Fh,0E1h,47h,0DFh,0E3h,0E7h,0FFh,0DFh,0FCh,00h
		db	00h,00h,3Fh,0FFh,0FFh,0FEh,00h,0AFh,0E0h,0A2h,0BFh,0A3h,0A7h,0FBh,0EBh,0FCh,00h
		db	00h,00h,3Fh,0DDh,0FFh,0D6h,00h,5Fh,0C1h,41h,51h,53h,57h,7Dh,0F7h,0FEh,00h
		db	00h,00h,3Fh,8Bh,0E3h,0AAh,00h,0AAh,00h,0A1h,0A1h,0A3h,0A7h,0AFh,0EBh,0FEh,00h
		db	00h,00h,5Fh,17h,0C1h,0F5h,00h,58h,01h,41h,41h,0D1h,0D7h,0FDh,0F5h,0FFh,00h
		db	00h,00h,2Fh,0Bh,0C2h,0FBh,00h,0B8h,00h,0A1h,0A1h,0A1h,0A1h,0FEh,0FBh,0FBh,00h
		db	00h,00h,5Fh,15h,85h,57h,00h,50h,01h,51h,51h,0D1h,0D1h,55h,75h,7Dh,00h
		db	00h,00h,7Eh,1Fh,86h,0AEh,00h,0F8h,01h,0E9h,0FCh,0FDh,0FBh,0ABh,0FFh,0FFh,0C0h
		db	00h,00h,1Fh,0Fh,0C3h,0FCh,00h,7Ch,01h,0FDh,0FCh,0FCh,0FDh,0FEh,7Fh,0FFh,0C0h
	

Animation_phase_004:
		db	00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
		db	00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
		db	00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
		db	00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
		db	00h,00h,00h,00h,00h,00h,00h,0Eh,00h,00h,00h,00h,00h,02h,80h,00h,00h
		db	00h,00h,01h,0F1h,0F1h,0C0h,00h,0FFh,0FFh,0E0h,00h,1Fh,80h,17h,0C0h,00h,00h
		db	00h,00h,03h,0F1h,0FBh,80h,00h,0FEh,0BBh,0E0h,00h,0Fh,80h,2Fh,0E0h,00h,00h
		db	00h,00h,07h,0FFh,0FFh,00h,00h,7Fh,0F9h,0C0h,00h,0Fh,80h,1Fh,0F5h,40h,00h
		db	00h,00h,0Fh,0FFh,0FCh,00h,00h,7Fh,0F8h,0E3h,0CFh,0C7h,0E0h,0Fh,0FFh,0F0h,00h
		db	00h,00h,1Fh,0FFh,0FDh,0FEh,00h,7Fh,0E1h,0EFh,0FFh,0E7h,0E7h,0FFh,0FDh,7Ch,00h
		db	00h,00h,3Fh,0FFh,0AFh,0FEh,00h,0FAh,0E1h,0EFh,0FBh,0E3h,0E7h,0FFh,0FEh,0FCh,00h
		db	00h,00h,3Fh,0FFh,0D7h,0FFh,00h,0FDh,41h,0E3h,0FFh,0F3h,0FFh,0FFh,0FFh,0FEh,00h
		db	00h,00h,7Fh,0BFh,0EFh,0FEh,00h,0FAh,81h,0E3h,0FBh,0F3h,0FEh,0FFh,0FFh,0FEh,00h
		db	00h,00h,7Fh,9Fh,0C7h,0FFh,00h,0F8h,01h,0E1h,0F1h,0F1h,0F5h,0D7h,0FFh,0FFh,00h
		db	00h,00h,0FFh,3Fh,0CFh,0FFh,00h,0F8h,01h,0E1h,0F9h,0F9h,0F9h,0FFh,0FFh,0FFh,80h
		db	00h,00h,0FEh,1Fh,8Fh,0F7h,00h,0D4h,01h,5Dh,55h,0D7h,0DFh,7Fh,0F5h,0F5h,0E0h
		db	00h,00h,7Eh,1Fh,87h,0AAh,00h,0E8h,01h,0A9h,0A8h,0AAh,0AAh,0AFh,2Bh,0FBh,0E0h
		db	00h,00h,00h,05h,01h,40h,00h,74h,00h,00h,54h,50h,00h,14h,17h,97h,00h
	

Animation_phase_005:
		db	00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
		db	00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
		db	00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
		db	00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
		db	00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
		db	00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
		db	00h,00h,00h,00h,28h,00h,00h,2Eh,0A0h,00h,00h,00h,00h,0Fh,80h,00h,00h
		db	00h,00h,01h,0F1h,0F9h,0C0h,00h,7Fh,0DFh,0C0h,00h,1Fh,80h,1Fh,0C0h,00h,00h
		db	00h,00h,03h,0FFh,0FFh,0C0h,00h,0FFh,0FBh,0E0h,00h,2Fh,80h,2Fh,0FFh,0E0h,00h
		db	00h,00h,0Fh,0FFh,0FFh,0DCh,00h,7Fh,0F9h,0E7h,0FFh,0EFh,0E7h,0FFh,0FDh,78h,00h
		db	00h,00h,3Fh,0FFh,0AFh,0FEh,00h,0FAh,0B9h,0EBh,0FBh,0E7h,0E7h,0FFh,0FEh,0FCh,00h
		db	00h,00h,7Fh,0FFh,0D7h,0FFh,00h,0FDh,41h,0E7h,0FFh,0F7h,0FFh,0FFh,0FFh,0FFh,00h
		db	00h,00h,0FFh,0FFh,0EEh,0BFh,00h,0FAh,0A1h,0E3h,0FBh,0FBh,0FFh,0ABh,0FFh,0FFh,80h
		db	00h,01h,0FFh,0FFh,0DFh,0FFh,00h,0FDh,41h,0F1h,0FFh,0FFh,0FFh,0FFh,0FFh,0DFh,0C0h
		db	00h,00h,0BFh,2Ah,0CFh,0FBh,00h,0A8h,01h,0B9h,0A9h,0ABh,0AFh,0FFh,0FAh,0BAh,0B0h
		db	00h,00h,54h,15h,0Dh,54h,00h,54h,01h,55h,55h,0D5h,0D5h,55h,0F5h,55h,40h
		db	00h,00h,68h,1Ah,82h,0A0h,00h,0A8h,00h,0A0h,0A8h,0AAh,0AAh,2Ah,2Ah,0BAh,0A0h
		db	00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,40h,00h

Animation_phase_006:
		db	00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
		db	00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
		db	00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
		db	00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
		db	00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
		db	00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
		db	00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
		db	00h,00h,00h,00h,10h,00h,00h,10h,00h,00h,00h,00h,00h,07h,00h,00h,00h
		db	00h,00h,00h,0F8h,0F8h,80h,00h,7Fh,0FBh,0E0h,00h,0Fh,00h,2Fh,0EEh,00h,00h
		db	00h,00h,07h,0FFh,0FFh,40h,00h,7Fh,0FFh,0E1h,0FFh,0FFh,0C0h,7Fh,0FDh,0F0h,00h
		db	00h,00h,1Fh,0FFh,0AFh,0FEh,00h,0FAh,0ABh,0EBh,0FBh,0FFh,0E7h,0FFh,0FEh,0FCh,00h
		db	00h,00h,7Fh,0FFh,0D7h,0FFh,00h,0FDh,79h,0E7h,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,00h
		db	00h,00h,0FFh,0FFh,0EFh,0FFh,00h,0FEh,0A1h,0E3h,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0C0h
		db	00h,00h,0FFh,0D5h,0DFh,0FFh,00h,55h,41h,0FDh,57h,0D7h,0FFh,0FFh,0F5h,5Dh,50h
		db	00h,00h,0ABh,0AAh,0CAh,0AAh,00h,0AAh,01h,0A9h,0A9h,0ABh,0AAh,0AAh,0FAh,0BAh,0A0h
		db	00h,00h,0D4h,15h,05h,54h,00h,54h,01h,55h,55h,0D5h,0D5h,55h,75h,55h,40h
		db	00h,00h,00h,08h,00h,00h,00h,0A8h,00h,00h,0A8h,0A0h,00h,00h,0Ah,0AAh,80h
		db	00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
	

Animation_phase_007:
		db	00h,00h,00h,00h,18h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
		db	00h,00h,74h,15h,1Ch,00h,01h,55h,55h,40h,00h,07h,40h,03h,0D4h,00h,00h
		db	00h,00h,2Fh,0Bh,0DCh,00h,00h,0AAh,0A2h,0A0h,00h,03h,0A0h,01h,0EAh,00h,00h
		db	00h,00h,17h,15h,0DCh,00h,00h,5Fh,0F1h,40h,00h,01h,50h,00h,0F4h,00h,00h
		db	00h,00h,2Fh,0Bh,0D0h,00h,00h,0A8h,08h,0A0h,00h,01h,0A0h,00h,0EAh,00h,00h
		db	00h,00h,57h,15h,0C0h,00h,00h,58h,01h,40h,00h,01h,40h,00h,0F4h,00h,00h
		db	00h,00h,2Fh,8Bh,0C0h,00h,00h,0A8h,00h,00h,00h,00h,00h,00h,0EAh,00h,00h
		db	00h,00h,57h,55h,0C0h,00h,00h,5Dh,40h,00h,00h,00h,00h,01h,0F4h,00h,00h
		db	00h,00h,2Eh,0ABh,0BEh,0ACh,00h,0AAh,0A0h,0A2h,0AAh,0A3h,0A3h,0A8h,0EBh,0A8h,00h
		db	00h,00h,57h,75h,5Dh,0C6h,00h,55h,41h,41h,5Fh,53h,55h,3Dh,0F5h,54h,00h
		db	00h,00h,2Fh,0AAh,0FBh,86h,00h,0AFh,0C0h,0A0h,0B9h,0A3h,0A6h,8Ch,0EBh,0EAh,00h
		db	00h,00h,17h,15h,0C5h,40h,00h,58h,01h,41h,51h,51h,55h,41h,0F5h,0F4h,00h
		db	00h,00h,2Fh,8Bh,0C2h,0AEh,00h,0A8h,00h,0A0h,0A1h,0A1h,0A6h,0ABh,0EBh,0FAh,00h
		db	00h,00h,17h,15h,0C1h,55h,00h,58h,01h,41h,41h,51h,53h,55h,0F5h,0F4h,00h
		db	00h,00h,2Fh,0Bh,0C0h,0Bh,00h,0A8h,00h,0A0h,0A1h,0A1h,0A0h,0Ah,0EAh,0FAh,00h
		db	00h,00h,17h,05h,0C1h,85h,00h,58h,01h,41h,41h,51h,53h,0Dh,0F5h,0F4h,00h
		db	00h,00h,2Bh,8Bh,0C2h,0EBh,00h,0A8h,00h,0A0h,0A1h,0A1h,0A6h,0BAh,0EAh,0FAh,00h
		db	00h,00h,15h,0C5h,71h,54h,00h,56h,00h,51h,51h,0D1h,55h,54h,75h,0F5h,00h

Animation_phase_008:
		db	00h,00h,00h,00h,70h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
		db	00h,03h,0FCh,0FFh,78h,00h,07h,0FFh,0F7h,0C0h,00h,03h,0F0h,00h,0FCh,00h,00h
		db	00h,00h,0AEh,2Bh,68h,00h,00h,0AAh,0A0h,0A0h,00h,01h,0A0h,00h,6Ah,00h,00h
		db	00h,00h,5Eh,17h,0D0h,00h,00h,50h,51h,40h,00h,01h,0D0h,00h,75h,00h,00h
		db	00h,00h,0AEh,2Bh,0A0h,00h,00h,0B8h,00h,0A0h,00h,01h,0A0h,00h,7Ah,00h,00h
		db	00h,00h,5Eh,17h,80h,00h,00h,58h,01h,40h,00h,00h,50h,00h,75h,00h,00h
		db	00h,00h,0AEh,2Bh,80h,00h,00h,0B8h,00h,00h,00h,00h,00h,00h,0FAh,00h,00h
		db	00h,00h,5Fh,57h,0C0h,30h,00h,5Fh,0C1h,0C0h,01h,01h,0C0h,40h,0F5h,80h,00h
		db	00h,00h,2Fh,0ABh,0F8h,0ACh,00h,0BAh,81h,0E3h,0EFh,0E1h,0E3h,0A8h,0FBh,0F8h,00h
		db	00h,00h,5Fh,77h,5Dh,56h,00h,5Dh,41h,41h,5Dh,51h,0D7h,55h,0F5h,0D4h,00h
		db	00h,00h,2Eh,0EAh,0BBh,8Ch,00h,0AAh,80h,0A1h,0B9h,0A1h,0A6h,8Eh,0EBh,0AAh,00h
		db	00h,00h,57h,15h,0C5h,0FCh,00h,58h,01h,41h,51h,51h,0D5h,50h,0F5h,0F5h,00h
		db	00h,00h,2Fh,8Bh,0C2h,0BFh,00h,0A8h,00h,0A1h,0A1h,0A1h,0A6h,0ACh,0EBh,0FAh,00h
		db	00h,00h,17h,15h,0C1h,55h,00h,58h,01h,41h,41h,53h,51h,55h,0F5h,0F4h,00h
		db	00h,00h,2Fh,8Bh,0C0h,0ABh,80h,0A8h,00h,0A0h,0A1h,0A3h,0A2h,0Ah,0E9h,0FAh,00h
		db	00h,00h,17h,85h,0C1h,0C5h,00h,58h,01h,41h,41h,43h,47h,1Dh,0D5h,0F4h,00h
		db	00h,00h,2Bh,8Ah,0E2h,0FBh,00h,2Ch,00h,0B0h,0A1h,0A3h,0A6h,0FBh,0E9h,0E8h,00h
		db	00h,00h,15h,0C5h,71h,54h,00h,56h,00h,59h,58h,59h,51h,54h,54h,74h,00h

Animation_phase_009:
		db	00h,00h,00h,00h,80h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
		db	00h,05h,51h,0FDh,60h,00h,07h,0FFh,0F5h,40h,00h,01h,50h,00h,7Eh,00h,00h
		db	00h,0Fh,0FBh,0FEh,0A0h,00h,07h,0FFh,0FBh,0E0h,00h,00h,0F8h,00h,3Fh,80h,00h
		db	00h,05h,78h,5Fh,70h,00h,01h,55h,51h,40h,00h,00h,0D0h,00h,3Dh,40h,00h
		db	00h,02h,0BCh,0AFh,0C0h,00h,00h,0AAh,0A0h,0A0h,00h,00h,0E8h,00h,3Ah,80h,00h
		db	00h,01h,7Ch,57h,40h,00h,01h,50h,11h,40h,00h,00h,0D0h,00h,7Dh,00h,00h
		db	00h,00h,0BEh,2Fh,80h,00h,00h,0B0h,00h,0A0h,00h,00h,68h,00h,7Ah,80h,00h
		db	00h,01h,5Eh,57h,0B0h,40h,00h,57h,0C1h,0C1h,45h,0C1h,0C0h,00h,7Dh,60h,00h
		db	00h,00h,0BFh,0AFh,0FBh,0FCh,00h,0BFh,0C1h,0E7h,0EFh,0E1h,0E1h,0FCh,0FAh,0F8h,00h
		db	00h,00h,5Fh,57h,0FDh,54h,00h,5Dh,41h,61h,5Dh,51h,0D3h,54h,0F5h,0FCh,00h
		db	00h,00h,0AEh,0EAh,0B2h,0ACh,00h,0BAh,0C0h,0A0h,0BAh,0A1h,0A6h,8Ah,0FAh,0AAh,00h
		db	00h,00h,5Fh,15h,45h,0F4h,00h,55h,01h,41h,51h,51h,0D7h,74h,0F5h,0D5h,00h
		db	00h,00h,2Fh,8Bh,0C2h,0FFh,00h,0A8h,00h,0A1h,0A1h,0A3h,0A2h,0BEh,0EBh,0FAh,00h
		db	00h,00h,57h,95h,0C1h,57h,80h,58h,01h,41h,51h,53h,51h,55h,0F5h,0F4h,00h
		db	00h,00h,2Fh,8Bh,0E0h,0ABh,80h,0A8h,00h,0A2h,0A1h,0A3h,0A2h,0AAh,0EBh,0FAh,00h
		db	00h,00h,17h,0C5h,0E1h,0FDh,80h,5Ch,01h,51h,41h,43h,47h,0FDh,0D5h,0F4h,00h
		db	00h,00h,0Bh,0E2h,0F8h,0FAh,00h,2Eh,01h,0B8h,0B9h,0B3h,0A7h,0FAh,0E8h,0E8h,00h
		db	00h,00h,05h,45h,70h,54h,00h,56h,00h,59h,58h,59h,51h,50h,54h,54h,00h

Animation_phase_010:
		db	00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
		db	00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
		db	00h,02h,02h,0E2h,80h,00h,03h,0FFh,0A0h,80h,00h,00h,08h,00h,0Fh,80h,00h
		db	00h,7Fh,0C7h,0FDh,40h,00h,0Fh,0FFh,0FFh,0E0h,00h,00h,0FCh,00h,0Fh,0C0h,00h
		db	00h,2Ah,0FEh,0BEh,0C0h,00h,0Bh,0FEh,0B2h,0A0h,00h,00h,0A8h,00h,0Fh,0E0h,00h
		db	00h,15h,0F1h,5Fh,40h,00h,01h,55h,51h,40h,00h,00h,54h,00h,1Dh,40h,00h
		db	00h,0Ah,0F8h,0BEh,80h,00h,00h,0AAh,0A0h,0A0h,00h,00h,68h,00h,3Eh,0A0h,00h
		db	00h,05h,7Ch,5Fh,40h,00h,01h,57h,0D1h,40h,01h,00h,54h,00h,3Dh,50h,00h
		db	00h,02h,0FEh,0AFh,0F1h,0F8h,00h,0BFh,0C0h,0A7h,0EFh,0E0h,0F0h,0FCh,7Eh,0B8h,00h
		db	00h,01h,7Fh,5Fh,0F7h,0FCh,01h,5Fh,0C1h,0E7h,0FFh,0F1h,0F1h,0DEh,7Dh,7Ch,00h
		db	00h,00h,0BFh,0AFh,0F2h,0ACh,00h,0BAh,0C0h,0A2h,0BEh,0A1h,0FBh,0AAh,0FAh,0BEh,00h
		db	00h,00h,5Dh,57h,65h,54h,00h,55h,41h,41h,5Dh,51h,0D7h,7Dh,0FDh,55h,00h
		db	00h,00h,0AEh,0AAh,0A3h,0EFh,00h,0AAh,80h,0A1h,0A9h,0A3h,0A2h,0FFh,0FAh,0ABh,00h
		db	00h,00h,5Fh,95h,0E1h,55h,80h,58h,01h,41h,51h,0D3h,0D7h,57h,0F5h,0F6h,00h
		db	00h,00h,2Fh,0CBh,0E0h,0ABh,80h,0ACh,00h,0A2h,0A3h,0A3h,0AEh,0ABh,0EBh,0FEh,00h
		db	00h,00h,1Fh,0D5h,0F1h,0FDh,00h,5Eh,01h,51h,51h,53h,57h,0DFh,0D5h,0FCh,00h
		db	00h,00h,0Fh,0A3h,0E8h,0FEh,00h,2Eh,00h,0B8h,0B9h,0BAh,0BBh,0F8h,0E8h,0F8h,00h
		db	00h,00h,00h,01h,40h,00h,00h,16h,00h,00h,59h,0C0h,00h,00h,7Ch,50h,00h

Animation_phase_011:
		db	00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
		db	00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
		db	00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
		db	00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
		db	00h,2Ah,0Ah,0A6h,00h,00h,0Ah,0AAh,0A2h,0A0h,00h,00h,28h,00h,0Bh,0E0h,00h
		db	00h,0D5h,0D5h,7Dh,80h,00h,15h,55h,55h,40h,00h,00h,56h,00h,05h,0E0h,00h
		db	00h,0ABh,0EAh,0BAh,80h,00h,0Ah,0AAh,0BAh,0A0h,00h,00h,0AAh,00h,0Eh,0E0h,00h
		db	00h,55h,0F5h,7Dh,00h,00h,05h,55h,51h,40h,00h,00h,54h,00h,1Fh,50h,00h
		db	00h,0Bh,0FEh,0BEh,0A0h,00h,02h,0AAh,0A0h,0A0h,0A2h,0A0h,0EAh,00h,3Fh,0A8h,00h
		db	00h,05h,0FFh,5Fh,0F7h,54h,01h,5Dh,51h,45h,5Dh,51h,0F5h,56h,7Fh,54h,00h
		db	00h,06h,0FFh,0BFh,0B6h,0A8h,00h,0BAh,0C0h,0A2h,0BEh,0A1h,0EAh,0ABh,0FEh,0AEh,00h
		db	00h,01h,0FFh,0FFh,65h,55h,01h,5Dh,41h,61h,5Dh,51h,0D7h,55h,0FDh,0D6h,00h
		db	00h,00h,0FFh,0FFh,0A7h,0AAh,80h,0FAh,80h,0A1h,0BEh,0B3h,0FAh,0AFh,0FFh,0AEh,00h
		db	00h,00h,7Fh,0FFh,0F7h,55h,80h,0FFh,81h,0E1h,0F1h,0F3h,0FFh,0F7h,0FFh,0FFh,00h
		db	00h,00h,3Fh,0BFh,0E8h,0FFh,80h,0FEh,01h,0FBh,0F1h,0F3h,0FFh,0FFh,0FFh,0FEh,00h
		db	00h,00h,0Fh,0D7h,0D1h,0D7h,00h,7Ch,01h,0F9h,0F1h,0F3h,0FFh,7Dh,0FDh,0F8h,00h
		db	00h,00h,02h,83h,0E8h,2Ah,00h,7Eh,00h,0A1h,0F9h,0E0h,0A2h,0E0h,0F9h,0F0h,00h
		db	00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h

Animation_phase_012:
		db	00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
		db	00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
		db	00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
		db	00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
		db	00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
		db	00h,00h,00h,00h,00h,00h,00h,54h,00h,00h,00h,00h,00h,00h,00h,40h,00h
		db	00h,0AAh,2Ah,0AAh,00h,00h,0Ah,0AAh,0AAh,0A0h,00h,00h,2Ah,00h,02h,0A0h,00h
		db	01h,55h,0D5h,75h,00h,00h,15h,55h,55h,40h,00h,00h,54h,00h,0Dh,50h,00h
		db	02h,0ABh,0EAh,0BBh,80h,00h,0Ah,0AAh,0BAh,0A0h,00h,00h,0AAh,00h,1Eh,0ACh,00h
		db	00h,77h,0F5h,7Dh,71h,40h,05h,55h,51h,45h,5Dh,50h,0F5h,14h,7Fh,5Ch,00h
		db	00h,1Fh,0FFh,0FFh,0A6h,0A8h,02h,0AAh,0A0h,0A2h,0BAh,0A1h,0EAh,0ABh,0FFh,0FAh,00h
		db	00h,07h,0FFh,0FFh,65h,55h,01h,0FDh,51h,0E5h,5Dh,51h,0FFh,55h,0FFh,0F6h,00h
		db	00h,03h,0FFh,0FEh,0AFh,0EAh,81h,0FAh,80h,0A2h,0BAh,0ABh,0EAh,0BFh,0FFh,0EAh,00h
		db	00h,00h,0FFh,0FFh,0F7h,5Dh,81h,0FFh,0C1h,0F1h,0FFh,0F3h,0FFh,0D7h,0FFh,0DFh,00h
		db	00h,00h,3Fh,0FFh,0E8h,0FFh,80h,0FEh,81h,0FBh,0F9h,0F3h,0FBh,0FFh,0FFh,0FEh,00h
		db	00h,00h,07h,0E7h,0F0h,7Fh,00h,7Dh,01h,0F1h,0F1h,0F3h,0F7h,0F1h,0FDh,0F8h,00h
		db	00h,00h,00h,00h,00h,00h,00h,0Ah,00h,00h,0A8h,80h,00h,00h,0B8h,80h,00h
		db	00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h

Animation_phase_013:
		db	00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
		db	00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
		db	00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
		db	00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
		db	00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
		db	00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
		db	00h,00h,02h,80h,00h,00h,02h,0AAh,80h,00h,00h,00h,00h,00h,00h,0B0h,00h
		db	01h,55h,0D5h,75h,00h,00h,15h,55h,55h,40h,00h,00h,54h,00h,05h,50h,00h
		db	02h,0ABh,0EAh,0BBh,80h,00h,0Ah,0AAh,0BAh,0A0h,00h,00h,2Ah,00h,1Eh,0A8h,00h
		db	01h,57h,0D5h,7Dh,0F0h,00h,15h,55h,55h,41h,5Dh,50h,0D5h,00h,7Dh,5Ch,00h
		db	00h,3Bh,0FAh,0FFh,0A6h,0A8h,02h,0AAh,0B2h,0A2h,0BAh,0A1h,0EAh,0ABh,0FFh,0AEh,00h
		db	00h,1Fh,0FFh,0FFh,65h,55h,01h,0FDh,71h,0E5h,5Dh,53h,0FFh,55h,0FFh,0FEh,00h
		db	00h,07h,0FFh,0FEh,0AEh,0AAh,81h,0FAh,80h,0A2h,0BAh,0A3h,0AEh,0ABh,0FFh,0FAh,00h
		db	00h,01h,0FFh,0FFh,0FFh,5Dh,81h,0FFh,0C1h,0F1h,0FFh,0F3h,0FFh,0D7h,0FFh,0D5h,00h
		db	00h,00h,3Fh,0FFh,0E9h,0FFh,80h,0FFh,81h,0FBh,0FBh,0F3h,0FBh,0FFh,0FFh,0FFh,00h
		db	00h,00h,05h,47h,0F0h,15h,00h,7Ch,00h,51h,0F1h,0F3h,45h,41h,0FDh,0F0h,00h
		db	00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,20h,00h,00h
		db	00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h

