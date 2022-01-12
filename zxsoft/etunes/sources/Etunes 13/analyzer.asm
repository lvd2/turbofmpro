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
		ld	a,(Analyzer_ch0_vol)
		ld	de,4C20h
		call	Analyzer_draw

		ld	a,(Analyzer_ch1_vol)
		ld	de,4C3Ah
		call	Analyzer_draw

		ld	a,(Analyzer_ch2_vol)
		ld	de,4CC0h
		call	Analyzer_draw

		ld	a,(Analyzer_ch3_vol)
		ld	de,4CDAh
		call	Analyzer_draw

		ld	a,(Analyzer_ch4_vol)
		ld	de,5460h
		call	Analyzer_draw

		ld	a,(Analyzer_ch5_vol)
		ld	de,547Ah
;-------------------------------------------------------------------
; описание: Отрисовка левого канала анализатора
; параметры: HL - адрес экрана
;            C - позиция в индикаторе
; возвращаемое  значение: нет
;---------------------------------------------------------------------
Analyzer_draw:

		ld	l,a
		ld	h,0
		add	hl,hl
		ld	bc,Analyzer_table_phase
		add	hl,bc
		ld	a,(hl)
		inc	hl
		ld	h,(hl)
		ld	l,a
		ex	de,hl

		ld	b,24				;размерность по Y
Analyzer_loop_Y:
		ld	c,10
		push	hl
		ex	hl,de
		ldi
		ldi
		ldi
		ldi
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
		ld	hl,5906h
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
		ld	hl,591Ch
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
		ld	hl,5AEAh
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
		db	47h,47h,47h,47h,46h,46h,45h,45h,44h,44h,43h,43h,42h,42h,41h,41h	

;-------------------------------------------------------------------
; описание: Таблица адресов на фазы анализатора
;---------------------------------------------------------------------
Analyzer_table_phase:
		dw	Analyzer_phase_00		;0
		dw	Analyzer_phase_01               ;1
		dw	Analyzer_phase_02               ;2
		dw	Analyzer_phase_03               ;3
		dw	Analyzer_phase_04               ;4
		dw	Analyzer_phase_05               ;5
		dw	Analyzer_phase_06               ;6
		dw	Analyzer_phase_07               ;7
		dw	Analyzer_phase_08               ;8
		dw	Analyzer_phase_09               ;9
		dw	Analyzer_phase_10               ;10
		dw	Analyzer_phase_11               ;11
		dw	Analyzer_phase_12               ;12
		dw	Analyzer_phase_13               ;13
		dw	Analyzer_phase_14               ;14
		dw	Analyzer_phase_15               ;15


Analyzer_phase_00:
		db	0FFh,0FFh,0C7h,0F1h,0FFh,0FFh
		db	0FFh,0FFh,8Fh,0F8h,0FFh,0FFh
		db	0FFh,0FFh,9Fh,0FCh,0FFh,0FFh
		db	0FFh,0FFh,9Fh,0FCh,0FFh,0FFh
		db	0FFh,0FFh,9Fh,0FCh,0FFh,0FFh
		db	0FFh,0FFh,9Fh,0FCh,0FFh,0FFh
		db	0FFh,0FFh,9Fh,0FCh,0FFh,0FFh
		db	0FFh,0FFh,9Fh,0FCh,0FFh,0FFh
		db	0FFh,0FFh,5Fh,0FDh,7Fh,0FFh
		db	0FFh,0FEh,5Fh,0FDh,3Fh,0FFh
		db	0FFh,0FDh,5Fh,0FDh,5Fh,0FFh
		db	0FFh,0F8h,2Fh,0FAh,0Fh,0FFh
		db	0FFh,0F1h,40h,01h,47h,0FFh
		db	0FFh,0E2h,44h,91h,23h,0FFh
		db	0FFh,0C4h,4Dh,0D9h,11h,0FFh
		db	0FFh,8Ah,40h,01h,28h,0FFh
		db	0FFh,17h,4Dh,0D9h,74h,7Fh
		db	0FEh,2Fh,4Dh,0D9h,7Ah,3Fh
		db	0FCh,5Fh,40h,01h,7Dh,1Fh
		db	0F8h,0BFh,4Dh,0D9h,7Eh,8Fh
		db	0F1h,7Fh,4Dh,0D9h,7Fh,47h
		db	0E2h,0FFh,40h,01h,7Fh,0AFh
		db	0F5h,0FFh,4Dh,0D9h,7Fh,0D7h
		db	0EBh,0FFh,2Dh,0DAh,7Fh,0FFh

