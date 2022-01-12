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
		ld	de,5022h
		call	Analyzer_draw

		ld	a,(Analyzer_ch1_vol)
		ld	de,5022h + 5
		call	Analyzer_draw

		ld	a,(Analyzer_ch2_vol)
		ld	de,5022h + 10
		call	Analyzer_draw

		ld	a,(Analyzer_ch3_vol)
		ld	de,5022h + 15
		call	Analyzer_draw

		ld	a,(Analyzer_ch4_vol)
		ld	de,5022h + 20
		call	Analyzer_draw

		ld	a,(Analyzer_ch5_vol)
		ld	de,5022h + 25
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

		ld	b,16				;размерность по Y
Analyzer_loop_Y:
		ld	c,10
		push	hl
		ex	hl,de
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
		ld	hl,5987h
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
		ld	hl,599Bh
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
		ld	hl,5ACAh
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
		ld	l,0EAh
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
; описание: Скроллинг экранов самописца
; параметры: нет
; возвращаемое  значение: нет
;---------------------------------------------------------------------
Analyzer_scrolling:
		ld	de,4AC2h
		ld	hl,4BC2h
		ld 	b,21

Analyzer_scroll_loop:
		push	bc
		push	hl
		ldi
		ldi
		ld	a,(hl)
		and	0FEh
		ld	c,a
		ld	a,(de)
		and	1
		or	c
		ld	(de),a
		inc	hl
		inc	hl
		inc	hl
		inc	de
		inc	de
		inc	de
		ldi
		ldi
		ld	a,(hl)
		and	0FEh
		ld	c,a
		ld	a,(de)
		and	1
		or	c
		ld	(de),a
		inc	hl
		inc	hl
		inc	hl
		inc	de
		inc	de
		inc	de
		ldi
		ldi
		ld	a,(hl)
		and	0FEh
		ld	c,a
		ld	a,(de)
		and	1
		or	c
		ld	(de),a
		inc	hl
		inc	hl
		inc	hl
		inc	de
		inc	de
		inc	de
		ldi
		ldi
		ld	a,(hl)
		and	0FEh
		ld	c,a
		ld	a,(de)
		and	1
		or	c
		ld	(de),a
		inc	hl
		inc	hl
		inc	hl
		inc	de
		inc	de
		inc	de
		ldi
		ldi
		ld	a,(hl)
		and	0FEh
		ld	c,a
		ld	a,(de)
		and	1
		or	c
		ld	(de),a
		inc	hl
		inc	hl
		inc	hl
		inc	de
		inc	de
		inc	de
		ldi
		ldi
		ld	a,(hl)
		and	0FEh
		ld	c,a
		ld	a,(de)
		and	1
		or	c
		ld	(de),a
		pop	hl
		ld	e,l
		ld	d,h
		inc	h
		ld	a,h
		and 	7
		jr	nz,Analyzer_scroll_line
		ld	a,l
		add	20h
		ld	l,a
		jr	c,Analyzer_scroll_line
		ld	a,h
		sub	8
		ld	h,a

Analyzer_scroll_line:
		pop	bc
    		dec     b
		jp	nz,Analyzer_scroll_loop
		ret				
