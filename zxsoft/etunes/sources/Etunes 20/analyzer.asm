;--------------------------------------------------------------------
; Описание: Модуль отображения анализатора
; Автор порта: Тарасов М.Н.(Mick),2010
;--------------------------------------------------------------------

;-------------------------------------------------------------------
; описание: Обновление параметров анализатора
; параметры: нет
; возвращаемое  значение: нет
;---------------------------------------------------------------------
Analyzer_update:
		ld	hl,EAmplitude_ch0

		ld	a,(hl)				;+00h - Amplitude 0 right/left
		and	0Fh
		ld	c,a
		ld	a,(hl)				;+00h - Amplitude 0 right/left				
		and	0F0h
		rrca	
		rrca	
		rrca
		rrca	
		cp	c
		jr	nc,Analyzer_up_ch0
		ld	a,c	
Analyzer_up_ch0:
		ld	(Analyzer_ch0_vol),a          	;Amplitude 0

		inc	hl
		ld	a,(hl)				;+01h - Amplitude 1 right/left
		and	0Fh
		ld	c,a
		ld	a, (hl)				;+01h - Amplitude 1 right/left
		and	0F0h
		rrca	
		rrca	
		rrca	
		rrca	
		cp	c
		jr	nc,Analyzer_up_ch1
		ld	a,c	
Analyzer_up_ch1:
		ld	(Analyzer_ch1_vol),a          	;Amplitude 1 

		inc	hl
		ld	a,(hl) 				;+02h - Amplitude 2 right/left
		and	0Fh
		ld	c,a
		ld	a,(hl)				;+02h - Amplitude 2 right/left
		and	0F0h
		rrca	
		rrca	
		rrca	
		rrca	
		cp	c
		jr	nc,Analyzer_up_ch2
		ld	a,c	
Analyzer_up_ch2:
		ld	(Analyzer_ch2_vol),a         	;Amplitude 2  

		inc	hl
		ld	a, (hl) 			;+03h - Amplitude 3 right/left
		and	0Fh
		ld	c,a
		ld	a, (hl)                         ;+03h - Amplitude 3 right/left
		and	0F0h
		rrca	
		rrca	
		rrca	
		rrca	
		cp	c
		jr	nc,Analyzer_up_ch3
		ld	a,c	
Analyzer_up_ch3:
		ld	(Analyzer_ch3_vol),a         	;Amplitude 3  

		inc	hl
		ld	a, (hl)				;+04h - Amplitude 4 right/left
		and	0Fh
		ld	c,a
		ld	a, (hl)
		and	0F0h
		rrca	
		rrca	
		rrca	
		rrca	
		cp	c
		jr	nc,Analyzer_up_ch4
		ld	a,c	
Analyzer_up_ch4:
		ld	(Analyzer_ch4_vol),a          ;Amplitude 4  

		inc	hl
		ld	a, (hl)				;+05h - Amplitude 5 right/left
		and	0Fh
		ld	c,a
		ld	a, (hl)
		and	0F0h
		rrca	
		rrca	
		rrca	
		rrca	
		cp	c
		jr	nc,Analyzer_up_ch5
		ld	a,c	
Analyzer_up_ch5:
		ld	(Analyzer_ch5_vol),a		;Amplitude 5  
		ret
;-------------------------------------------------------------------
; описание: Отображение анализатора
; параметры: нет
; возвращаемое  значение: нет
;---------------------------------------------------------------------
Analyzer_view:
		ld	de,5402h
		ld	a,(Analyzer_ch0_vol)
		call	Analyzer_draw_left

		ld	de,5402h + 2
		ld	a,(Analyzer_ch1_vol)
		call	Analyzer_draw_left

		ld	de,5402h + 4
		ld	a,(Analyzer_ch2_vol)
		call	Analyzer_draw_left

		ld	de,5418h
		ld	a,(Analyzer_ch3_vol)
		call	Analyzer_draw_right

		ld	de,5418h + 2
		ld	a,(Analyzer_ch4_vol)
		call	Analyzer_draw_right

		ld	de,5418h + 4
		ld	a,(Analyzer_ch5_vol)
		jr	Analyzer_draw_right
