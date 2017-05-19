;--------------------------------------------------------------------------
;
;              Build this with the "Source" menu using
;                     "Build All" option
;
;--------------------------------------------------------------------------
;
;                           ʵ��������ͨ�ÿ��
;
;--------------------------------------------------------------------------
; ���ܣ� ������					                            				   |
; ��д����Ƕ��ʽϵͳԭ����ʵ�顷�γ���                   				   |
; �汾��3.5
; �޶���B
;--------------------------------------------------------------------------
		DOSSEG
		.MODEL	SMALL		; �趨8086������ʹ��Small model
		.8086				; �趨����8086���ָ�
;-------------------------------------------------------------------------
;	���Ŷ���                                                              |
;-------------------------------------------------------------------------

; 8253оƬ�˿ڵ�ַ ��Port Address):
L8253T0			EQU	100H			; Timer0's port number in I/O space
L8253T1			EQU 	102H			; Timer1's port number in I/O space
L8253T2			EQU 	104H			; Timer2's port number in I/O space
L8253CS			EQU 	106H			; 8253 Control Register's port number in I/O space

; 8255оƬ�˿ڵ�ַ ��Port Address):
L8255PA			EQU	121H			; Port A's port number in I/O space
L8255PB			EQU 	123H			; Port B's port number in I/O space
L8255PC			EQU 	125H			; Port C's port number in I/O space
L8255CS			EQU 	127H			; 8255 Control Register's port number in I/O space

;  �ж�ʸ���Ŷ���
IRQNum			EQU	147			; �ж�ʸ����,Ҫ����ѧ�ż���õ�����´˶��塣

Patch_Protues	EQU	IN AL, 0	;	Simulation Patch for Proteus, please ignore this line

;=======================================================================
; �궨��
;=======================================================================

; �޲�Proteus�����BUG���μ�������е�ʹ��˵��
    WaitForHWInt MACRO INTNum		; INTNum is the HW INT number
		MOV AL, INTNum   			;
		OUT 0, AL					;
		STI
		CLI
    ENDM

;-----------------------------------------------------------
;	�������ݶ�                                             |
;-----------------------------------------------------------
		.data					; �������ݶ�;
DelayShort	dw	800				; ����ʱ����	
DelayLong	dw	8000			; ����ʱ����

;-----------------------------------------------------------
;	��������                                             |
;-----------------------------------------------------------
		.code						; Code segment definition
		.startup					; Entrance of this program
;------------------------------------------------------------------------
		Patch_Protues					; Simulation Patch for Proteus,
								; Please ignore the above code line.
;------------------------------------------------------------------------

START:								; Modify the following codes accordingly
		MOV AX, @DATA					;
		MOV DS, AX					; Initialize DS

		CALL INIT8255					; Initialize 8255 
		
		MOV  BL, IRQNum					; BL is used as a parameter to call the procedure INT_INIT
		CALL INT_INIT					; Procedure INT_INIT is used to set up the IVT
	        MOV DX, L8255PC
		
Display_Again:
		INT IRQNUM
		MOV CX, DelayLong
L1:		LOOP L1
		JMP Display_Again


;===================================================================================
; Attention:
; The following codes is a Patching for Proteus 8086 Hardware Simulation Bug.
; Use these codes in the case you want the 8086 to halt and waiting for HW INT only! 
; You can treat it as if it doesn't exist. 
;
; If you need to use HW INT, please uncomment it, or
; Don't modify it, leave it here just as it is.
;		WaitForHWInt IRQNum				
;====================================================================================
		JMP	Display_Again

		HLT						; 
;=====================================================================================

INIT8255 PROC
		MOV AL,10000001B
		MOV DX,L8255CS
		OUT DX, AL
		RET
INIT8255 ENDP

;-------------------------------------------------------------
;                                                             |                                                            |
; Function��INTERRUPT Vector Table INIT						  |
; Input: BL = Interrupt number								  |
; Output: None			                                	  |
;                                                             |
;-------------------------------------------------------------	
INT_INIT	PROC FAR
		CLI				; Disable interrupt
		MOV CL, 2
		SHL BX, CL
		MOV AX, 0
		MOV ES, AX			; To set up the interrupt vector table
		MOV WORD PTR ES:[BX], OFFSET MYIRQ
		MOV WORD PTR ES:[BX+2], SEG MYIRQ
		STI
	        RET	
INT_INIT	ENDP

		
;--------------------------------------------------------------
;                                                             |                                                            |
; FUNCTION: INTERRUPT SERVICE  Routine ��ISR��				  | 
; Input::                                                     |
; Output:                                                     |
;                                                             |
;--------------------------------------------------------------	
		
MYIRQ 	PROC FAR
	        CLI
		
		IN AL, DX
		XOR AL, 80H
		OUT DX, AL
		
		STI
		RET
MYIRQ 	ENDP

	.stack 100h				; ����256�ֽ������Ķ�ջ
	END					