Analyzer_phase_01:
		db	0FFh,0FFh,0C7h,0F1h,0FFh,0FFh
		db	0FFh,0FFh,8Fh,0F8h,0FFh,0FFh
		db	0FFh,0FFh,9Fh,0FCh,0FFh,0FFh
		db	0FFh,0FFh,9Fh,7Ch,0FFh,0FFh
		db	0FFh,0FFh,9Fh,0FCh,0FFh,0FFh
		db	0FFh,0FFh,9Fh,7Ch,0FFh,0FFh
		db	0FFh,0FFh,9Fh,0FCh,0FFh,0FFh
		db	0FFh,0FFh,9Fh,7Ch,0FFh,0FFh
		db	0FFh,0FFh,5Fh,0FDh,7Fh,0FFh
		db	0FFh,0FCh,5Fh,7Dh,1Fh,0FFh
		db	0FFh,0F9h,5Fh,0FDh,4Fh,0FFh
		db	0FFh,0F0h,2Fh,0FAh,07h,0FFh
		db	0FFh,0E1h,40h,01h,43h,0FFh
		db	0FFh,0C4h,44h,91h,11h,0FFh
		db	0FFh,92h,4Dh,0D9h,24h,0FFh
		db	0FFh,2Eh,40h,01h,3Ah,7Fh
		db	0FEh,5Fh,4Dh,0D9h,7Dh,3Fh
		db	0FCh,0BFh,4Dh,0D9h,7Eh,9Fh
		db	0F9h,7Fh,40h,01h,7Fh,4Fh
		db	0F2h,0FFh,4Dh,0D9h,7Fh,0A7h
		db	0E5h,0FFh,4Dh,0D9h,7Fh,0D3h
		db	0CBh,0FFh,40h,01h,7Fh,0E9h
		db	0E7h,0FFh,4Dh,0D9h,7Fh,0F3h
		db	0FFh,0FFh,2Dh,0DAh,7Fh,0FFh

Analyzer_phase_02:
		db	0FFh,0FFh,0C7h,0F1h,0FFh,0FFh
		db	0FFh,0FFh,8Fh,0F8h,0FFh,0FFh
		db	0FFh,0FFh,9Fh,0FCh,0FFh,0FFh
		db	0FFh,0FFh,9Fh,7Ch,0FFh,0FFh
		db	0FFh,0FFh,9Fh,0FCh,0FFh,0FFh
		db	0FFh,0FFh,9Fh,7Ch,0FFh,0FFh
		db	0FFh,0FFh,9Fh,0FCh,0FFh,0FFh
		db	0FFh,0FFh,9Dh,0DCh,0FFh,0FFh
		db	0FFh,0FEh,5Fh,0FDh,7Fh,0FFh
		db	0FFh,0F9h,5Fh,0FDh,1Fh,0FFh
		db	0FFh,0F0h,5Fh,0FDh,47h,0FFh
		db	0FFh,0E0h,2Fh,0FAh,03h,0FFh
		db	0FFh,0C1h,40h,01h,41h,0FFh
		db	0FFh,84h,44h,91h,10h,0FFh
		db	0FEh,12h,4Dh,0D9h,24h,3Fh
		db	0FCh,2Eh,40h,01h,3Ah,1Fh
		db	0F8h,9Fh,4Dh,0D9h,7Ch,8Fh
		db	0E1h,7Fh,4Dh,0D9h,7Fh,43h
		db	0C2h,0FFh,40h,01h,7Fh,0A1h
		db	89h,0FFh,4Dh,0D9h,7Fh,0C8h
		db	97h,0FFh,4Dh,0D9h,7Fh,0F4h
		db	0CFh,0FFh,40h,01h,7Fh,0F9h
		db	0FFh,0FFh,4Dh,0D9h,7Fh,0FFh
		db	0FFh,0FFh,2Dh,0DAh,7Fh,0FFh