;-------------------------------------------------------------------
; описание: Скроллинг экранов самописца
; параметры: нет
; возвращаемое  значение: нет
;---------------------------------------------------------------------
Analyzer_scroll_update:
		ld	de,5702h
		push	de
		ld	a,(Analyzer_ch0_vol)
		ld	l,a
		ld	h,0
		add	hl,hl
		ld	de,Analyzer_table_scroll
		add	hl,de
		ld	c,(hl)
		inc	hl
		ld	b,(hl)
		ld	d,a
		ld	a,(Analyzer_ch0_oldvol)
		ld	e,a
		ld	a,d
		ld	(Analyzer_ch0_oldvol),a
		ld	l,e
		ld	h,0
		ld	d,h
		add	hl,hl
		add	hl,de
		add	hl,bc
		pop	de		
		ldi
		ldi
		ld	a,(hl)
		or	1
		ld	(de),a
		inc	de
		inc	de	
		inc	de
		
		push	de
		ld	a,(Analyzer_ch1_vol)
		ld	l,a
		ld	h,0
		add	hl,hl
		ld	de,Analyzer_table_scroll
		add	hl,de
		ld	c,(hl)
		inc	hl
		ld	b,(hl)
		ld	d,a
		ld	a,(Analyzer_ch1_oldvol)
		ld	e,a
		ld	a,d
		ld	(Analyzer_ch1_oldvol),a
		ld	l,e
		ld	h,0
		ld	d,h
		add	hl,hl
		add	hl,de
		add	hl,bc
		pop	de		
		ldi
		ldi
		ld	a,(hl)
		or	1
		ld	(de),a
		inc	de
		inc	de	
		inc	de

		push	de
		ld	a,(Analyzer_ch2_vol)
		ld	l,a
		ld	h,0
		add	hl,hl
		ld	de,Analyzer_table_scroll
		add	hl,de
		ld	c,(hl)
		inc	hl
		ld	b,(hl)
		ld	d,a
		ld	a,(Analyzer_ch2_oldvol)
		ld	e,a
		ld	a,d
		ld	(Analyzer_ch2_oldvol),a
		ld	l,e
		ld	h,0
		ld	d,h
		add	hl,hl
		add	hl,de
		add	hl,bc
		pop	de		
		ldi
		ldi
		ld	a,(hl)
		or	1
		ld	(de),a
		inc	de
		inc	de	
		inc	de

		push	de
		ld	a,(Analyzer_ch3_vol)
		ld	l,a
		ld	h,0
		add	hl,hl
		ld	de,Analyzer_table_scroll
		add	hl,de
		ld	c,(hl)
		inc	hl
		ld	b,(hl)
		ld	d,a
		ld	a,(Analyzer_ch3_oldvol)
		ld	e,a
		ld	a,d
		ld	(Analyzer_ch3_oldvol),a
		ld	l,e
		ld	h,0
		ld	d,h
		add	hl,hl
		add	hl,de
		add	hl,bc
		pop	de		
		ldi
		ldi
		ld	a,(hl)
		or	1
		ld	(de),a
		inc	de
		inc	de	
		inc	de

		push	de
		ld	a,(Analyzer_ch4_vol)
		ld	l,a
		ld	h,0
		add	hl,hl
		ld	de,Analyzer_table_scroll
		add	hl,de
		ld	c,(hl)
		inc	hl
		ld	b,(hl)
		ld	d,a
		ld	a,(Analyzer_ch4_oldvol)
		ld	e,a
		ld	a,d
		ld	(Analyzer_ch4_oldvol),a
		ld	l,e
		ld	h,0
		ld	d,h
		add	hl,hl
		add	hl,de
		add	hl,bc
		pop	de		
		ldi
		ldi
		ld	a,(hl)
		or	1
		ld	(de),a
		inc	de
		inc	de	
		inc	de

		push	de
		ld	a,(Analyzer_ch5_vol)
		ld	l,a
		ld	h,0
		add	hl,hl
		ld	de,Analyzer_table_scroll
		add	hl,de
		ld	c,(hl)
		inc	hl
		ld	b,(hl)
		ld	d,a
		ld	a,(Analyzer_ch5_oldvol)
		ld	e,a
		ld	a,d
		ld	(Analyzer_ch5_oldvol),a
		ld	l,e
		ld	h,0
		ld	d,h
		add	hl,hl
		add	hl,de
		add	hl,bc
		pop	de		
		ldi
		ldi
		ld	a,(hl)
		or	1
		ld	(de),a
		ret
;-------------------------------------------------------------------
; описание: Обновление параметров анализатора
; параметры: нет
; возвращаемое  значение: нет
;---------------------------------------------------------------------
Analyzer_init:
              	ld	b, 12
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
		dw	Analyzer_phase_00               ;8
		dw	Analyzer_phase_09               ;9
		dw	Analyzer_phase_10               ;10
		dw	Analyzer_phase_11               ;11
		dw	Analyzer_phase_12               ;12
		dw	Analyzer_phase_13               ;13
		dw	Analyzer_phase_14               ;14
		dw	Analyzer_phase_15               ;15

Analyzer_phase_00:
		db	00h,00h,00h
		db	55h,55h,55h
		db	10h,10h,11h
		db	00h,10h,01h
		db	00h,10h,01h
		db	00h,10h,01h
		db	00h,10h,01h
		db	00h,10h,01h
		db	00h,10h,01h
		db	00h,10h,01h
		db	00h,10h,01h
		db	00h,10h,01h
		db	00h,10h,01h
		db	00h,10h,01h
		db	00h,10h,01h
		db	00h,10h,01h
