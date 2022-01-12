;--------------------------------------------------------------------
; ���ᠭ��: �ணࠬ�� �ந��뢠��� ���㫥� E-Tracker
; �����প� � ������: ZXM-SoundCard
; ���� ����: ���ᮢ �.�.(Mick),2010
;--------------------------------------------------------------------
		DEVICE ZXSPECTRUM128

		.org 	6000h

;-------------------------------------------------------------------
; ���ᠭ��: ��窠 �室� � �ணࠬ�� ��᫥ ��।�� �ࠢ����� �� ��
;---------------------------------------------------------------------
ETunes_Start:		
		xor	a               		;��थ� � ��� 梥�
		out	(0feh),a	
		ld	(ETunes_count_music),a		;���稪 ����� ��모

		ld	hl,4000h
		ld	de,4001h
		ld	bc,1b00h
		ld	(hl),c
		ldir
		
		ld	hl,4000h			;��㧨� �࠭
		ld	de,(5CF4h)
		ld	bc,1B05h
		call	3d13h
		call	Str_init_load
		ei
ETunes_loading:
		halt
		call	Str_draw_symbol
		call	Str_play
		jr	c,ETunes_load
		call	Str_update_symbol
		jr	nc,ETunes_loading	
ETunes_load:
		di                                      ;�� ��直� ������ ����⨬ ���뢠���
		ld	a,10h 				;��⠭���� ��砫��� ��࠭��� �����
		ld	(ETunes_page_memory),a
		ld	bc,7ffdh
		out	(c),a
		ld	hl,0C000h			;��㧨� ��몠��� ��� 1.
		ld	de,(5CF4h)
		ld	bc,3A05h
		call	3d13h

		ld	a,11h 
		ld	bc,7ffdh
		out	(c),a
		ld	hl,0C000h			;��㧨� ��몠��� ��� 2.
		ld	de,(5CF4h)
		ld	bc,3A05h
		call	3d13h

		ld	a,13h 
		ld	bc,7ffdh
		out	(c),a
		ld	hl,0C000h			;��㧨� ��몠��� ��� 3.
		ld	de,(5CF4h)
		ld	bc,3D05h
		call	3d13h

		ld	a,14h 
		ld	bc,7ffdh
		out	(c),a
		ld	hl,0C000h			;��㧨� ��몠��� ��� 4.
		ld	de,(5CF4h)
		ld	bc,3E05h
		call	3d13h

		ld	a,16h 
		ld	bc,7ffdh
		out	(c),a
		ld	hl,0C000h			;��㧨� ��몠��� ��� 5.
		ld	de,(5CF4h)
		ld	bc,0F05h
		call	3d13h

		ld	a,10h 
		ld	bc,7ffdh
		out	(c),a
		call	Str_init_clear
		ei
ETunes_clearing:
		halt
		call	Str_draw_symbol
		call	Str_play
		jr	c,ETunes_init
		call	Str_update_symbol
		jr	nc,ETunes_clearing	
ETunes_init:
		di                                      ;�� ��直� ������ ����⨬ ���뢠���

		ld	sp,5fffh
		call	Str_init			;���樠������ ����饩 ��ப�
		call	Analyzer_init			
		ld	a,1
		ld	(ETunes_number_music),a
		call	ETunes_view_number
		ld	hl,0C000h
		ld	(EPlayer_Init+1),hl            ;���� ��몠�쭮�� �ந��������
		ld	bc,0FFFDh                       ;ࠧ�訬 ࠡ��� SAA1099
		ld	a,0f6h
		out	(c),a
		call	EPlayer_Init			;���樠������ �ந��뢠�饣� �����
		ld	hl,0fe00h                       ;ᮧ���� ⠡���� ���뢠��� ��� im 2
		ld	de,0fe01h
		ld	bc,0100h
		ld	(hl),0fdh
		ldir
		ld	a,0c3h                          ;��⠭���� ����� ���뢠���
		ld	(0fdfdh),a
		ld	hl,Interrupt_handle
		ld	(0fdfeh),hl
		di
		ld	a,0feh                          ;����砭�� ��⠭���� ���뢠���
		ld	i,a
		im	2
		ei
ETunes_key:		
		xor	a
                ld	(ETunes_key_press),a