Analyzer_phase_03:
		db	0FFh,0FFh,0C7h,0F1h,0FFh,0FFh
		db	0FFh,0FFh,8Fh,0F8h,0FFh,0FFh
		db	0FFh,0FFh,9Fh,0FCh,0FFh,0FFh
		db	0FFh,0FFh,9Fh,0FCh,0FFh,0FFh
		db	0FFh,0FFh,9Fh,0FCh,0FFh,0FFh
		db	0FFh,0FFh,9Fh,0FCh,0FFh,0FFh
		db	0FFh,0FFh,9Fh,7Ch,0FFh,0FFh
		db	0FFh,0FFh,9Dh,0DCh,0FFh,0FFh
		db	0FFh,0FFh,5Fh,7Dh,7Fh,0FFh
		db	0FFh,0FEh,5Fh,0FDh,3Fh,0FFh
		db	0FFh,0F1h,5Fh,0FDh,47h,0FFh
		db	0FFh,0C0h,2Fh,0FAh,01h,0FFh
		db	0FFh,81h,40h,01h,40h,0FFh
		db	0FEh,10h,44h,91h,04h,3Fh
		db	0FCh,4Eh,4Dh,0D9h,39h,1Fh
		db	0F0h,0BEh,40h,01h,3Eh,87h
		db	0C2h,7Fh,4Dh,0D9h,7Fh,21h
		db	85h,0FFh,4Dh,0D9h,7Fh,0D0h
		db	93h,0FFh,40h,01h,7Fh,0E4h
		db	0CFh,0FFh,4Dh,0D9h,7Fh,0F9h
		db	0FFh,0FFh,4Dh,0D9h,7Fh,0FFh
		db	0FFh,0FFh,40h,01h,7Fh,0FFh
		db	0FFh,0FFh,4Dh,0D9h,7Fh,0FFh
		db	0FFh,0FFh,2Dh,0DAh,7Fh,0FFh

Analyzer_phase_04:
		db	0FFh,0FFh,0C7h,0F1h,0FFh,0FFh
		db	0FFh,0FFh,8Fh,0F8h,0FFh,0FFh
		db	0FFh,0FFh,9Fh,0FCh,0FFh,0FFh
		db	0FFh,0FFh,9Fh,0FCh,0FFh,0FFh
		db	0FFh,0FFh,9Fh,0FCh,0FFh,0FFh
		db	0FFh,0FFh,9Fh,0FCh,0FFh,0FFh
		db	0FFh,0FFh,9Eh,0BCh,0FFh,0FFh
		db	0FFh,0FFh,9Bh,0ECh,0FFh,0FFh
		db	0FFh,0FFh,5Fh,7Dh,7Fh,0FFh
		db	0FFh,0FAh,5Fh,0FDh,2Fh,0FFh
		db	0FFh,0E1h,5Fh,0FDh,43h,0FFh
		db	0FFh,80h,2Fh,0FAh,00h,0FFh
		db	0FFh,09h,40h,01h,48h,7Fh
		db	0F8h,24h,44h,91h,12h,0Fh
		db	0E0h,9Eh,4Dh,0D9h,3Ch,83h
		db	0C2h,7Eh,40h,01h,3Fh,21h
		db	89h,0FFh,4Dh,0D9h,7Fh,0C8h
		db	0D7h,0FFh,4Dh,0D9h,7Fh,0F5h
		db	0FFh,0FFh,40h,01h,7Fh,0FFh
		db	0FFh,0FFh,4Dh,0D9h,7Fh,0FFh
		db	0FFh,0FFh,4Dh,0D9h,7Fh,0FFh
		db	0FFh,0FFh,40h,01h,7Fh,0FFh
		db	0FFh,0FFh,4Dh,0D9h,7Fh,0FFh
		db	0FFh,0FFh,2Dh,0DAh,7Fh,0FFh

