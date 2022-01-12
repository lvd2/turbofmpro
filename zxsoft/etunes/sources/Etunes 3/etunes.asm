;--------------------------------------------------------------------
; Описание: Программа проигрывания модулей E-Tracker
; поддержка в железе: ZXM-SoundCard
; Автор порта: Тарасов М.Н.(Mick),2010
;--------------------------------------------------------------------
		DEVICE ZXSPECTRUM128

		.org 	6000h

;-------------------------------------------------------------------
; описание: Точка входа в программу после передачи управления из ОС
;---------------------------------------------------------------------
ETunes_Start:		
		xor	a               		;бордер в черный цвет
		out	(0feh),a	
		ld	(ETunes_count_music),a		;счетчик номера музыки

		ld	hl,4000h
		ld	de,4001h
		ld	bc,1b00h
		ld	(hl),c
		ldir
		
		ld	hl,8000h			;грузим экран
		ld	de,(5CF4h)
		ld	bc,1B05h
		call	3d13h
		ld	hl,98E1h
		ld	c,11
ETunes_clear_y:
		push	hl
		ld	b,24
ETunes_clear_x:
		ld	(hl),0
		inc	hl
		djnz	ETunes_clear_x
		pop	hl
		ld	de,0020h
		add	hl,de
		dec	c
		jr	nz,ETunes_clear_y
		ld	hl,8000h
		ld	de,4000h
		ld	bc,1b00h
		ldir	

		call	Str_init_load
		ei
ETunes_loading:
		halt
		ld	b,0
Etunes_wait:
		djnz	Etunes_wait			
		call	Str_play
		jr	nc,ETunes_loading	

		di                                      ;на всякий пожарный запретим прерывания
		ld	a,10h 				;установим начальную страницу памяти
		ld	(ETunes_page_memory),a
		ld	bc,7ffdh
		out	(c),a
		ld	hl,0C000h			;грузим музыкальный пак 1.
		ld	de,(5CF4h)
		ld	bc,3E05h
		call	3d13h

		ld	hl,59A1h
		ld	(hl),01h
		inc	hl
		ld	(hl),41h
		inc	hl
		ld	(hl),02h
		
		ld	a,11h 
		ld	bc,7ffdh
		out	(c),a
		ld	hl,0C000h			;грузим музыкальный пак 2.
		ld	de,(5CF4h)
		ld	bc,3E05h
		call	3d13h

		ld	hl,59A4h
		ld	(hl),42h
		inc	hl
		ld	(hl),03h
		inc	hl
		ld	(hl),43h

		ld	a,13h 
		ld	bc,7ffdh
		out	(c),a
		ld	hl,0C000h			;грузим музыкальный пак 3.
		ld	de,(5CF4h)
		ld	bc,3905h
		call	3d13h

		ld	hl,59A7h
		ld	(hl),04h
		inc	hl
		ld	(hl),44h
		inc	hl
		ld	(hl),05h

		ld	a,14h 
		ld	bc,7ffdh
		out	(c),a
		ld	hl,0C000h			;грузим музыкальный пак 4.
		ld	de,(5CF4h)
		ld	bc,3F05h
		call	3d13h

		ld	hl,59A9h
		ld	(hl),45h
		inc	hl
		ld	(hl),06h
		inc	hl
		ld	(hl),46h

		ld	a,16h 
		ld	bc,7ffdh
		out	(c),a
		ld	hl,0C000h			;грузим музыкальный пак 5.
		ld	de,(5CF4h)
		ld	bc,1F05h
		call	3d13h

		ld	a,10h 
		ld	bc,7ffdh
		out	(c),a

		ld	sp,5fffh
		call	Str_init			;инициализация бегущей строки
		call	Analyzer_init			
		ld	hl,0C000h
		ld	(EPlayer_Init+1),hl            ;адрес музыкального произведения
		ld	bc,0FFFDh                       ;разрешим работу SAA1099
		ld	a,0f6h
		out	(c),a
		call	EPlayer_Init			;инициализация проигрывающего модуля
		ld	hl,0fe00h                       ;создаем таблицу прерывания для im 2
		ld	de,0fe01h
		ld	bc,0100h
		ld	(hl),0fdh
		ldir
		ld	a,0c3h                          ;установим вектор прерывания
		ld	(0fdfdh),a
		ld	hl,Interrupt_handle
		ld	(0fdfeh),hl
		di
		ld	a,0feh                          ;окончание установки прерывания
		ld	i,a
		im	2
		ei
ETunes_key:		
		xor	a
                ld	(ETunes_key_press),a
ETunes_loop:		
		halt
		
		call 	Analyzer_update
		call 	Analyzer_view
		call	Str_play

		ld	a,7fh				;ожидаем пробел - переход к следующей композиции
		in	a,(0feh)
		rra	
		jr	c,ETunes_key

		ld	a,0FEh
		in	a,(0FEh)
		rra	    
		jr	nc,ETunes_exit

		ld	a,(ETunes_key_press)
		and	a
		jr	nz,ETunes_loop

		di	
		inc	a
                ld	(ETunes_key_press),a
		ld	a,(ETunes_page_memory)		;загрузим номер страницы памяти
		ld	bc,7ffdh
		out	(c),a
		call	EPlayer_Init			;глушим работу проигрывающего модуля
		ld	bc,0FFFDh                       ;запрещаем работу SAA1099
		ld	a,0feh
		out	(c),a
		ld	a,(ETunes_count_music)
		inc	a
		cp	40
		jr	c,ETunes_next_music
		xor	a