;-------------------------------------------------------------------
; описание: Отрисовка левого канала анализатора
; параметры: HL - адрес экрана
;            C - позиция в индикаторе
; возвращаемое  значение: нет
;---------------------------------------------------------------------
Analyzer_draw_left:
		ld	bc,Analyzer_table_lphase
		jr	Analyzer_draw_view

Analyzer_draw_right:
		ld	bc,Analyzer_table_rphase

Analyzer_draw_view:
		ld	l,a
		ld	h,0
		add	hl,hl
		add	hl,bc
		ld	a,(hl)
		inc	hl
		ld	h,(hl)
		ld	l,a
		ex	de,hl

		ld	b,28				;размерность по Y
Analyzer_loop_Y:
		ld	c,h
		push	hl
		ex	hl,de
		ldi
		ldi
		ex	hl,de
		pop	hl
		inc	h
		ld	a,h
		and 	7
		jr	nz,Analyzer_next_line
		ld	a,l
		add	20h
		ld	l,a
		jr	c,Analyzer_next_line
		ld	a,h
		sub	8
		ld	h,a
Analyzer_next_line:
    		djnz    Analyzer_loop_Y
		ret	    

;-------------------------------------------------------------------
; описание: Отрисовка левого канала анализатора
; параметры: HL - адрес экрана
;            C - позиция в индикаторе
; возвращаемое  значение: нет
;---------------------------------------------------------------------
Analyzer_draw_flash:
		ld	a,(Analyzer_ch0_vol)
		ld	e,a
		ld	a,(Analyzer_ch3_vol)
		add	e
		and	0Fh
		ld	hl,Analyzer_table
		ld	e,a
		ld	d,0
		add	hl,de
		ld	a,(hl)
		ld	hl,5988h
		ld	(hl),a
		inc	l
		ld	(hl),a

		ld	a,(Analyzer_ch1_vol)
		ld	e,a
		ld	a,(Analyzer_ch4_vol)
		add	e
		and	0Fh
		ld	hl,Analyzer_table
		ld	e,a
		ld	d,0
		add	hl,de
		ld	a,(hl)
		ld	hl,599Ah
		ld	(hl),a
		inc	l
		inc	l
		ld	(hl),a
		inc	l
		ld	(hl),a

		ld	a,(Analyzer_ch2_vol)
		ld	e,a
		ld	a,(Analyzer_ch5_vol)
		add	e
		and	0Fh
		ld	hl,Analyzer_table
		ld	e,a
		ld	d,0
		add	hl,de
		ld	a,(hl)
		ld	hl,5AAAh
		ld	(hl),a
		inc	l
		ld	(hl),a
		inc	l
		ld	(hl),a
		inc	l
		ld	(hl),a
		inc	l
		ld	(hl),a
		inc	l
		ld	(hl),a
		inc	l
		ld	(hl),a
		inc	l
		ld	(hl),a
		inc	l
		ld	(hl),a
		inc	l
		ld	(hl),a
		inc	l
		ld	(hl),a
		inc	l
		ld	(hl),a

		ret

;-------------------------------------------------------------------
; описание: Обновление параметров анализатора
; параметры: нет
; возвращаемое  значение: нет
;---------------------------------------------------------------------
Analyzer_init:
              	ld	b, 6
		ld	hl,Analyzer_ch0_vol

Analyzer_init_loop:
                ld	(hl),0
		inc	hl
		djnz	Analyzer_init_loop
		ret
;-------------------------------------------------------------------
; описание:  Переменные правого и левого каналов анализатора
;---------------------------------------------------------------------
Analyzer_table:
		db	47h,47h,47h,46h,46h,46h,45h,45h,45h,44h,44h,44h,43h,43h,42h,42h	
;-------------------------------------------------------------------
; описание: Таблица адресов на фазы анализатора
;---------------------------------------------------------------------
Analyzer_table_lphase:
		dw	Analyzer_phase_000		;0
		dw	Analyzer_phase_001               ;1
		dw	Analyzer_phase_002               ;2
		dw	Analyzer_phase_003               ;3
		dw	Analyzer_phase_004               ;4
		dw	Analyzer_phase_005               ;5
		dw	Analyzer_phase_006               ;6
		dw	Analyzer_phase_007               ;7
		dw	Analyzer_phase_008               ;8
		dw	Analyzer_phase_009               ;9
		dw	Analyzer_phase_010               ;10
		dw	Analyzer_phase_011               ;11
		dw	Analyzer_phase_012               ;12
		dw	Analyzer_phase_013               ;13
		dw	Analyzer_phase_014               ;14
		dw	Analyzer_phase_015               ;15

