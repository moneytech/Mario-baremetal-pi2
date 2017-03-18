///This file is used to clear the screen.

.section .init
// .include "map.s"
// .include "art.s" Not needed, everything's global
// .globl 		UpdateScreen	//makes update screen visible to all
    
.section .text


// InitFrameBuffers:
// 	push {fp, lr}

// 	bl InitFrameBuffer

// 	pop {fp, lr}
// 	bx	lr

//Convert map.s to an image
DrawGameScreen:
	push {r4-r10, fp, lr}


	// mov	r4,	#0			//x value
	// mov	r5,	#0			//Y value
	// // mov	r6,	#0			//black color


	// mov	r7,	#32		//Width of screen
	// mov	r8,	#32		//Height of the screen

	// ldr r9, =Bricks

	// drawLooping:

	// 	ldr r6, [r9], #4
	// 	mov	r0,	r4			//Setting x 
	// 	mov	r1,	r5			//Setting y
	// 	mov	r2,	r6			//setting pixel color
	// 	push {lr}
	// 	bl	DrawPixel
	// 	pop {lr}
	// 	add	r4,	#1			//increment x by 1
	// 	cmp	r4,	r7			//compare with width
	// 	blt	drawLooping

	// 	mov	r4,	#0			//reset x
	// 	add	r5,	#1			//increment Y by 1
	// 	cmp	r5,	r8			//compare with height
	// 	blt	drawLooping



	ldr r4, =Bricks	//load brick label

	mov r5, #0
	// ldr r6, =BricksRow
	// sub r6, r4
	mov r6, #32
	mov r10, #0

	mov r9, #100
	mov r8, #100

	b drawLoopTest

drawImageLoop:
	b loopTest2
	drawImageLoop2:
		ldr r7, [r4], #4
		bic r7, #0xFF000000

		mov r0, r8
		mov r1, r9
		mov r2, r7
		push {lr}
		bl DrawPixel
		pop {lr}

		add r10, #1
		add r9, #1

		loopTest2:
		cmp r10,r6
		ble drawImageLoop2

	add r8, #1
	add r5, #1
	drawLoopTest:
	cmp r5,r6
	ble drawImageLoop

	pop {r4-r10, fp, lr}
	bx	lr

//input: The buffer to be displayed
//return: null
//effect: draw a new frame
UpdateScreen:
	push {r4-r10, fp, lr}

	mov r4, r0

	bl ClearScreen

	bl DrawGameScreen
	//r4 contains reference to the buffer that should be drawn
////////////////////////////////////////////////////////
	//get each pixel to draw and then draw to the screen
	///This is to be implemented
//\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

	pop {r4-r10, fp, lr}
	bx	lr

//input: null
//return: null
//effect: makes every pixel on the screen black
ClearScreen:
	push {r4-r8, fp, lr}

	mov	r4,	#0			//x value
	mov	r5,	#0			//Y value
	mov	r6,	#0xFFFFFF	//black color
	ldr	r7,	=1023		//Width of screen
	ldr	r8,	=767		//Height of the screen


	clearLooping:
		mov	r0,	r4			//Setting x 
		mov	r1,	r5			//Setting y
		mov	r2,	r6			//setting pixel color
		push {lr}
		bl	DrawPixel
		pop {lr}
		add	r4,	#1			//increment x by 1
		cmp	r4,	r7			//compare with width
		blt	clearLooping
		mov	r4,	#0			//reset x
		add	r5,	#1			//increment Y by 1
		cmp	r5,	r8			//compare with height
		blt	clearLooping

	pop {r4-r8,fp,lr}
	bx	lr

//input: 
	//int x value, 
	//int y value, 
	//hex? pixel colour
//return: null
//effect: draw an individual pixel
DrawPixel:
	push	{r4}

	offset	.req	r4

	// offset = (y * 1024) + x = x + (y << 10)
	add		offset,	r0, r1, lsl #10
	// offset *= 2 (for 16 bits per pixel = 2 bytes per pixel)
	lsl		offset, #1

	// store the colour (half word) at framebuffer pointer + offset

	ldr	r0, =FrameBufferPointer
	ldr	r0, [r0]
	strh	r2, [r0, offset]

	pop		{r4}
	bx		lr

.section .data  