.ifndef KOBY_CALCULATOR_S_
.set KOBY_CALCULATOR_S_, 1

.include "../src/klibpfrl.S"
.include "../src/klibio.S"

.data

@ Jump table
operations: .word addition, subtract, revSubtract, multiply, accMultiply, testEq, leftShift, rightShift, bitAND, bitOR, bitXOR, bitClear, bitNot, countLeadingZeroes, storeSolution, loadSolution

.text

@ +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
@ performCalc
@ Gets current state of on-board pushbuttons
@
@	r1		parameter -> operation
@	r2		parameter -> operand 1
@	r3		parameter -> operand 2
@
@	r0		return -> solution
@
@ Written by Koby Miller
@ Last modified: February 22nd, 2024
@ +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
performCalc:
	push {r7,r6}
	@ make sure the return value is reset
	@ mask parameter as a safety
	and r1, #0b1111
	@ load beginning of operation jump table
	ldr r7, =operations
	@ index the operations jump-table using 4*r1 (this is what the lsl #2 does) 
	ldr r6, [ r7, r1, lsl #2 ]
	@ go there
	bx r6 

	addition:
		add r0, r2, r3
		b doneWithCalc

	subtract:
		sub r0, r2, r3
		b doneWithCalc

	revSubtract:
		rsb r0, r2, r3
		b doneWithCalc

	multiply:
		mul r0, r2, r3
		b doneWithCalc

	accMultiply:
		mla r0, r2, r3, r4
		b doneWithCalc
		
	testEq:
		teq r2, r3
		b doneWithCalc
		
	leftShift:
		lsl r0, r2, r3
		b doneWithCalc
		
	rightShift:
		lsr r0, r2, r3
		b doneWithCalc
		
	bitAND:
		and r0, r2, r3
		b doneWithCalc
		
	bitOR:
		orr r0, r2, r3
		b doneWithCalc
		
	bitXOR:
		eor r0, r2, r3
		b doneWithCalc
		
	bitClear:
		bic r0, r2, r3
		b doneWithCalc
		
	bitNot:
		mvn r0, r2
		b doneWithCalc

	countLeadingZeroes:
		clz r0, r2
		b doneWithCalc
		
	storeSolution:
		mov r4, r5
		b doneWithCalc
		
	loadSolution:
		mov r5, r4 
		@b doneWithCalc

	doneWithCalc:
		pop {r7,r6}

bx lr

@ +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
@ getInputs
@ Gets current state of on-board pushbuttons
@
@	No parameters
@
@	r2		return -> operand 1
@	r3		return -> operand 2
@
@ Written by Koby Miller
@ Last modified: February 22nd, 2024
@ +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
getInputs:
	push {lr}
	
	@ get the first operand
	bl waitForKey
	
	@ set return value
	mov r2, r0
	
	@ get the second operand
	bl waitForKey
	
	@ set return value
	mov r3, r0
	
	pop {lr}

bx lr

@ +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
@ waitForKey
@ Gets current state of on-board pushbuttons
@
@	No parameters
@
@	r0		return -> key pressed
@
@ Written by Koby Miller
@ Last modified: February 22nd, 2024
@ +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
waitForKey:

	push {r1,r2,lr}

	@ wait a little
	bl dummyTimer
	
	@ wait until a key is pressed
	waitForKeyLoop:
	
		bl getKeypad

		mov r1, r0

		cmp r0, #-1
	beq waitForKeyLoop
	
	@ wait until that key is released
	waitForKeyRelease:
		bl getKeypad
		
		cmp r0, #-1
	bne waitForKeyRelease

	mov r0, r1

	pop {r1,r2,lr}
	
bx lr

@ +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
@ setOperation
@ Gets current state of on-board pushbuttons
@
@	No parameters
@
@	r1		return -> 4-bit number representing first four switch states
@
@ Written by Koby Miller
@ Last modified: February 22nd, 2024
@ +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
setOperation:
		push {r0,lr}
		
		bl getSwitchStates
		
		mov r1, r0
		
		bl outputToLEDs
		
		pop {r0,lr}
bx lr
@ +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
@ EoF
@ +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
.endif