ETunes_next_music:
		ld	(ETunes_count_music),a
		ld	l,a
		ld	e,a
		ld	h,0
		ld	d,h
		add	hl,hl
		add	hl,de
		ld	de,ETunes_tabl_music
		add	hl,de
		ld	a,(hl)				;номер страницы памяти
		ld	(ETunes_page_memory),a
		inc	hl
		ld	a,(hl)                          
		inc	hl
		ld	h,(hl)
		ld	l,a
		ld	a,(ETunes_page_memory)		;загрузим номер страницы памяти
		ld	bc,7ffdh
		out	(c),a
		ld	(EPlayer_Init+1),hl            ;адрес музыкального произведения
		ld	bc,0FFFDh                       ;разрешим работу SAA1099
		ld	a,0f6h
		out	(c),a
		call	EPlayer_Init			;инициализируем проигрыватель
		ld	a,10h
		ld	bc,7ffdh
		out	(c),a
		ei
		jp      ETunes_loop

ETunes_exit:		
		di	
		call	EPlayer_Init			;глушим работу проигрывающего модуля
		ld	bc,0FFFDh                       ;запрещаем работу SAA1099
		ld	a,0feh
		out	(c),a
		ld	hl,0	
		push	hl
      		jp  	3d2fh				;выход в TR-DOS

ETunes_tabl_music:
		db	10h   				; 1 музыкальное произведение
		dw	0C000h
		db	10h   				; 2 музыкальное произведение
		dw	0C220h
		db	10h   				; 3 музыкальное произведение
		dw	0C600h
		db	10h   				; 4 музыкальное произведение
		dw	0CBB0h
		db	10h   				; 5 музыкальное произведение
		dw	0D260h
		db	10h   				; 6 музыкальное произведение
		dw	0D7D0h
		db	10h   				; 7 музыкальное произведение
		dw	0DCE0h
		db	10h   				; 8 музыкальное произведение
		dw	0E1C0h
		db	10h   				; 9 музыкальное произведение
		dw	0E4F0h
		db	10h   				; 10 музыкальное произведение
		dw	0E870h
		db	10h   				; 11 музыкальное произведение
		dw	0EE70h
		db	10h   				; 12 музыкальное произведение
		dw	0F430h

		db	11h   				; 13 музыкальное произведение
		dw	0C000h
		db	11h   				; 14 музыкальное произведение
		dw	0CC50h
		db	11h   				; 15 музыкальное произведение
		dw	0D440h
		db	11h   				; 16 музыкальное произведение
		dw	0EFC0h
		db	11h   				; 17 музыкальное произведение
		dw	0F4A0h

		db	13h   				; 18 музыкальное произведение
		dw	0C000h
		db	13h   				; 19 музыкальное произведение
		dw	0C220h
		db	13h   				; 20 музыкальное произведение
		dw	0C720h
		db	13h   				; 21 музыкальное произведение
		dw	0D7A0h
		db	13h   				; 22 музыкальное произведение
		dw	0DEC0h
		db	13h   				; 23 музыкальное произведение
		dw	0E120h
		db	13h   				; 24 музыкальное произведение
		dw	0E660h
		db	13h   				; 25 музыкальное произведение
		dw	0ECF0h
		db	13h   				; 26 музыкальное произведение
		dw	0F060h

		db	14h   				; 27 музыкальное произведение
		dw	0C000h
		db	14h   				; 28 музыкальное произведение
		dw	0C8E0h
		db	14h   				; 29 музыкальное произведение
		dw	0CC90h
		db	14h   				; 30 музыкальное произведение
		dw	0D2C0h
		db	14h   				; 31 музыкальное произведение
		dw	0D9F0h
		db	14h   				; 32 музыкальное произведение
		dw	0DE20h
		db	14h   				; 33 музыкальное произведение
		dw	0E450h
		db	14h   				; 34 музыкальное произведение
		dw	0EAF0h
		db	14h   				; 35 музыкальное произведение
		dw	0EE70h
		db	14h   				; 36 музыкальное произведение
		dw	0F730h

		db	16h   				; 37 музыкальное произведение
		dw	0C000h
		db	16h   				; 38 музыкальное произведение
		dw	0C7D0h
		db	16h   				; 39 музыкальное произведение
		dw	0D0D0h
		db	16h   				; 40 музыкальное произведение
		dw	0D8F0h

ETunes_page_memory:
		db	0		
ETunes_count_music:
		db	0
ETunes_key_press:
		db	0
ETunes_phase:
		db	0

Interrupt_handle:
		push	hl	
		push	bc	
		push	de
		push	af	
		ld	a,(ETunes_page_memory)
		ld	bc,7ffdh
		out	(c),a
		call	EPlayer_Play
		ld	a,10h
		ld	bc,7ffdh
		out	(c),a
		pop	af
		pop	de
		pop	bc
		pop	hl
		ei
		ret

		.include  analyzer.asm
		.include  etplayer.asm
		.include  string.asm
Etunes_end:

		.savebin "etunes.bin",ETunes_Start, Etunes_end - ETunes_Start
		.end