Analyzer_table_rphase:
		dw	Analyzer_phase_100		;0
		dw	Analyzer_phase_101               ;1
		dw	Analyzer_phase_102               ;2
		dw	Analyzer_phase_103               ;3
		dw	Analyzer_phase_104               ;4
		dw	Analyzer_phase_105               ;5
		dw	Analyzer_phase_106               ;6
		dw	Analyzer_phase_107               ;7
		dw	Analyzer_phase_108               ;8
		dw	Analyzer_phase_109               ;9
		dw	Analyzer_phase_110               ;10
		dw	Analyzer_phase_111               ;11
		dw	Analyzer_phase_112               ;12
		dw	Analyzer_phase_113               ;13
		dw	Analyzer_phase_114               ;14
		dw	Analyzer_phase_115               ;15

Analyzer_phase_000:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	0Fh,0F0h
		db	0Bh,0F8h
		db	0Dh,0FCh
		db	06h,0FEh
		db	03h,7Fh
		db	01h,81h
		db	00h,0FFh

Analyzer_phase_001:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	0Fh,0F0h
		db	0Bh,0F8h
		db	0Dh,0FCh
		db	0Eh,0FEh
		db	07h,7Fh
		db	03h,81h
		db	01h,81h
		db	00h,0FFh

Analyzer_phase_002:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	0Fh,0F0h
		db	0Bh,0F8h
		db	0Dh,0FCh
		db	0Eh,0FEh
		db	0Fh,7Fh
		db	07h,81h
		db	03h,81h
		db	01h,81h
		db	00h,0FFh

Analyzer_phase_003:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	0Fh,0F0h
		db	0Bh,0F8h
		db	0Dh,0FCh
		db	0Eh,0FEh
		db	0Fh,7Fh
		db	0Fh,81h
		db	07h,81h
		db	03h,81h
		db	01h,81h
		db	00h,0FFh

Analyzer_phase_004:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	0Fh,0F0h
		db	0Bh,0F8h
		db	0Dh,0FCh
		db	0Eh,0FEh
		db	0Fh,7Fh
		db	0Fh,81h
		db	0Fh,81h
		db	07h,81h
		db	03h,81h
		db	01h,81h
		db	00h,0FFh

Analyzer_phase_005:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	0Fh,0F0h
		db	0Bh,0F8h
		db	0Dh,0FCh
		db	0Eh,0FEh
		db	0Fh,7Fh
		db	0Fh,81h
		db	0Fh,81h
		db	0Fh,81h
		db	07h,81h
		db	03h,81h
		db	01h,81h
		db	00h,0FFh

Analyzer_phase_006:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	0Fh,0F0h
		db	0Bh,0F8h
		db	0Dh,0FCh
		db	0Eh,0FEh
		db	0Fh,7Fh
		db	0Fh,81h
		db	0Fh,81h
		db	0Fh,81h
		db	0Fh,81h
		db	07h,81h
		db	03h,81h
		db	01h,81h
		db	00h,0FFh

Analyzer_phase_007:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	0Fh,0F0h
		db	0Bh,0F8h
		db	0Dh,0FCh
		db	0Eh,0FEh
		db	0Fh,7Fh
		db	0Fh,81h
		db	0Fh,81h
		db	0Fh,81h
		db	0Fh,81h
		db	0Fh,81h
		db	07h,81h
		db	03h,81h
		db	01h,81h
		db	00h,0FFh

Analyzer_phase_008:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	0Fh,0F0h
		db	0Bh,0F8h
		db	0Dh,0FCh
		db	0Eh,0FEh
		db	0Fh,7Fh
		db	0Fh,81h
		db	0Fh,81h
		db	0Fh,81h
		db	0Fh,81h
		db	0Fh,81h
		db	0Fh,81h
		db	07h,81h
		db	03h,81h
		db	01h,81h
		db	00h,0FFh