Analyzer_phase_05:
		db	0FFh,0FFh,0C7h,0F1h,0FFh,0FFh
		db	0FFh,0FFh,8Fh,0F8h,0FFh,0FFh
		db	0FFh,0FFh,9Fh,0FCh,0FFh,0FFh
		db	0FFh,0FFh,9Fh,0FCh,0FFh,0FFh
		db	0FFh,0FFh,9Fh,0FCh,0FFh,0FFh
		db	0FFh,0FFh,9Fh,0FCh,0FFh,0FFh
		db	0FFh,0FFh,9Fh,7Ch,0FFh,0FFh
		db	0FFh,0FFh,9Bh,0ECh,0FFh,0FFh
		db	0FFh,0FFh,5Fh,0FDh,7Fh,0FFh
		db	0FFh,0E2h,5Fh,7Dh,23h,0FFh
		db	0FFh,01h,5Fh,0FDh,40h,7Fh
		db	0F8h,08h,2Fh,0FAh,08h,0Fh
		db	0E0h,45h,40h,01h,51h,03h
		db	0C1h,3Ch,44h,91h,1Eh,41h
		db	88h,0FEh,4Dh,0D9h,3Fh,88h
		db	0D7h,0FEh,40h,01h,3Fh,0F5h
		db	0FFh,0FFh,4Dh,0D9h,7Fh,0FFh
		db	0FFh,0FFh,4Dh,0D9h,7Fh,0FFh
		db	0FFh,0FFh,40h,01h,7Fh,0FFh
		db	0FFh,0FFh,4Dh,0D9h,7Fh,0FFh
		db	0FFh,0FFh,4Dh,0D9h,7Fh,0FFh
		db	0FFh,0FFh,40h,01h,7Fh,0FFh
		db	0FFh,0FFh,4Dh,0D9h,7Fh,0FFh
		db	0FFh,0FFh,2Dh,0DAh,7Fh,0FFh

Analyzer_phase_06:
		db	0FFh,0FFh,0C7h,0F1h,0FFh,0FFh
		db	0FFh,0FFh,8Fh,0F8h,0FFh,0FFh
		db	0FFh,0FFh,9Fh,0FCh,0FFh,0FFh
		db	0FFh,0FFh,9Fh,0FCh,0FFh,0FFh
		db	0FFh,0FFh,9Fh,0FCh,0FFh,0FFh
		db	0FFh,0FFh,9Fh,0FCh,0FFh,0FFh
		db	0FFh,0FFh,9Fh,0FCh,0FFh,0FFh
		db	0FFh,0FFh,9Bh,6Ch,0FFh,0FFh
		db	0FFh,0FFh,5Fh,0FDh,7Fh,0FFh
		db	0FFh,0FCh,5Fh,7Dh,1Fh,0FFh
		db	0FCh,01h,5Fh,0FDh,40h,1Fh
		db	0C0h,00h,2Fh,0FAh,00h,01h
		db	80h,0A9h,40h,01h,4Ah,80h
		db	0AAh,04h,44h,91h,10h,2Ah
		db	0C0h,0FEh,4Dh,0D9h,3Fh,81h
		db	0FFh,0FEh,40h,01h,7Fh,0FFh
		db	0FFh,0FFh,4Dh,0D9h,7Fh,0FFh
		db	0FFh,0FFh,4Dh,0D9h,7Fh,0FFh
		db	0FFh,0FFh,40h,01h,7Fh,0FFh
		db	0FFh,0FFh,4Dh,0D9h,7Fh,0FFh
		db	0FFh,0FFh,4Dh,0D9h,7Fh,0FFh
		db	0FFh,0FFh,40h,01h,7Fh,0FFh
		db	0FFh,0FFh,4Dh,0D9h,7Fh,0FFh
		db	0FFh,0FFh,2Dh,0DAh,7Fh,0FFh

