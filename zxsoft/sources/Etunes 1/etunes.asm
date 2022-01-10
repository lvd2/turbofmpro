;--------------------------------------------------------------------
; ���ᠭ��: �ணࠬ�� �ந��뢠��� ���㫥� E-Tracker
; ��砫�� �࠭ ᪮����祭 � �������� Sam Coupe - Fred magazine 30
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
		ld	b,0
Etunes_wait:
		djnz	Etunes_wait			
		call	Str_play
		jr	nc,ETunes_loading	

		di                                      ;�� ��直� ������ ����⨬ ���뢠���
		ld	a,10h 				;��⠭���� ��砫��� ��࠭��� �����
		ld	(ETunes_page_memory),a
		ld	bc,7ffdh
		out	(c),a
		ld	hl,0C000h			;��㧨� ��몠��� ��� 1.
		ld	de,(5CF4h)
		ld	bc,3B05h
		call	3d13h

		ld	a,11h 
		ld	bc,7ffdh
		out	(c),a
		ld	hl,0C000h			;��㧨� ��몠��� ��� 2.
		ld	de,(5CF4h)
		ld	bc,3E05h
		call	3d13h

		ld	a,13h 
		ld	bc,7ffdh
		out	(c),a
		ld	hl,0C000h			;��㧨� ��몠��� ��� 3.
		ld	de,(5CF4h)
		ld	bc,3905h
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
		ld	bc,3B05h
		call	3d13h

		ld	a,17h 
		ld	bc,7ffdh
		out	(c),a
		ld	hl,0C000h			;��㧨� ��몠��� ��� 6.
		ld	de,(5CF4h)
		ld	bc,2105h
		call	3d13h

		ld	a,10h 
		ld	bc,7ffdh
		out	(c),a

		ld	sp,5fffh
		call	Str_init			;���樠������ ����饩 ��ப�
		call	Analyzer_clear			;���⨬ ���������
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
		
		call 	Analyzer_update
		call 	Analyzer_clear
		call	Str_play
		call 	Analyzer_view

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
		ei
		jr      ETunes_loop

ETunes_exit:		
		di	
		call	EPlayer_Init			;���訬 ࠡ��� �ந��뢠�饣� �����
		ld	bc,0FFFDh                       ;����頥� ࠡ��� SAA1099
		ld	a,0feh
		out	(c),a
		ld	hl,0	
		push	hl
      		jp  	3d2fh				;��室 � TR-DOS

ETunes_tabl_music:
		db	10h   				; 1 ��몠�쭮� �ந��������
		dw	0C000h
		db	10h   				; 2 ��몠�쭮� �ந��������
		dw	0CC90h
		db	10h   				; 3 ��몠�쭮� �ந��������
		dw	0D330h
		db	10h   				; 4 ��몠�쭮� �ந��������
		dw	0DE20h
		db	10h   				; 5 ��몠�쭮� �ந��������
		dw	0E930h
		db	11h   				; 6 ��몠�쭮� �ந��������
		dw	0C000h
		db	11h   				; 7 ��몠�쭮� �ந��������
		dw	0CDC0h
		db	11h   				; 8 ��몠�쭮� �ந��������
		dw	0E6C0h
		db	13h   				; 9 ��몠�쭮� �ந��������
		dw	0C000h
		db	14h   				; 10 ��몠�쭮� �ந��������
		dw	0C000h
		db	14h   				; 11 ��몠�쭮� �ந��������
		dw	0CDC0h
		db	14h   				; 12 ��몠�쭮� �ந��������
		dw	0E170h
		db	14h   				; 13 ��몠�쭮� �ந��������
		dw	0EB60h
		db	16h   				; 14 ��몠�쭮� �ந��������
		dw	0C000h
		db	16h   				; 15 ��몠�쭮� �ந��������
		dw	0DB10h
		db	16h   				; 16 ��몠�쭮� �ந��������
		dw	0E7A0h
		db	16h   				; 17 ��몠�쭮� �ந��������
		dw	0EF20h
		db	17h   				; 18 ��몠�쭮� �ந��������
		dw	0C000h
		db	17h   				; 19 ��몠�쭮� �ந��������
		dw	0D200h
		db	17h   				; 20 ��몠�쭮� �ந��������
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