Analyzer_phase_009:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	0Fh,0F0h
		db	0Bh,0F8h
		db	0Dh,0FCh
		db	0Eh,0FEh
		db	0Fh,7Fh
		db	0Fh,81h
		db	0Fh,81h
		db	0Fh,81h
		db	0Fh,81h
		db	0Fh,81h
		db	0Fh,81h
		db	0Fh,81h
		db	07h,81h
		db	03h,81h
		db	01h,81h
		db	00h,0FFh

Analyzer_phase_010:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	0Fh,0F0h
		db	0Bh,0F8h
		db	0Dh,0FCh
		db	0Eh,0FEh
		db	0Fh,7Fh
		db	0Fh,81h
		db	0Fh,81h
		db	0Fh,81h
		db	0Fh,81h
		db	0Fh,81h
		db	0Fh,81h
		db	0Fh,81h
		db	0Fh,81h
		db	07h,81h
		db	03h,81h
		db	01h,81h
		db	00h,0FFh

Analyzer_phase_011:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	0Fh,0F0h
		db	0Bh,0F8h
		db	0Dh,0FCh
		db	0Eh,0FEh
		db	0Fh,7Fh
		db	0Fh,0FFh
		db	0Fh,81h
		db	0Fh,81h
		db	0Fh,81h
		db	0Fh,81h
		db	0Fh,81h
		db	0Fh,81h
		db	0Fh,81h
		db	0Fh,81h
		db	0Fh,81h
		db	0Fh,81h
		db	07h,81h
		db	03h,81h
		db	01h,81h
		db	00h,0FFh

Analyzer_phase_012:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	0Fh,0F0h
		db	0Bh,0F8h
		db	0Dh,0FCh
		db	0Eh,0FEh
		db	0Fh,7Fh
		db	0Fh,81h
		db	0Fh,81h
		db	0Fh,81h
		db	0Fh,81h
		db	0Fh,81h
		db	0Fh,81h
		db	0Fh,81h
		db	0Fh,81h
		db	0Fh,81h
		db	0Fh,81h
		db	0Fh,81h
		db	0Fh,81h
		db	07h,81h
		db	03h,81h
		db	01h,81h
		db	00h,0FFh

Analyzer_phase_013:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	0Fh,0F0h
		db	0Bh,0F8h
		db	0Dh,0FCh
		db	0Eh,0FEh
		db	0Fh,7Fh
		db	0Fh,81h
		db	0Fh,81h
		db	0Fh,81h
		db	0Fh,81h
		db	0Fh,81h
		db	0Fh,81h
		db	0Fh,81h
		db	0Fh,81h
		db	0Fh,81h
		db	0Fh,81h
		db	0Fh,81h
		db	0Fh,81h
		db	0Fh,81h
		db	0Fh,81h
		db	07h,81h
		db	03h,81h
		db	01h,81h
		db	00h,0FFh

Analyzer_phase_014:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	0Fh,0F0h
		db	0Bh,0F8h
		db	0Dh,0FCh
		db	0Eh,0FEh
		db	0Fh,7Fh
		db	0Fh,81h
		db	0Fh,81h
		db	0Fh,81h
		db	0Fh,81h
		db	0Fh,81h
		db	0Fh,81h
		db	0Fh,81h
		db	0Fh,81h
		db	0Fh,81h
		db	0Fh,81h
		db	0Fh,81h
		db	0Fh,81h
		db	0Fh,81h
		db	0Fh,81h
		db	0Fh,81h
		db	0Fh,81h
		db	07h,81h
		db	03h,81h
		db	01h,81h
		db	00h,0FFh

Analyzer_phase_015:
		db	0Fh,0F0h
		db	0Bh,0F8h
		db	0Dh,0FCh
		db	0Eh,0FEh
		db	0Fh,7Fh
		db	0Fh,81h
		db	0Fh,81h
		db	0Fh,81h
		db	0Fh,81h
		db	0Fh,81h
		db	0Fh,81h
		db	0Fh,81h
		db	0Fh,81h
		db	0Fh,81h
		db	0Fh,81h
		db	0Fh,81h
		db	0Fh,81h
		db	0Fh,81h
		db	0Fh,81h
		db	0Fh,81h
		db	0Fh,81h
		db	0Fh,81h
		db	0Fh,81h
		db	0Fh,81h
		db	07h,81h
		db	03h,81h
		db	01h,81h
		db	00h,0FFh