Analyzer_phase_07:
		db	0FFh,0FFh,0C7h,0F1h,0FFh,0FFh
		db	0FFh,0FFh,8Fh,0F8h,0FFh,0FFh
		db	0FFh,0FFh,9Fh,0FCh,0FFh,0FFh
		db	0FFh,0FFh,9Fh,0FCh,0FFh,0FFh
		db	0FFh,0FFh,9Fh,0FCh,0FFh,0FFh
		db	0FFh,0FFh,9Fh,0FCh,0FFh,0FFh
		db	0FFh,0FFh,9Fh,0FCh,0FFh,0FFh
		db	0FFh,0FFh,9Bh,6Ch,0FFh,0FFh
		db	0FFh,0FFh,5Fh,0FDh,7Fh,0FFh
		db	0FFh,0FEh,5Fh,0FDh,3Fh,0FFh
		db	0FFh,0FDh,5Fh,0FDh,5Fh,0FFh
		db	0C0h,00h,2Fh,0FAh,00h,01h
		db	80h,01h,40h,01h,40h,00h
		db	0D5h,54h,44h,91h,15h,55h
		db	80h,02h,4Dh,0D9h,20h,00h
		db	0FFh,0FEh,40h,01h,3Fh,0FFh
		db	0FFh,0FFh,4Dh,0D9h,7Fh,0FFh
		db	0FFh,0FFh,4Dh,0D9h,7Fh,0FFh
		db	0FFh,0FFh,40h,01h,7Fh,0FFh
		db	0FFh,0FFh,4Dh,0D9h,7Fh,0FFh
		db	0FFh,0FFh,4Dh,0D9h,7Fh,0FFh
		db	0FFh,0FFh,40h,01h,7Fh,0FFh
		db	0FFh,0FFh,4Dh,0D9h,7Fh,0FFh
		db	0FFh,0FFh,2Dh,0DAh,7Fh,0FFh

Analyzer_phase_08:
		db	0FFh,0FFh,0C7h,0F1h,0FFh,0FFh
		db	0FFh,0FFh,8Fh,0F8h,0FFh,0FFh
		db	0FFh,0FFh,9Fh,0FCh,0FFh,0FFh
		db	0FFh,0FFh,9Fh,0FCh,0FFh,0FFh
		db	0FFh,0FFh,9Fh,0FCh,0FFh,0FFh
		db	0FFh,0FFh,9Fh,0FCh,0FFh,0FFh
		db	0FFh,0FFh,9Dh,0DCh,0FFh,0FFh
		db	0FFh,0FFh,9Fh,0FCh,0FFh,0FFh
		db	0FFh,0FFh,5Fh,7Dh,7Fh,0FFh
		db	0FFh,0FEh,5Fh,0FDh,3Fh,0FFh
		db	0C0h,7Dh,5Fh,0FDh,5Fh,01h
		db	80h,00h,2Fh,0FAh,00h,00h
		db	0A4h,01h,40h,01h,40h,12h
		db	0C0h,90h,44h,91h,04h,81h
		db	0FFh,02h,4Dh,0D9h,20h,7Fh
		db	0FFh,0FEh,40h,01h,3Fh,0FFh
		db	0FFh,0FFh,4Dh,0D9h,7Fh,0FFh
		db	0FFh,0FFh,4Dh,0D9h,7Fh,0FFh
		db	0FFh,0FFh,40h,01h,7Fh,0FFh
		db	0FFh,0FFh,4Dh,0D9h,7Fh,0FFh
		db	0FFh,0FFh,4Dh,0D9h,7Fh,0FFh
		db	0FFh,0FFh,40h,01h,7Fh,0FFh
		db	0FFh,0FFh,4Dh,0D9h,7Fh,0FFh
		db	0FFh,0FFh,2Dh,0DAh,7Fh,0FFh

Analyzer_phase_09:
		db	0FFh,0FFh,0C7h,0F1h,0FFh,0FFh
		db	0FFh,0FFh,8Fh,0F8h,0FFh,0FFh
		db	0FFh,0FFh,9Fh,0FCh,0FFh,0FFh
		db	0FFh,0FFh,9Fh,0FCh,0FFh,0FFh
		db	0FFh,0FFh,9Fh,0FCh,0FFh,0FFh
		db	0FFh,0FFh,9Fh,0FCh,0FFh,0FFh
		db	0FFh,0FFh,9Dh,0DCh,0FFh,0FFh
		db	0FFh,0FFh,9Fh,0FCh,0FFh,0FFh
		db	0FFh,0FFh,5Bh,6Dh,7Fh,0FFh
		db	0C0h,0FEh,5Fh,0FDh,3Fh,81h
		db	80h,0Dh,5Fh,0FDh,58h,00h
		db	0A0h,00h,2Fh,0FAh,00h,02h
		db	0C2h,01h,40h,01h,40h,21h
		db	0FCh,20h,44h,91h,02h,1Fh
		db	0FFh,0C4h,4Dh,0D9h,11h,0FFh
		db	0FFh,0FEh,40h,01h,3Fh,0FFh
		db	0FFh,0FFh,4Dh,0D9h,7Fh,0FFh
		db	0FFh,0FFh,4Dh,0D9h,7Fh,0FFh
		db	0FFh,0FFh,40h,01h,7Fh,0FFh
		db	0FFh,0FFh,4Dh,0D9h,7Fh,0FFh
		db	0FFh,0FFh,4Dh,0D9h,7Fh,0FFh
		db	0FFh,0FFh,40h,01h,7Fh,0FFh
		db	0FFh,0FFh,4Dh,0D9h,7Fh,0FFh
		db	0FFh,0FFh,2Dh,0DAh,7Fh,0FFh