ETunes_loop:		
		halt

		ld	a,7fh				;������� �஡�� - ���室 � ᫥���饩 �������樨
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
		ld	a,(ETunes_page_memory)		;����㧨� ����� ��࠭��� �����
		ld	bc,7ffdh
		out	(c),a
		call	EPlayer_Init			;���訬 ࠡ��� �ந��뢠�饣� �����
		ld	bc,0FFFDh                       ;����頥� ࠡ��� SAA1099
		ld	a,0feh
		out	(c),a
		ld	a,(ETunes_count_music)
		inc	a
		cp	30
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
		ld	a,(hl)				;����� ��࠭��� �����
		ld	(ETunes_page_memory),a
		inc	hl
		ld	a,(hl)                          
		inc	hl
		ld	h,(hl)
		ld	l,a
		ld	a,(ETunes_page_memory)		;����㧨� ����� ��࠭��� �����
		ld	bc,7ffdh
		out	(c),a
		ld	(EPlayer_Init+1),hl            ;���� ��몠�쭮�� �ந��������
		ld	bc,0FFFDh                       ;ࠧ�訬 ࠡ��� SAA1099
		ld	a,0f6h
		out	(c),a
		call	EPlayer_Init			;���樠�����㥬 �ந��뢠⥫�
		ld	a,10h
		ld	bc,7ffdh
		out	(c),a

		ld	a,(ETunes_number_music)
		inc	a
		ld	c,a
		and	0Fh
		cp	10
		jr	c,ETunes_number_correct
		ld	a,6
		add	c
		ld	c,a

ETunes_number_correct:
		ld	a,c
		ld	(ETunes_number_music),a
		cp	31h
		jr	c,ETunes_number_valid
		ld	a,1

ETunes_number_valid:
		ld	(ETunes_number_music),a
		call	ETunes_view_number

		ei
		jp      ETunes_loop

ETunes_exit:		
		di	
		call	EPlayer_Init			;���訬 ࠡ��� �ந��뢠�饣� �����
		ld	bc,0FFFDh                       ;����頥� ࠡ��� SAA1099
		ld	a,0feh
		out	(c),a
		ld	hl,0	
		push	hl
      		jp  	3d2fh				;��室 � TR-DOS

ETunes_view_number:
		ld	c,a
		and	0F0h
		rrca
		rrca
		rrca
		rrca
		ld	hl,5092h
		call	ETunes_view_symbol
		ld	a,c
		and	0Fh
		ld	hl,5093h

ETunes_view_symbol:
		push	hl
		ld	h,0
		ld	l,a
		add	hl,hl
		add	hl,hl
		add	hl,hl
		ld	de,ETunes_table_symbol
	        add	hl,de	
		ex	de,hl
		pop	hl
		ld	b,8

ETunes_view_loop:
		ld	a,(de)
		ld	(hl),a
		inc	de		
		inc	h
		djnz	ETunes_view_loop
		ret	

ETunes_line_border:
		ld	a,07h
      		out	(0feh),a
		ld	b,0Ch 
ETunes_width_loop:		
		nop
		djnz	ETunes_width_loop
		xor	a
      		out	(0feh),a
		ret
;-------------------------------------------------------------------
; ���ᠭ��: ���������� ��ࠬ��஢ �᭮���� ����饩 ��ப�
; ��ࠬ����: ���
; �����頥���  ���祭��: ���
;---------------------------------------------------------------------
ETunes_line_select:	
		ld	hl,(ETunes_line_index)
		ld	a,(hl)
		dec	a
		jr	nz,ETunes_load_index
		ld	hl,ETunes_table_line
ETunes_load_index:		
		ld	e,(hl)
		inc	hl
		ld	d,(hl)
		inc	hl
		ld	(ETunes_line_index),hl
		ex	hl,de
		ld	(ETunes_cnst_delay),hl
		ret

ETunes_tabl_music:
		db	10h   				; 1 ��몠�쭮� �ந��������
		dw	0C000h
		db	10h   				; 2 ��몠�쭮� �ந��������
		dw	0C5B0h
		db	10h   				; 3 ��몠�쭮� �ந��������
		dw	0CFD0h
		db	10h   				; 4 ��몠�쭮� �ந��������
		dw	0DC10h
		db	10h   				; 5 ��몠�쭮� �ந��������
		dw	0E210h
		db	10h   				; 6 ��몠�쭮� �ந��������
		dw	0EEC0h
		db	10h   				; 7 ��몠�쭮� �ந��������
		dw	0F770h

		db	11h   				; 8 ��몠�쭮� �ந��������
		dw	0C000h
		db	11h   				; 9 ��몠�쭮� �ந��������
		dw	0C700h
		db	11h   				; 10 ��몠�쭮� �ந��������
		dw	0CC70h
		db	11h   				; 11 ��몠�쭮� �ந��������
		dw	0D7C0h
		db	11h   				; 12 ��몠�쭮� �ந��������
		dw	0E550h
		db	11h   				; 13 ��몠�쭮� �ந��������
		dw	0ED60h
		db	11h   				; 14 ��몠�쭮� �ந��������
		dw	0F180h

		db	13h   				; 15 ��몠�쭮� �ந��������
		dw	0C000h
		db	13h   				; 16 ��몠�쭮� �ந��������
		dw	0CD80h
		db	13h   				; 17 ��몠�쭮� �ந��������
		dw	0D740h
		db	13h   				; 18 ��몠�쭮� �ந��������
		dw	0DEB0h
		db	13h   				; 19 ��몠�쭮� �ந��������
		dw	0E5C0h
		db	13h   				; 20 ��몠�쭮� �ந��������
		dw	0ED80h
		db	13h   				; 21 ��몠�쭮� �ந��������
		dw	0F450h

		db	14h   				; 22 ��몠�쭮� �ந��������
		dw	0C000h
		db	14h   				; 23 ��몠�쭮� �ந��������
		dw	0CCB0h
		db	14h   				; 24 ��몠�쭮� �ந��������
		dw	0D580h
		db	14h   				; 25 ��몠�쭮� �ந��������
		dw	0DFD0h
		db	14h   				; 26 ��몠�쭮� �ந��������
		dw	0E8F0h
		db	14h   				; 27 ��몠�쭮� �ந��������
		dw	0F080h
		db	14h   				; 28 ��몠�쭮� �ந��������
		dw	0F2D0h

		db	16h   				; 29 ��몠�쭮� �ந��������
		dw	0C000h
		db	16h   				; 30 ��몠�쭮� �ந��������
		dw	0C630h