Analyzer_phase_100:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	0Fh,0F0h
		db	1Fh,0D0h
		db	3Fh,0B0h
		db	7Fh,60h
		db	0FEh,0C0h
		db	81h,80h
		db	0FFh,00h

Analyzer_phase_101:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	0Fh,0F0h
		db	1Fh,0D0h
		db	3Fh,0B0h
		db	7Fh,70h
		db	0FEh,0E0h
		db	81h,0C0h
		db	81h,80h
		db	0FFh,00h

Analyzer_phase_102:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	0Fh,0F0h
		db	1Fh,0D0h
		db	3Fh,0B0h
		db	7Fh,70h
		db	0FEh,0F0h
		db	81h,0E0h
		db	81h,0C0h
		db	81h,80h
		db	0FFh,00h

Analyzer_phase_103:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	0Fh,0F0h
		db	1Fh,0D0h
		db	3Fh,0B0h
		db	7Fh,70h
		db	0FEh,0F0h
		db	81h,0F0h
		db	81h,0E0h
		db	81h,0C0h
		db	81h,80h
		db	0FFh,00h

Analyzer_phase_104:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	0Fh,0F0h
		db	1Fh,0D0h
		db	3Fh,0B0h
		db	7Fh,70h
		db	0FEh,0F0h
		db	81h,0F0h
		db	81h,0F0h
		db	81h,0E0h
		db	81h,0C0h
		db	81h,80h
		db	0FFh,00h

Analyzer_phase_105:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	0Fh,0F0h
		db	1Fh,0D0h
		db	3Fh,0B0h
		db	7Fh,70h
		db	0FEh,0F0h
		db	81h,0F0h
		db	81h,0F0h
		db	81h,0F0h
		db	81h,0E0h
		db	81h,0C0h
		db	81h,80h
		db	0FFh,00h

Analyzer_phase_106:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	0Fh,0F0h
		db	1Fh,0D0h
		db	3Fh,0B0h
		db	7Fh,70h
		db	0FEh,0F0h
		db	81h,0F0h
		db	81h,0F0h
		db	81h,0F0h
		db	81h,0F0h
		db	81h,0E0h
		db	81h,0C0h
		db	81h,80h
		db	0FFh,00h

Analyzer_phase_107:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	0Fh,0F0h
		db	1Fh,0D0h
		db	3Fh,0B0h
		db	7Fh,70h
		db	0FEh,0F0h
		db	81h,0F0h
		db	81h,0F0h
		db	81h,0F0h
		db	81h,0F0h
		db	81h,0F0h
		db	81h,0E0h
		db	81h,0C0h
		db	81h,80h
		db	0FFh,00h

Analyzer_phase_108:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	0Fh,0F0h
		db	1Fh,0D0h
		db	3Fh,0B0h
		db	7Fh,70h
		db	0FEh,0F0h
		db	81h,0F0h
		db	81h,0F0h
		db	81h,0F0h
		db	81h,0F0h
		db	81h,0F0h
		db	81h,0F0h
		db	81h,0E0h
		db	81h,0C0h
		db	81h,80h
		db	0FFh,00h

Analyzer_phase_109:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	0Fh,0F0h
		db	1Fh,0D0h
		db	3Fh,0B0h
		db	7Fh,70h
		db	0FEh,0F0h
		db	81h,0F0h
		db	81h,0F0h
		db	81h,0F0h
		db	81h,0F0h
		db	81h,0F0h
		db	81h,0F0h
		db	81h,0F0h
		db	81h,0E0h
		db	81h,0C0h
		db	81h,80h
		db	0FFh,00h

