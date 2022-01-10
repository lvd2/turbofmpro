;--------------------------------------------------------------------
; Описание: Программа проигрывания модулей E-Tracker
; начальный экран сконверчен с компьютера Sam Coupe - Fred magazine 30
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
		
		ld	hl,4000h			;грузим экран
		ld	de,(5CF4h)
		ld	bc,1B05h
		call	3d13h
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
		ld	bc,3B05h
		call	3d13h

		ld	a,11h 
		ld	bc,7ffdh
		out	(c),a
		ld	hl,0C000h			;грузим музыкальный пак 2.
		ld	de,(5CF4h)
		ld	bc,3E05h
		call	3d13h

		ld	a,13h 
		ld	bc,7ffdh
		out	(c),a
		ld	hl,0C000h			;грузим музыкальный пак 3.
		ld	de,(5CF4h)
		ld	bc,3905h
		call	3d13h

		ld	a,14h 
		ld	bc,7ffdh
		out	(c),a
		ld	hl,0C000h			;грузим музыкальный пак 4.
		ld	de,(5CF4h)
		ld	bc,3E05h
		call	3d13h

		ld	a,16h 
		ld	bc,7ffdh
		out	(c),a
		ld	hl,0C000h			;грузим музыкальный пак 5.
		ld	de,(5CF4h)
		ld	bc,3B05h
		call	3d13h

		ld	a,17h 
		ld	bc,7ffdh
		out	(c),a
		ld	hl,0C000h			;грузим музыкальный пак 6.
		ld	de,(5CF4h)
		ld	bc,2105h
		call	3d13h

		ld	a,10h 
		ld	bc,7ffdh
		out	(c),a

		ld	sp,5fffh
		call	Str_init			;инициализация бегущей строки
		call	Analyzer_clear			;очистим анализатор
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
		call 	Analyzer_clear
		call	Str_play
		call 	Analyzer_view

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
		cp	20
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
		jr      ETunes_loop

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
		dw	0CC90h
		db	10h   				; 3 музыкальное произведение
		dw	0D330h
		db	10h   				; 4 музыкальное произведение
		dw	0DE20h
		db	10h   				; 5 музыкальное произведение
		dw	0E930h
		db	11h   				; 6 музыкальное произведение
		dw	0C000h
		db	11h   				; 7 музыкальное произведение
		dw	0CDC0h
		db	11h   				; 8 музыкальное произведение
		dw	0E6C0h
		db	13h   				; 9 музыкальное произведение
		dw	0C000h
		db	14h   				; 10 музыкальное произведение
		dw	0C000h
		db	14h   				; 11 музыкальное произведение
		dw	0CDC0h
		db	14h   				; 12 музыкальное произведение
		dw	0E170h
		db	14h   				; 13 музыкальное произведение
		dw	0EB60h
		db	16h   				; 14 музыкальное произведение
		dw	0C000h
		db	16h   				; 15 музыкальное произведение
		dw	0DB10h
		db	16h   				; 16 музыкальное произведение
		dw	0E7A0h
		db	16h   				; 17 музыкальное произведение
		dw	0EF20h
		db	17h   				; 18 музыкальное произведение
		dw	0C000h
		db	17h   				; 19 музыкальное произведение
		dw	0D200h
		db	17h   				; 20 музыкальное произведение
		dw	0D640h

ETunes_page_memory:
		db	0		
ETunes_count_music:
		db	0
ETunes_key_press:
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