Analyzer_phase_10:
		db	0FFh,0FFh,0C7h,0F1h,0FFh,0FFh
		db	0FFh,0FFh,8Fh,0F8h,0FFh,0FFh
		db	0FFh,0FFh,9Fh,0FCh,0FFh,0FFh
		db	0FFh,0FFh,9Fh,0FCh,0FFh,0FFh
		db	0FFh,0FFh,9Fh,0FCh,0FFh,0FFh
		db	0FFh,0FFh,9Fh,0FCh,0FFh,0FFh
		db	0FFh,0FFh,9Bh,0ECh,0FFh,0FFh
		db	0FFh,0FFh,9Fh,7Ch,0FFh,0FFh
		db	0C7h,0FFh,5Bh,0EDh,7Fh,0F1h
		db	80h,0FEh,5Fh,0FDh,3Fh,80h
		db	0D0h,3Dh,5Fh,0FDh,5Eh,05h
		db	0E4h,04h,2Fh,0FAh,10h,13h
		db	0F8h,81h,40h,01h,40h,8Fh
		db	0FFh,10h,44h,91h,04h,7Fh
		db	0FFh,0E2h,4Dh,0D9h,23h,0FFh
		db	0FFh,0FEh,40h,01h,3Fh,0FFh
		db	0FFh,0FFh,4Dh,0D9h,7Fh,0FFh
		db	0FFh,0FFh,4Dh,0D9h,7Fh,0FFh
		db	0FFh,0FFh,40h,01h,7Fh,0FFh
		db	0FFh,0FFh,4Dh,0D9h,7Fh,0FFh
		db	0FFh,0FFh,4Dh,0D9h,7Fh,0FFh
		db	0FFh,0FFh,40h,01h,7Fh,0FFh
		db	0FFh,0FFh,4Dh,0D9h,7Fh,0FFh
		db	0FFh,0FFh,2Dh,0DAh,7Fh,0FFh

Analyzer_phase_11:
		db	0FFh,0FFh,0C7h,0F1h,0FFh,0FFh
		db	0FFh,0FFh,8Fh,0F8h,0FFh,0FFh
		db	0FFh,0FFh,9Fh,0FCh,0FFh,0FFh
		db	0FFh,0FFh,9Fh,0FCh,0FFh,0FFh
		db	0FFh,0FFh,9Dh,0DCh,0FFh,0FFh
		db	0FFh,0FFh,9Fh,0FCh,0FFh,0FFh
		db	0C7h,0FFh,9Bh,0ECh,0FFh,0F1h
		db	81h,0FFh,9Fh,0FCh,0FFh,0C0h
		db	0D0h,7Fh,5Fh,7Dh,7Fh,05h
		db	0E4h,1Eh,5Fh,0FDh,3Ch,13h
		db	0F8h,85h,5Fh,0FDh,50h,8Fh
		db	0FFh,40h,2Fh,0FAh,01h,7Fh
		db	0FFh,91h,40h,01h,44h,0FFh
		db	0FFh,0E4h,44h,91h,13h,0FFh
		db	0FFh,0FAh,4Dh,0D9h,2Fh,0FFh
		db	0FFh,0FEh,40h,01h,3Fh,0FFh
		db	0FFh,0FFh,4Dh,0D9h,7Fh,0FFh
		db	0FFh,0FFh,4Dh,0D9h,7Fh,0FFh
		db	0FFh,0FFh,40h,01h,7Fh,0FFh
		db	0FFh,0FFh,4Dh,0D9h,7Fh,0FFh
		db	0FFh,0FFh,4Dh,0D9h,7Fh,0FFh
		db	0FFh,0FFh,40h,01h,7Fh,0FFh
		db	0FFh,0FFh,4Dh,0D9h,7Fh,0FFh
		db	0FFh,0FFh,2Dh,0DAh,7Fh,0FFh