Analyzer_phase_110:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	0Fh,0F0h
		db	1Fh,0D0h
		db	3Fh,0B0h
		db	7Fh,70h
		db	0FEh,0F0h
		db	81h,0F0h
		db	81h,0F0h
		db	81h,0F0h
		db	81h,0F0h
		db	81h,0F0h
		db	81h,0F0h
		db	81h,0F0h
		db	81h,0F0h
		db	81h,0E0h
		db	81h,0C0h
		db	81h,80h
		db	0FFh,00h

Analyzer_phase_111:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	0Fh,0F0h
		db	1Fh,0D0h
		db	3Fh,0B0h
		db	7Fh,70h
		db	0FEh,0F0h
		db	0FFh,0F0h
		db	81h,0F0h
		db	81h,0F0h
		db	81h,0F0h
		db	81h,0F0h
		db	81h,0F0h
		db	81h,0F0h
		db	81h,0F0h
		db	81h,0F0h
		db	81h,0F0h
		db	81h,0F0h
		db	81h,0E0h
		db	81h,0C0h
		db	81h,80h
		db	0FFh,00h

Analyzer_phase_112:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	0Fh,0F0h
		db	1Fh,0D0h
		db	3Fh,0B0h
		db	7Fh,70h
		db	0FEh,0F0h
		db	81h,0F0h
		db	81h,0F0h
		db	81h,0F0h
		db	81h,0F0h
		db	81h,0F0h
		db	81h,0F0h
		db	81h,0F0h
		db	81h,0F0h
		db	81h,0F0h
		db	81h,0F0h
		db	81h,0F0h
		db	81h,0F0h
		db	81h,0E0h
		db	81h,0C0h
		db	81h,80h
		db	0FFh,00h

Analyzer_phase_113:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	0Fh,0F0h
		db	1Fh,0D0h
		db	3Fh,0B0h
		db	7Fh,70h
		db	0FEh,0F0h
		db	81h,0F0h
		db	81h,0F0h
		db	81h,0F0h
		db	81h,0F0h
		db	81h,0F0h
		db	81h,0F0h
		db	81h,0F0h
		db	81h,0F0h
		db	81h,0F0h
		db	81h,0F0h
		db	81h,0F0h
		db	81h,0F0h
		db	81h,0F0h
		db	81h,0F0h
		db	81h,0E0h
		db	81h,0C0h
		db	81h,80h
		db	0FFh,00h

Analyzer_phase_114:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	0Fh,0F0h
		db	1Fh,0D0h
		db	3Fh,0B0h
		db	7Fh,70h
		db	0FEh,0F0h
		db	81h,0F0h
		db	81h,0F0h
		db	81h,0F0h
		db	81h,0F0h
		db	81h,0F0h
		db	81h,0F0h
		db	81h,0F0h
		db	81h,0F0h
		db	81h,0F0h
		db	81h,0F0h
		db	81h,0F0h
		db	81h,0F0h
		db	81h,0F0h
		db	81h,0F0h
		db	81h,0F0h
		db	81h,0F0h
		db	81h,0E0h
		db	81h,0C0h
		db	81h,80h
		db	0FFh,00h

Analyzer_phase_115:
		db	0Fh,0F0h
		db	1Fh,0D0h
		db	3Fh,0B0h
		db	7Fh,70h
		db	0FEh,0F0h
		db	81h,0F0h
		db	81h,0F0h
		db	81h,0F0h
		db	81h,0F0h
		db	81h,0F0h
		db	81h,0F0h
		db	81h,0F0h
		db	81h,0F0h
		db	81h,0F0h
		db	81h,0F0h
		db	81h,0F0h
		db	81h,0F0h
		db	81h,0F0h
		db	81h,0F0h
		db	81h,0F0h
		db	81h,0F0h
		db	81h,0F0h
		db	81h,0F0h
		db	81h,0F0h
		db	81h,0E0h
		db	81h,0C0h
		db	81h,80h
		db	0FFh,00h

;-------------------------------------------------------------------
; описание:  Переменные правого и левого каналов анализатора
;---------------------------------------------------------------------
Analyzer_ch0_vol:
		db	0
Analyzer_ch1_vol:
		db	0
Analyzer_ch2_vol:
		db	0
Analyzer_ch3_vol:
		db	0
Analyzer_ch4_vol:
		db	0
Analyzer_ch5_vol:
		db	0