Analyzer_phase_01:
		db	00h,00h,00h
		db	55h,49h,55h
		db	10h,08h,11h
		db	00h,08h,01h
		db	00h,08h,01h
		db	00h,08h,01h
		db	00h,08h,01h
		db	00h,08h,01h
		db	00h,10h,01h
		db	00h,10h,01h
		db	00h,10h,01h
		db	00h,10h,01h
		db	00h,10h,01h
		db	00h,10h,01h
		db	00h,10h,01h
		db	00h,10h,01h
Analyzer_phase_02:
		db	00h,00h,00h
		db	55h,55h,55h
		db	10h,14h,11h
		db	00h,14h,01h
		db	00h,04h,01h
		db	00h,08h,01h
		db	00h,08h,01h
		db	00h,08h,01h
		db	00h,08h,01h
		db	00h,08h,01h
		db	00h,08h,01h
		db	00h,08h,01h
		db	00h,10h,01h
		db	00h,10h,01h
		db	00h,10h,01h
		db	00h,10h,01h
Analyzer_phase_03:
		db	00h,00h,00h
		db	55h,55h,55h
		db	10h,11h,11h
		db	00h,12h,01h
		db	00h,02h,01h
		db	00h,02h,01h
		db	00h,02h,01h
		db	00h,04h,01h
		db	00h,04h,01h
		db	00h,04h,01h
		db	00h,08h,01h
		db	00h,08h,01h
		db	00h,08h,01h
		db	00h,08h,01h
		db	00h,10h,01h
		db	00h,10h,01h
Analyzer_phase_04:
		db	00h,00h,00h
		db	55h,55h,55h
		db	10h,10h,51h
		db	00h,10h,81h
		db	00h,00h,81h
		db	00h,00h,81h
		db	00h,01h,01h
		db	00h,01h,01h
		db	00h,01h,01h
		db	00h,02h,01h
		db	00h,02h,01h
		db	00h,02h,01h
		db	00h,04h,01h
		db	00h,04h,01h
		db	00h,04h,01h
		db	00h,08h,01h
Analyzer_phase_05:
		db	00h,00h,00h
		db	55h,55h,55h
		db	10h,10h,11h
		db	00h,10h,21h
		db	00h,00h,21h
		db	00h,00h,41h
		db	00h,00h,41h
		db	00h,00h,81h
		db	00h,00h,81h
		db	00h,01h,01h
		db	00h,01h,01h
		db	00h,02h,01h
		db	00h,02h,01h
		db	00h,04h,01h
		db	00h,04h,01h
		db	00h,08h,01h
Analyzer_phase_06:
		db	00h,00h,00h
		db	55h,55h,55h
		db	10h,10h,05h
		db	00h,10h,09h
		db	00h,00h,09h
		db	00h,00h,11h
		db	00h,00h,11h
		db	00h,00h,21h
		db	00h,00h,41h
		db	00h,00h,41h
		db	00h,00h,81h
		db	00h,01h,01h
		db	00h,01h,01h
		db	00h,02h,01h
		db	00h,02h,01h
		db	00h,04h,01h
Analyzer_phase_07:
		db	00h,00h,00h
		db	55h,55h,53h
		db	10h,10h,13h
		db	00h,10h,05h
		db	00h,00h,05h
		db	00h,00h,09h
		db	00h,00h,11h
		db	00h,00h,11h
		db	00h,00h,21h
		db	00h,00h,21h
		db	00h,00h,41h
		db	00h,00h,81h
		db	00h,00h,81h
		db	00h,01h,01h
		db	00h,01h,01h
		db	00h,02h,01h
Analyzer_phase_09:
		db	00h,00h,00h
		db	55h,25h,55h
		db	10h,20h,11h
		db	00h,20h,01h
		db	00h,20h,01h
		db	00h,20h,01h
		db	00h,20h,01h
		db	00h,20h,01h
		db	00h,10h,01h
		db	00h,10h,01h
		db	00h,10h,01h
		db	00h,10h,01h
		db	00h,10h,01h
		db	00h,10h,01h
		db	00h,10h,01h
		db	00h,10h,01h
Analyzer_phase_10:
		db	00h,00h,00h
		db	55h,55h,55h
		db	10h,50h,11h
		db	00h,50h,01h
		db	00h,40h,01h
		db	00h,20h,01h
		db	00h,20h,01h
		db	00h,20h,01h
		db	00h,20h,01h
		db	00h,20h,01h
		db	00h,20h,01h
		db	00h,20h,01h
		db	00h,10h,01h
		db	00h,10h,01h
		db	00h,10h,01h
		db	00h,10h,01h