Analyzer_phase_12:
		db	0FFh,0FFh,0C7h,0F1h,0FFh,0FFh
		db	0FFh,0FFh,8Fh,0F8h,0FFh,0FFh
		db	0FFh,0FFh,9Fh,0FCh,0FFh,0FFh
		db	0FFh,0FFh,9Fh,0FCh,0FFh,0FFh
		db	0CFh,0FFh,9Eh,0BCh,0FFh,0F9h
		db	83h,0FFh,9Fh,0FCh,0FFh,0E0h
		db	0A1h,0FFh,9Bh,6Ch,0FFh,0C2h
		db	0C8h,7Fh,9Fh,0FCh,0FFh,09h
		db	0F2h,3Fh,5Bh,0EDh,7Eh,27h
		db	0FDh,0Eh,5Fh,0FDh,38h,5Fh
		db	0FEh,41h,5Fh,0FDh,41h,3Fh
		db	0FFh,0A0h,2Fh,0FAh,02h,0FFh
		db	0FFh,0C9h,40h,01h,49h,0FFh
		db	0FFh,0F4h,44h,91h,17h,0FFh
		db	0FFh,0FAh,4Dh,0D9h,2Fh,0FFh
		db	0FFh,0FEh,40h,01h,3Fh,0FFh
		db	0FFh,0FFh,4Dh,0D9h,7Fh,0FFh
		db	0FFh,0FFh,4Dh,0D9h,7Fh,0FFh
		db	0FFh,0FFh,40h,01h,7Fh,0FFh
		db	0FFh,0FFh,4Dh,0D9h,7Fh,0FFh
		db	0FFh,0FFh,4Dh,0D9h,7Fh,0FFh
		db	0FFh,0FFh,40h,01h,7Fh,0FFh
		db	0FFh,0FFh,4Dh,0D9h,7Fh,0FFh
		db	0FFh,0FFh,2Dh,0DAh,7Fh,0FFh

Analyzer_phase_13:
		db	0FFh,0FFh,0C7h,0F1h,0FFh,0FFh
		db	0FFh,0FFh,8Fh,0F8h,0FFh,0FFh
		db	0CFh,0FFh,9Fh,7Ch,0FFh,0F9h
		db	87h,0FFh,9Fh,0FCh,0FFh,0F0h
		db	0A1h,0FFh,9Dh,0DCh,0FFh,0C2h
		db	0D0h,0FFh,9Fh,0FCh,0FFh,85h
		db	0E4h,7Fh,9Bh,0ECh,0FFh,13h
		db	0FAh,1Fh,9Fh,0FCh,0FCh,2Fh
		db	0FDh,0Fh,5Bh,6Dh,78h,5Fh
		db	0FEh,42h,5Fh,0FDh,21h,3Fh
		db	0FFh,0A1h,5Fh,0FDh,42h,0FFh
		db	0FFh,0D0h,2Fh,0FAh,05h,0FFh
		db	0FFh,0E9h,40h,01h,4Bh,0FFh
		db	0FFh,0F4h,44h,91h,17h,0FFh
		db	0FFh,0FCh,4Dh,0D9h,1Fh,0FFh
		db	0FFh,0FEh,40h,01h,3Fh,0FFh
		db	0FFh,0FFh,4Dh,0D9h,7Fh,0FFh
		db	0FFh,0FFh,4Dh,0D9h,7Fh,0FFh
		db	0FFh,0FFh,40h,01h,7Fh,0FFh
		db	0FFh,0FFh,4Dh,0D9h,7Fh,0FFh
		db	0FFh,0FFh,4Dh,0D9h,7Fh,0FFh
		db	0FFh,0FFh,40h,01h,7Fh,0FFh
		db	0FFh,0FFh,4Dh,0D9h,7Fh,0FFh
		db	0FFh,0FFh,2Dh,0DAh,7Fh,0FFh