ETunes_table_symbol:
  		db 	0,3Ch,66h,6Eh,76h,66h,3Ch,0
  		db 	0,18h,38h,18h,18h,18h,7Eh,0
  		db 	0,3Ch,66h,0Ch,18h,30h,7Eh,0
  		db 	0,7Eh,0Ch,18h,0Ch,66h,3Ch,0
  		db 	0,0Ch,1Ch,3Ch,6Ch,7Eh,0Ch,0
  		db 	0,7Eh,60h,7Ch,06h,66h,3Ch,0
  		db 	0,3Ch,60h,7Ch,66h,66h,3Ch,0
  		db 	0,7Eh,06h,0Ch,18h,30h,30h,0
  		db 	0,3Ch,66h,3Ch,66h,66h,3Ch,0
		db 	0,3Ch,66h,3Eh,06h,0Ch,38h,0

ETunes_table_line:	
		dw 	0Bh
		dw 	0Bh
		dw 	0Bh
		dw 	0Bh
		dw 	13h
		dw 	13h
		dw 	13h
		dw 	1Ch
		dw 	1Ch
		dw 	1Ch
		dw	25h
		dw	25h
		dw	25h
		dw 	2Dh
		dw 	2Dh
		dw 	3Eh
		dw 	3Eh
		dw 	47h
		dw 	47h
		dw 	58h
		dw 	58h
		dw 	69h
		dw 	69h
		dw 	7Bh
		dw 	7Bh
		dw 	8Ch
		dw 	8Ch
		dw 	9Dh
		dw 	9Dh
		dw 	0AEh
		dw 	0AEh
		dw	0B7h
		dw	0B7h
		dw	0B7h
		dw 	0C0h
		dw 	0C0h
		dw 	0C0h
		dw 	0C8h
		dw 	0C8h
		dw 	0C8h
		dw 	0C8h
		dw 	0C0h
		dw 	0C0h
		dw 	0C0h
		dw	0B7h
		dw	0B7h
		dw	0B7h
		dw 	0AEh
		dw 	0AEh
		dw 	9Dh
		dw 	9Dh
		dw 	8Ch
		dw 	8Ch
		dw 	7Bh
		dw 	7Bh
		dw 	69h
		dw 	69h
		dw 	58h
		dw 	58h
		dw 	47h
		dw 	47h
		dw 	3Eh
		dw 	3Eh
		dw 	2Dh
		dw 	2Dh
		dw	25h
		dw	25h
		dw	25h
		dw 	1Ch
		dw 	1Ch
		dw 	1Ch
		dw 	13h
		dw 	13h
		dw 	13h
		db	1

ETunes_line_index:
		dw      ETunes_table_line
ETunes_cnst_delay:
		dw      4
ETunes_page_memory:
		db	0		
ETunes_count_music:
		db	0
ETunes_number_music:
		db	0
ETunes_key_press:
		db	0
ETunes_phase:
		db	0

Interrupt_handle:
		push	af	

		call 	Analyzer_update
		call 	Analyzer_view
		call    Analyzer_draw_flash
		call	Str_shift_buf
		call	Str_play_txt
		call	Str_update_symstr

		ld	bc,(ETunes_cnst_delay)
MA2BB:		
		dec	bc
     		ld	a,b
      		or	c
      		jr	nz,MA2BB
      		call	ETunes_line_border
		call	ETunes_line_select

		ld	b,7Bh
MA2BC:		
      		djnz	MA2BC
      		call	ETunes_line_border

		ld	a,(ETunes_page_memory)
		ld	bc,7ffdh
		out	(c),a
		call	EPlayer_Play
		ld	a,10h
		ld	bc,7ffdh
		out	(c),a

		call	Str_line_clear
		call	Str_line_select
		call	Str_copy_scr

		pop	af
		ei
		ret

		.include  analyzer.asm
		.include  etplayer.asm
		.include  string.asm
Etunes_end:

		.savebin "etunes.bin",ETunes_Start, Etunes_end - ETunes_Start
		.end