Analyzer_phase_11:
		db	00h,00h,00h
		db	55h,55h,55h
		db	11h,10h,11h
		db	00h,90h,01h
		db	00h,80h,01h
		db	00h,80h,01h
		db	00h,80h,01h
		db	00h,40h,01h
		db	00h,40h,01h
		db	00h,40h,01h
		db	00h,20h,01h
		db	00h,20h,01h
		db	00h,20h,01h
		db	00h,20h,01h
		db	00h,10h,01h
		db	00h,10h,01h
Analyzer_phase_12:
		db	00h,00h,00h
		db	55h,55h,55h
		db	14h,10h,11h
		db	02h,10h,01h
		db	02h,00h,01h
		db	02h,00h,01h
		db	01h,00h,01h
		db	01h,00h,01h
		db	01h,00h,01h
		db	00h,80h,01h
		db	00h,80h,01h
		db	00h,80h,01h
		db	00h,40h,01h
		db	00h,40h,01h
		db	00h,40h,01h
		db	00h,20h,01h
Analyzer_phase_13:
		db	00h,00h,00h
		db	55h,55h,55h
		db	10h,10h,11h
		db	08h,10h,01h
		db	08h,00h,01h
		db	04h,00h,01h
		db	04h,00h,01h
		db	02h,00h,01h
		db	02h,00h,01h
		db	01h,00h,01h
		db	01h,00h,01h
		db	00h,80h,01h
		db	00h,80h,01h
		db	00h,40h,01h
		db	00h,40h,01h
		db	00h,20h,01h
Analyzer_phase_14:
		db	00h,00h,00h
		db	55h,55h,55h
		db	40h,10h,11h
		db	20h,10h,01h
		db	20h,00h,01h
		db	10h,00h,01h
		db	08h,00h,01h
		db	08h,00h,01h
		db	04h,00h,01h
		db	04h,00h,01h
		db	02h,00h,01h
		db	01h,00h,01h
		db	01h,00h,01h
		db	00h,80h,01h
		db	00h,80h,01h
		db	00h,40h,01h
Analyzer_phase_15:
		db	00h,00h,00h
		db	95h,55h,55h
		db	90h,10h,11h
		db	40h,10h,01h
		db	40h,00h,01h
		db	20h,00h,01h
		db	10h,00h,01h
		db	10h,00h,01h
		db	08h,00h,01h
		db	08h,00h,01h
		db	04h,00h,01h
		db	02h,00h,01h
		db	02h,00h,01h
		db	01h,00h,01h
		db	01h,00h,01h
		db	00h,80h,01h
;-------------------------------------------------------------------
; описание: Таблица адресов на фазы самописца
;---------------------------------------------------------------------
Analyzer_table_scroll:
		dw	Analyzer_scroll_00		;0
		dw	Analyzer_scroll_01               ;1
		dw	Analyzer_scroll_02               ;2
		dw	Analyzer_scroll_03               ;3
		dw	Analyzer_scroll_04               ;4
		dw	Analyzer_scroll_05               ;5
		dw	Analyzer_scroll_06               ;6
		dw	Analyzer_scroll_07               ;7
		dw	Analyzer_scroll_00               ;8
		dw	Analyzer_scroll_09               ;9
		dw	Analyzer_scroll_10               ;10
		dw	Analyzer_scroll_11               ;11
		dw	Analyzer_scroll_12               ;12
		dw	Analyzer_scroll_13               ;13
		dw	Analyzer_scroll_14               ;14
		dw	Analyzer_scroll_15               ;15

Analyzer_scroll_00:
		db	00h,10h,00h
		db	00h,08h,00h
		db	00h,0Ch,00h
		db	00h,0Fh,00h
		db	00h,0Fh,0C0h
		db	00h,0Fh,0F0h
		db	00h,0Fh,0FCh
		db	00h,0Fh,0FEh
		db	00h,10h,00h
		db	00h,20h,00h
		db	00h,60h,00h
		db	01h,0E0h,00h
		db	07h,0E0h,00h
		db	1Fh,0E0h,00h
		db	7Fh,0E0h,00h
		db	0FFh,0E0h,00h