Analyzer_phase_14:
		db	0FFh,0FFh,0C7h,0F1h,0FFh,0FFh
		db	0E7h,0FFh,8Fh,0F8h,0FFh,0F3h
		db	0C3h,0FFh,9Fh,7Ch,0FFh,0E1h
		db	0E1h,0FFh,9Fh,0FCh,0FFh,0C3h
		db	0E8h,0FFh,9Fh,7Ch,0FFh,8Bh
		db	0F2h,7Fh,9Fh,0FCh,0FFh,27h
		db	0FDh,3Fh,9Bh,6Ch,0FEh,5Fh
		db	0FEh,9Fh,9Fh,0FCh,0FCh,0BFh
		db	0FFh,4Fh,5Bh,6Dh,79h,7Fh
		db	0FFh,0A2h,5Fh,0FDh,22h,0FFh
		db	0FFh,0D1h,5Fh,0FDh,45h,0FFh
		db	0FFh,0E8h,2Fh,0FAh,0Bh,0FFh
		db	0FFh,0F5h,40h,01h,57h,0FFh
		db	0FFh,0F8h,44h,91h,0Fh,0FFh
		db	0FFh,0FCh,4Dh,0D9h,1Fh,0FFh
		db	0FFh,0FEh,40h,01h,3Fh,0FFh
		db	0FFh,0FFh,4Dh,0D9h,7Fh,0FFh
		db	0FFh,0FFh,4Dh,0D9h,7Fh,0FFh
		db	0FFh,0FFh,40h,01h,7Fh,0FFh
		db	0FFh,0FFh,4Dh,0D9h,7Fh,0FFh
		db	0FFh,0FFh,4Dh,0D9h,7Fh,0FFh
		db	0FFh,0FFh,40h,01h,7Fh,0FFh
		db	0FFh,0FFh,4Dh,0D9h,7Fh,0FFh
		db	0FFh,0FFh,2Dh,0DAh,7Fh,0FFh

Analyzer_phase_15:
		db	0EBh,0FFh,0C7h,0F1h,0FFh,0EBh
		db	0F1h,0FFh,8Fh,0F8h,0FFh,0C7h
		db	0E8h,0FFh,9Fh,7Ch,0FFh,8Bh
		db	0F4h,7Fh,9Fh,0FCh,0FFh,17h
		db	0FAh,3Fh,9Dh,5Ch,0FEh,2Fh
		db	0FDh,1Fh,9Fh,0FCh,0FCh,5Fh
		db	0FEh,8Fh,9Bh,6Ch,0F8h,0BFh
		db	0FFh,47h,9Fh,0FCh,0F1h,7Fh
		db	0FFh,0A2h,5Bh,6Dh,22h,0FFh
		db	0FFh,0D1h,5Fh,0FDh,45h,0FFh
		db	0FFh,0E8h,5Fh,0FDh,0Bh,0FFh
		db	0FFh,0F5h,2Fh,0FAh,57h,0FFh
		db	0FFh,0FAh,40h,01h,2Fh,0FFh
		db	0FFh,0FCh,44h,91h,1Fh,0FFh
		db	0FFh,0FEh,4Dh,0D9h,3Fh,0FFh
		db	0FFh,0FFh,40h,01h,7Fh,0FFh
		db	0FFh,0FFh,4Dh,0D9h,7Fh,0FFh
		db	0FFh,0FFh,4Dh,0D9h,7Fh,0FFh
		db	0FFh,0FFh,40h,01h,7Fh,0FFh
		db	0FFh,0FFh,4Dh,0D9h,7Fh,0FFh
		db	0FFh,0FFh,4Dh,0D9h,7Fh,0FFh
		db	0FFh,0FFh,40h,01h,7Fh,0FFh
		db	0FFh,0FFh,4Dh,0D9h,7Fh,0FFh
		db	0FFh,0FFh,2Dh,0DAh,7Fh,0FFh

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