Analyzer_scroll_01:
		db	00h,10h,00h
		db	00h,08h,00h
		db	00h,04h,00h
		db	00h,07h,00h
		db	00h,07h,0C0h
		db	00h,07h,0F0h
		db	00h,07h,0FCh
		db	00h,07h,0FEh
		db	00h,10h,00h
		db	00h,30h,00h
		db	00h,70h,00h
		db	01h,0F0h,00h
		db	07h,0F0h,00h
		db	1Fh,0F0h,00h
		db	7Fh,0F0h,00h
		db	0FFh,0F0h,00h
Analyzer_scroll_02:
		db	00h,18h,00h
		db	00h,08h,00h
		db	00h,04h,00h
		db	00h,03h,00h
		db	00h,03h,0C0h
		db	00h,03h,0F0h
		db	00h,03h,0FCh
		db	00h,03h,0FEh
		db	00h,18h,00h
		db	00h,38h,00h
		db	00h,78h,00h
		db	01h,0F8h,00h
		db	07h,0F8h,00h
		db	1Fh,0F8h,00h
		db	7Fh,0F8h,00h
		db	0FFh,0F8h,00h
Analyzer_scroll_03:
		db	00h,1Eh,00h
		db	00h,0Eh,00h
		db	00h,06h,00h
		db	00h,01h,00h
		db	00h,00h,0C0h
		db	00h,00h,0F0h
		db	00h,00h,0FCh
		db	00h,00h,0FEh
		db	00h,1Eh,00h
		db	00h,3Eh,00h
		db	00h,7Eh,00h
		db	01h,0FEh,00h
		db	07h,0FEh,00h
		db	1Fh,0FEh,00h
		db	7Fh,0FEh,00h
		db	0FFh,0FEh,00h
Analyzer_scroll_04:
		db	00h,1Fh,80h
		db	00h,0Fh,80h
		db	00h,07h,80h
		db	00h,01h,80h
		db	00h,00h,40h
		db	00h,00h,30h
		db	00h,00h,3Ch
		db	00h,00h,3Eh
		db	00h,1Fh,80h
		db	00h,3Fh,80h
		db	00h,7Fh,80h
		db	01h,0FFh,80h
		db	07h,0FFh,80h
		db	1Fh,0FFh,80h
		db	7Fh,0FFh,80h
		db	0FFh,0FFh,80h
Analyzer_scroll_05:
		db	00h,1Fh,0E0h
		db	00h,0Fh,0E0h
		db	00h,07h,0E0h
		db	00h,01h,0E0h
		db	00h,00h,60h
		db	00h,00h,10h
		db	00h,00h,0Ch
		db	00h,00h,0Eh
		db	00h,1Fh,0E0h
		db	00h,3Fh,0E0h
		db	00h,7Fh,0E0h
		db	01h,0FFh,0E0h
		db	07h,0FFh,0E0h
		db	1Fh,0FFh,0E0h
		db	7Fh,0FFh,0E0h
		db	0FFh,0FFh,0E0h
Analyzer_scroll_06:
		db	00h,1Fh,0F8h
		db	00h,0Fh,0F8h
		db	00h,07h,0F8h
		db	00h,01h,0F8h
		db	00h,00h,78h
		db	00h,00h,18h
		db	00h,00h,04h
		db	00h,00h,02h
		db	00h,1Fh,0F8h
		db	00h,3Fh,0F8h
		db	00h,7Fh,0F8h
		db	01h,0FFh,0F8h
		db	07h,0FFh,0F8h
		db	1Fh,0FFh,0F8h
		db	7Fh,0FFh,0F8h
		db	0FFh,0FFh,0F8h
Analyzer_scroll_07:
		db	00h,1Fh,0FCh
		db	00h,0Fh,0FCh
		db	00h,07h,0FCh
		db	00h,01h,0FCh
		db	00h,00h,7Ch
		db	00h,00h,1Ch
		db	00h,00h,04h
		db	00h,00h,02h
		db	00h,1Fh,0FCh
		db	00h,3Fh,0FCh
		db	00h,7Fh,0FCh
		db	01h,0FFh,0FCh
		db	07h,0FFh,0FCh
		db	1Fh,0FFh,0FCh
		db	7Fh,0FFh,0FCh
		db	0FFh,0FFh,0FCh
Analyzer_scroll_09:
		db	00h,10h,00h
		db	00h,18h,00h
		db	00h,1Ch,00h
		db	00h,1Fh,00h
		db	00h,1Fh,0C0h
		db	00h,1Fh,0F0h
		db	00h,1Fh,0FCh
		db	00h,1Fh,0FEh
		db	00h,10h,00h
		db	00h,20h,00h
		db	00h,40h,00h
		db	01h,0C0h,00h
		db	07h,0C0h,00h
		db	1Fh,0C0h,00h
		db	7Fh,0C0h,00h
		db	0FFh,0C0h,00h
Analyzer_scroll_10:
		db	00h,30h,00h
		db	00h,38h,00h
		db	00h,3Ch,00h
		db	00h,3Fh,00h
		db	00h,3Fh,0C0h
		db	00h,3Fh,0F0h
		db	00h,3Fh,0FCh
		db	00h,3Fh,0FEh
		db	00h,30h,00h
		db	00h,20h,00h
		db	00h,40h,00h
		db	01h,80h,00h
		db	07h,80h,00h
		db	1Fh,80h,00h
		db	7Fh,80h,00h
		db	0FFh,80h,00h
Analyzer_scroll_11:
		db	00h,0F0h,00h
		db	00h,0F8h,00h
		db	00h,0FCh,00h
		db	00h,0FFh,00h
		db	00h,0FFh,0C0h
		db	00h,0FFh,0F0h
		db	00h,0FFh,0FCh
		db	00h,0FFh,0FEh
		db	00h,0F0h,00h
		db	00h,0E0h,00h
		db	00h,0C0h,00h
		db	01h,00h,00h
		db	06h,00h,00h
		db	1Eh,00h,00h
		db	7Eh,00h,00h
		db	0FEh,00h,00h
Analyzer_scroll_12:
		db	03h,0F0h,00h
		db	03h,0F8h,00h
		db	03h,0FCh,00h
		db	03h,0FFh,00h
		db	03h,0FFh,0C0h
		db	03h,0FFh,0F0h
		db	03h,0FFh,0FCh
		db	03h,0FFh,0FEh
		db	03h,0F0h,00h
		db	03h,0E0h,00h
		db	03h,0C0h,00h
		db	03h,00h,00h
		db	04h,00h,00h
		db	18h,00h,00h
		db	78h,00h,00h
		db	0F8h,00h,00h
Analyzer_scroll_13:
		db	0Fh,0F0h,00h
		db	0Fh,0F8h,00h
		db	0Fh,0FCh,00h
		db	0Fh,0FFh,00h
		db	0Fh,0FFh,0C0h
		db	0Fh,0FFh,0F0h
		db	0Fh,0FFh,0FCh
		db	0Fh,0FFh,0FEh
		db	0Fh,0F0h,00h
		db	0Fh,0E0h,00h
		db	0Fh,0C0h,00h
		db	0Fh,00h,00h
		db	0Ch,00h,00h
		db	10h,00h,00h
		db	60h,00h,00h
		db	0E0h,00h,00h
Analyzer_scroll_14:
		db	3Fh,0F0h,00h
		db	3Fh,0F8h,00h
		db	3Fh,0FCh,00h
		db	3Fh,0FFh,00h
		db	3Fh,0FFh,0C0h
		db	3Fh,0FFh,0F0h
		db	3Fh,0FFh,0FCh
		db	3Fh,0FFh,0FEh
		db	3Fh,0F0h,00h
		db	3Fh,0E0h,00h
		db	3Fh,0C0h,00h
		db	3Fh,00h,00h
		db	3Ch,00h,00h
		db	30h,00h,00h
		db	40h,00h,00h
		db	80h,00h,00h
Analyzer_scroll_15:
		db	7Fh,0F0h,00h
		db	7Fh,0F8h,00h
		db	7Fh,0FCh,00h
		db	7Fh,0FFh,00h
		db	7Fh,0FFh,0C0h
		db	7Fh,0FFh,0F0h
		db	7Fh,0FFh,0FCh
		db	7Fh,0FFh,0FEh
		db	7Fh,0F0h,00h
		db	7Fh,0E0h,00h
		db	7Fh,0C0h,00h
		db	7Fh,00h,00h
		db	7Ch,00h,00h
		db	70h,00h,00h
		db	40h,00h,00h
		db	80h,00h,00h
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
Analyzer_ch0_oldvol:
		db	0
Analyzer_ch1_oldvol:
		db	0
Analyzer_ch2_oldvol:
		db	0
Analyzer_ch3_oldvol:
		db	0
Analyzer_ch4_oldvol:
		db	0
Analyzer_ch5_oldvol:
		db	0
