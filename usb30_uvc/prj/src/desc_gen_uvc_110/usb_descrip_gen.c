#include <stdio.h>
#include <string.h>
#include <math.h>
#include <stdlib.h>
#define WIN32_LEAN_AND_MEAN
#define u8	unsigned int
#define u16	unsigned short
#define u32	unsigned int
char filename_usb3_init[] = "../usb30_user_layer/usb3_descrip_rom.init";
char filename_descrip_vh[] = "../usb30_user_layer/usb_descrip.vh";
char filename_UVCDefine_v[] = "../usb30_user_layer/UVCDefine.v";
char filename_temp_v[] = "./temp.v";

FILE   *init_3, *descrip_vh , *UVCDefine_v;
FILE *temp_v;

u8	bitwidth_3;
u8	*a;
u32	*buf;
u8	q;
u8	r;
u8	PKT_NUM;



u32 config_length;
u32 bos_length;
u32 i_3;
u32 DESCR_USB3_ROM_ADD_W ;
u32 DESCR_USB3_LEN ;
u16 WIDTH ;
u16 HIGHT ;
u32 FPS	  ;
u32 BIT_RATE ;
u32 FRAME_INTERVAL ;
u32 BYTES_PER_INTERVAL ;


u8	buf_2[1024] = {0, };

void fail(void *ret, char *str)
{
	if(ret == NULL){
		printf("\n* FAIL: %s\n", str);
		exit(-1);
	}
}

void write_buf32(u32 size)
{
	u32 i, w;
	a = buf_2 ; 
	for(i = 0; i < size; i+=4){
		fprintf(init_3,"%02X%02X%02X%02X\n",*(a),*(a+1),*(a+2),*(a+3));
		a = a + 4 ;
	}
}

/* Standard device descriptor for USB 3.0 */

// Descriptors structure

// Device Descriptor 

// Configuration Descriptor \---- IAD 
//
//					  		\---- Vedio Control Interface 
//
//					  	  		\---- Standard Vedio Control Intf Desc ( Intf 0 , AlternateSetting 0 )
//					  	  		\---- Class-specific VC Interface Header Descriptor
//					  	  		\---- Camera Terminal Descriptor
//					  	  		\---- Output Terminal Descriptor 
//					  	  		\---- Standard VC Interrupt Endpoint Descriptor 
//					  	  		\---- SuperSpeed Endpoint Companion Descriptor  
//					  	  		\---- Class-specific VC Interrupt Endpoint Descriptor 
//
//					  		\---- Vedio Streaming Interface 
//
//					  	  		\---- Standard Vedio Streaming Interface Descriptor ( Intf 1 , AlternateSetting 0 )	
//						  		\---- Input Header Descriptor
//						  		\---- Uncompressed Video Format Descriptor
//						  		\---- Uncompressed video Frame Descriptor
//						  		\---- Color matching descriptor
//						  		\---- Standard Vedio Streaming Bulk Video Data Endpoint Descriptor 
//						  		\---- SuperSpeed Endpoint Companion Descriptor 

//	Binary device object store descriptor

// Standard language ID string descriptor

// Standard product string descriptor 1

// Standard product string descriptor 2

// End of Descriptors structure

void add_device_descr( )
{
	a = buf_2; // (fixed)

	*a++ = 0x12;					// length ( 18 )	 
	*a++ = 0x01;					// descriptor ID ( Device Descriptor) 
	*a++ = 0x20;*a++ = 0x03; 		// bcdUSB (USB3.2)	
	*a++ = 0xEF;					// bDeviceClass (Multi-interface Function Class) 
	*a++ = 0x02;					// bDeviceSubClass (Multi-interface Function Class)
	*a++ = 0x01;					// bDeviceProtocol (Multi-interface Function Class)
	*a++ = 0x09;					// Maxpacket size for EP0 ( fixed ) 
	*a++ = 0x0A; *a++ = 0x03;		// Vendor ID ( 33AAh )
	*a++ = 0x01; *a++ = 0x03;		// Product ID ( 0301h )		
	*a++ = 0x10; *a++ = 0x10;		// Device release number ( 0000h )
	*a++ = 0x01;					// Manufacture string index (1)
	*a++ = 0x02;					// Product string index (2)
	*a++ = 0x00;					// Serial number string index (0)
	*a++ = 0x01;					// bNumConfigurations ( 1 )
	
	write_buf32( 18 );   // (fixed)

}

/* Standard super speed configuration descriptor */
void add_config_descr ()
{
	a = buf_2; 
	
	/* Configuration descriptor */
    *a++ = 0x09;                           /* Descriptor size ( 9 ) */
    *a++ = 0x02;        				   /* Configuration descriptor type (Configuration descriptor) */
    *a++ = 0xB1;*a++ = 0x00;               /* Length of this descriptor and all sub descriptors ( 177 bytes) */  
    *a++ = 0x02;                           /* Number of interfaces (2) */
    *a++ = 0x01;                           /* Configuration number(1) */
    *a++ = 0x00;                           /* Configuration string index (0) */
    *a++ = 0xC0;                           /* Config characteristics ( self powered ) */
    *a++ = 0x00;                           /* Max power consumption of device in 8mA unit ( self powered ) */

    /* Interface Association Descriptor */
	*a++ = 0x08;						  /* Descriptor size (8) */		
	*a++ = 0x0B;			              /* DescriptorType (IAD) */
	*a++ = 0x00;			              /* FirstInterface ( 0 ) */
	*a++ = 0x02;			              /* InterfaceCount ( 2 ) */
	*a++ = 0x0E;			              /* FunctionClass (CC_VIDEO) */
	*a++ = 0x03;			              /* FunctionSubClass ( SC_VIDEO_INTERFACE_COLLECTION) */
	*a++ = 0x00;			              /* FunctionProtocol ( PC_PROTOCOL_UNDEFINED ) */
	*a++ = 0x02;			              /* Function index (2) */
	

    /* 		VideoControl Interface Descriptors 				*/
	
    /* Standard VC Interface Descriptor */
    *a++ = 0x09;						/* Length (9) */	
    *a++ = 0x04;                        /* DescriptorType ( INTERFACE ) */
    *a++ = 0x00;                        /* InterfaceNumber (0) */
    *a++ = 0x00;                        /* AlternateSetting (0) */
    *a++ = 0x01;                        /* NumEndpoints (1) */
    *a++ = 0x0E;                        /* InterfaceClass (CC_VIDEO) */
    *a++ = 0x01;                        /* InterfaceSubClass (SC_VIDEOCONTROL) */
    *a++ = 0x00;                        /* InterfaceProtocol (None) */
    *a++ = 0x02;                        /* Interface index (2) */
		
    /* Class-specific VC Interface Header Descriptor */
    *a++ = 0x0D;                           				/* Length (13) */ 
    *a++ = 0x24;                           				/* DescriptorType (CS_INTERFACE) */
    *a++ = 0x01;                           				/* DescriptorSubType (VC_HEADER) */
    *a++ = 0x10;*a++ = 0x01;               				/* bcdUVC  (UVC 1.10) */
    *a++ = 0x28;*a++ = 0x00;               				/* TotalLength ( 40 bytes)*/  
    *a++ = 0x40;*a++ = 0x59; *a++ = 0x73;*a++ = 0x07; 	/* ClockFrequency  ( deprecated ) (125Mhz) */
    *a++ = 0x01;									 	/* InCollection (1) */
    *a++ = 0x01;									 	/* InterfaceNr(1) */


    /* Input Terminal Descriptor (Camera)*/
	*a++ = 0x12;							/* Length (18)*/ 			
	*a++ = 0x24;							/* DescriptorType (CS_INTERFACE)*/ 			
	*a++ = 0x02;							/* DescriptorSubtype (VC_INPUT_TERMINAL)*/ 			
	*a++ = 0x01;							/* TerminalID (1) */ 			
	*a++ = 0x01;*a++ = 0x02;				/* TerminalType (ITT_CAMERA)*/ 			
	*a++ = 0x00;							/* AssocTerminal (0) */ 			
	*a++ = 0x00;							/* Terminal index (0) */ 			
	*a++ = 0x00;*a++ = 0x00;				/* ObjectiveFocalLengthMin (0)*/ 			
	*a++ = 0x00;*a++ = 0x00;				/* ObjectiveFocalLengthMax (0) */ 			
	*a++ = 0x00;*a++ = 0x00;				/* OcularFocalLength (0)*/ 			
	*a++ = 0x03;							/* ControlSize (3)*/ 			
	*a++ = 0x00;*a++ = 0x00;*a++ = 0x00;	/* mControls */ 			


	
	
    /* Output Terminal Descriptor */
    *a++ = 0x09;                               /* Descriptor size (9) */
    *a++ = 0x24;                				/* Class specific interface desc type */
    *a++ = 0x03;                               /* Output Terminal Descriptor type */
    *a++ = 0x02;                               /* ID of this terminal (2) */
    *a++ = 0x01; *a++ = 0x01;                  /* USB Streaming terminal type */
    *a++ = 0x00;                               /* No association terminal */
    *a++ = 0x01;                               /* Source ID : 1 : Connected to Camera Terminal */
    *a++ = 0x00;                               /* String desc index : Not used */
	
	
	
	/* 			VideoControl Endpoint Descriptors 			*/

    /* Video Control Status Interrupt Endpoint Descriptor */
    *a++ = 0x07;                                /* Descriptor size (7) */
    *a++ = 0x05;            					/* Endpoint Descriptor Type */
    *a++ = 0x81;              					/* Endpoint address and description: EP-1 IN */
    *a++ = 0x03;                 				/* Interrupt End point Type */
    *a++ = 0x40; *a++ = 0x00;                   /* Max packet size: 64 bytes */
    *a++ = 0x01; 

   
   /* Super Speed Endpoint Companion Descriptor */
    *a++ = 0x06;                               /* Descriptor size (6) */
    *a++ = 0x30;           						/* SS Endpoint Companion Descriptor Type */
    *a++ = 0x00;                               /* Max no. of packets in a Burst: 1 */
    *a++ = 0x00;                               /* Attribute: N.A. */
    *a++ = 0x40;                               /* Bytes per interval: 64 */
    *a++ = 0x00;	



	/* Class-specific VC Interrupt Endpoint Descriptor */
    *a++ = 0x05;                           /* Length (5) */		
    *a++ = 0x25;                           /* DescriptorType ( CS_ENDPOINT ) */		
    *a++ = 0x03;                           /* DescriptorSubType ( EP_INTERRUPT ) */		
    *a++ = 0x40;*a++ = 0x00;               /* wMaxTransferSize ( 64 Bytes ) */		
	


	
	/* 				VideoStreaming Interface Descriptors 				*/
		
    /* Standard VS Interface Descriptor 			*/
	*a++ = 0x09;                           /* Length ( 9 )*/	
	*a++ = 0x04;                           /* DescriptorType (INTERFACE)*/	
	*a++ = 0x01;                           /* InterfaceNumber (1) */	
	*a++ = 0x00;                           /* AlternateSetting (0) */	
	*a++ = 0x01;                           /* NumEndpoints ( 1 )*/	
	*a++ = 0x0E;                           /* InterfaceClass (CC_VIDEO) */	
	*a++ = 0x02;                           /* InterfaceSubClass ( SC_VIDEOSTREAMING )*/	
	*a++ = 0x00;                           /* InterfaceProtocol  ( None ) */	
	*a++ = 0x00;                           /* Interface index ( 0 ) */	

	/* 	  Class-Specific VS Interface Descriptors 	*/
	
	/*Input Header Descriptor*/	
	*a++ = 0x0E;                           /* Length ( 14 )*/	
	*a++ = 0x24;                           /* DescriptorType ( CS_INTERFACE ) */	
	*a++ = 0x01;                           /* DescriptorSubtype ( VS_INPUT_HEADER) */	
	*a++ = 0x01;                           /* NumFormats ( 1 ) */	
	*a++ = 0x47;*a++ = 0x00;               /* TotalLength ( 71 Byte ) */   
	*a++ = 0x82;			               /* EndpointAddress ( 2 ) */ 	 
	*a++ = 0x00;			               /* mInfo ( 0 ) */ 	 
	*a++ = 0x02;			               /* TerminalLink ( 2 ) */ 	 
	*a++ = 0x01;			               /* StillCaptureMethod ( Method 1  ) */ 	 
	*a++ = 0x00;			               /* TriggerSupport ( Not supported ) */ 	 
	*a++ = 0x00;			               /* TriggerUsage ( None ) */ 	 
	*a++ = 0x01;			               /* ControlSize ( 1 byte ) */ 
	*a++ = 0x00;			               /* bmaControls ( None) */ 
	

	/* 		Payload Format Descriptors 				*/
	
	/* Uncompressed Video Format Descriptor */
	*a++ = 0x1B;                           							/* Length ( 27 )*/	
	*a++ = 0x24;                           							/* DescriptorType ( CS_INTERFACE )*/	
	*a++ = 0x04;                           							/* DescriptorSubtype ( VS_FORMAT_UNCOMPRESSED )*/	
	*a++ = 0x01;                           							/* FormatIndex (1) */	
	*a++ = 0x01;                           							/* NumFrameDescriptors (1) */	
	*a++ = 0x59;*a++ = 0x55;*a++ = 0x59;*a++ = 0x32;                /* guidFormat (YUV2 )*/	//	   32 59 55 59
	*a++ = 0x00;*a++ = 0x00;*a++ = 0x10;*a++ = 0x00;                /* guidFormat 		 */	//	   00 00 - 00 10 
	*a++ = 0x80;*a++ = 0x00;*a++ = 0x00;*a++ = 0xAA;                /* guidFormat 		 */	//  80 00  - 00 AA	
	*a++ = 0x00;*a++ = 0x38;*a++ = 0x9B;*a++ = 0x71;                /* guidFormat 		 */	//  00 38 9B 71 
	*a++ = 0x10;													/* BitsPerPixel ( 16bits )*/	
	*a++ = 0x01;                           							/* DefaultFrameIndex (1) */		
	*a++ = 0x00;                           							/* AspectRatioX ( 0 ) */		
	*a++ = 0x00;                           							/* AspectRatioY ( 0 )*/		
	*a++ = 0x00;                           							/* mInterlaceFlags ( 0 )*/		
	*a++ = 0x00;                           							/* CopyProtect (0) */	

	
	
    /* Class specific VS Frame Descriptor - YUY2 Format, frameIndex - 1 , Resolution1 2592 x 1944 @ 15.0 fps*/
    *a++ = 0x1E;                               /* Descriptor size (30) */
    *a++ = 0x24;                				/* Descriptor type*/
    *a++ = 0x05;                               /* Subtype:  frame interface*/
    *a++ = 0x01;                               /* Frame Descriptor Index: 1 */
    *a++ = 0x01;                               /*  Still image capture method 1 */
    //*a++ = 0x20;*a++ = 0x0a;                         					/* Width in pixel:  2592 */	
    *a++ = WIDTH & 0xff  ; *a++ = WIDTH >> 8 ;                         	/* Width in pixel:  2592 */	
    //*a++ = 0x98;*a++ = 0x07;                         					/* Height in pixel: 1944 */
    *a++ = HIGHT & 0xff  ; *a++ = HIGHT >> 8 ;                          /* Height in pixel: 1944 */
    //*a++ = 0x00;*a++ = 0xd0;*a++ = 0x14;*a++ = 0x48;             		/* Min bit rate (bits/s): 2592 x 1944 x 16 x 15.0 = 1209323520 */
    *a++ = BIT_RATE & 0xff ;*a++ = ( BIT_RATE >> 8 ) & 0xff ;*a++ = ( BIT_RATE >> 16 ) & 0xff ;*a++ = ( BIT_RATE >> 24 ) ;             /* Min bit rate (bits/s): 2592 x 1944 x 16 x 15.0 = 1209323520 */
    //*a++ = 0x00;*a++ = 0xd0;*a++ = 0x14;*a++ = 0x48;             /* Max bit rate (bits/s): Fixed rate so same as Min */
     *a++ = BIT_RATE & 0xff ;*a++ = ( BIT_RATE >> 8 ) & 0xff ;*a++ = ( BIT_RATE >> 16 ) & 0xff ;*a++ = ( BIT_RATE >> 24 ) ;             /* Max bit rate (bits/s): Fixed rate so same as Min */
    *a++ = 0x00;*a++ = 0xC6;*a++ = 0x99;*a++ = 0x00;             /* Maximum video or still frame size in bytes(Deprecated) */
    //*a++ = 0x2a;*a++ = 0x2c;*a++ = 0x0a;*a++ = 0x00;             /* Default frame interval (in 100ns units): (1/ 15.0)x10^7 */
    *a++ = FRAME_INTERVAL & 0xff ;*a++ = ( FRAME_INTERVAL >> 8 ) & 0xff ;*a++ = ( FRAME_INTERVAL >> 16 ) & 0xff ;*a++ = ( FRAME_INTERVAL >> 24 ) ;             /* Default frame interval (in 100ns units): (1/ 15.0)x10^7 */
    *a++ = 0x01;                               					/* Frame interval type : No of discrete intervals */
    *a++ = FRAME_INTERVAL & 0xff ;*a++ = ( FRAME_INTERVAL >> 8 ) & 0xff ;*a++ = ( FRAME_INTERVAL >> 16 ) & 0xff ;*a++ = ( FRAME_INTERVAL >> 24 ) ;             /* Frame interval 3: Same as Default frame interval */ 

	
    /* Endpoint Descriptor for BULK Video Data */
    *a++ = 0x07;                               /* Descriptor size (7)*/
    *a++ = 0x05;            					/* Endpoint Descriptor Type */
    *a++ = 0x82;                  				/* Endpoint address and description: EP 2 IN */
    *a++ = 0x02;                 				/* BULK End point */
    *a++ = 0x00; *a++ = 0x04 	 ;      		/* Maxpktsize 1024  */
    *a++ = 0x00; 								/* Interval 1uf	*/ 
	
    /* Super Speed Endpoint Companion Descriptor */
    *a++ = 0x06;                                /* Descriptor size (6) */
    *a++ = 0x30;           						/* SS Endpoint Companion Descriptor Type */
    *a++ = 0x0F;                               /* Max number of packets per burst: 16 */
    *a++ = 0x00;                               /* Attribute: NONE	 */
    *a++ = 0x00;  *a++ = 0x00 ;                /* bytes per interval reserved */
    //*a++ = BYTES_PER_INTERVAL & 0Xff;  *a++ = BYTES_PER_INTERVAL >> 8 ;            /* bytes per interval 1024 * 19 */



	///* Video Streaming Interface Descriptor */
	//*a++ = 0x09;                           /* Length ( 9 )*/	
	//*a++ = 0x04;                           /* DescriptorType (INTERFACE)*/	
	//*a++ = 0x01;                           /* InterfaceNumber (1) */	
	//*a++ = 0x01;                           /* AlternateSetting (1) */	
	//*a++ = 0x01;                           /* NumEndpoints ( 1 )*/	
	//*a++ = 0x0E;                           /* InterfaceClass (CC_VIDEO) */	
	//*a++ = 0x02;                           /* InterfaceSubClass ( SC_VIDEOSTREAMING )*/	
	//*a++ = 0x00;                           /* InterfaceProtocol  ( None ) */	
	//*a++ = 0x00;                           /* Interface index ( 0 ) */	
	//
    ///* Endpoint Descriptor for ISO Video Data */
    //*a++ = 0x07;                               /* Descriptor size (7)*/
    //*a++ = 0x05;            					/* Endpoint Descriptor Type */
    //*a++ = 0x82;                  				/* Endpoint address and description: EP 2 IN */
    //*a++ = 0x05;                 				/* ISO End point ( Async ISO )*/
    //*a++ = 0x00; *a++ = 0x04 	 ;      		/* Maxpktsize 1024  */
    //*a++ = 0x01; 								/* Interval 1uf	*/ 
	//
    ///* Super Speed Endpoint Companion Descriptor */
    //*a++ = 0x06;                                /* Descriptor size (6) */
    //*a++ = 0x30;           						/* SS Endpoint Companion Descriptor Type */
    //*a++ = 0x0F;                               /* Max number of packets per burst: 16 */
    //*a++ = 0x01;                               /* Attribute: 32 pkts max per interval	 */
    ////*a++ = 0x00;  *a++ = 0x04 * 19;            /* bytes per interval 1024 * 19 */
    //*a++ = BYTES_PER_INTERVAL & 0Xff;  *a++ = BYTES_PER_INTERVAL >> 8 ;            /* bytes per interval 1024 * 19 */
    
	
	//write_buf32( 186 ); //todo 
	write_buf32( 177 );  
	
}

/* Binary device object store descriptor */
void add_bos_descr () 
{
	a = buf_2;
	
    *a++ = 0x05;                           /* Descriptor size */
    *a++ = 0x0f;            			   /* BOS descriptor type */
    *a++ = 0x16;*a++ = 0x00,               /* Length of this descriptor and all sub descriptors */
    *a++ = 0x02;                           /* Number of device capability descriptors */

    /* USB 2.0 extension */
    *a++ = 0x07;                            			/* Descriptor size */
    *a++ = 0x10;       									/* Device capability type descriptor */
    *a++ = 0x02;       									/* USB 2.0 extension capability type */
    *a++ = 0x02;*a++ = 0x00;*a++ = 0x00;*a++ = 0x00;    /* Supported device level features: LPM support  */

    /* SuperSpeed device capability */
    *a++ = 0x0A;                           /* Descriptor size */
    *a++ = 0x10;       					   /* Device capability type descriptor */
    *a++ = 0x03;        				   /* SuperSpeed device capability type */
    *a++ = 0x00;                           /* Supported device level features  */
    *a++ = 0x0E;*a++ = 0x00;               /* Speeds supported by the device : SS, HS and FS */
    *a++ = 0x03;                           /* Functionality support */
    *a++ = 0x00;                           /* U1 Device Exit latency */
    *a++ = 0x00;*a++ = 0x00;               /* U2 Device Exit latency */
	
	write_buf32( 22 ); 
	
};


/* Standard language ID string descriptor */
void add_str0_descr () 
{
	
	a = buf_2;
	
    *a++ = 0x04;                           /* Descriptor size */
    *a++ = 0x03;                           /* Device descriptor type */
    *a++ = 0x09;*a++ = 0x04;               /* Language ID supported */
	
	write_buf32( 4 ); 
};

/* Standard manufacturer string descriptor */
void add_str1_descr ()
{
	a = buf_2;	
	
    *a++ = 0x0C;                           /* Descriptor size ( 12 ) */
    *a++ = 0x03;                           /* Device descriptor type ( string )*/
    *a++ = 'G';*a++ = 0x00;
    *a++ = 'o';*a++ = 0x00;
    *a++ = 'w';*a++ = 0x00;
    *a++ = 'i';*a++ = 0x00;
    *a++ = 'n';*a++ = 0x00;

	write_buf32( 12 ); 
	
};

/* Standard product string descriptor */
void add_str2_descr ()
{
	a = buf_2;
	
    *a++ = 0x08;                           /* Descriptor size ( 8 )*/
    *a++ = 0x03;                           /* Device descriptor type ( string ) */
    *a++ = 'U';*a++ = 0x00;
    *a++ = 'V';*a++ = 0x00;
    *a++ = 'C';*a++ = 0x00;
	
	write_buf32( 8 ); 
};

/* Standard MSFT string descriptor */
void add_MSFT_descr ()
{
	a = buf_2;
	
    *a++ = 0x12;                           /* Descriptor size */
    *a++ = 0x03;                           /* Device descriptor type */
    *a++ = 'M';*a++ = 0x00;
    *a++ = 'S';*a++ = 0x00;
    *a++ = 'F';*a++ = 0x00;
    *a++ = 'T';*a++ = 0x00;
    *a++ = '1';*a++ = 0x00;
    *a++ = '0';*a++ = 0x00;
    *a++ = '0';*a++ = 0x00;
	*a++ = 0x00; 
	*a++ = 0x00; 
	
	write_buf32( 18 ); 
};

float PKT_NUM_PRE_UFRAME ;
float FRAME_INTERVAL_float ;
u32 PIXEL_NUM_PER_UFRAME ;
u32 PIXEL_NUM_LAST_UFRAME ;
u32 UFRAME_NUM_PER_FRAME ;

u32 NORMAL_PAYLOAD_NUM ;
u32 PIXEL_NUM_NORMAL_PAYLOAD ;
u32 PIXEL_NUM_LAST_PAYLOAD ;
 
u32 NORM_PAYLOAD_PIXEL_NUM ;
u32 LAST_PAYLOAD_PIXEL_NUM ;

u32 MaxVideoFrameSize ;
u32 MaxPayloadTransferSize ;



void temp( char i )
{

	
	fprintf(temp_v,"//======================================================						 \n" ,  i );
	fprintf(temp_v,"always @ ( posedge clk or negedge rst_n ) begin									 \n" ,  i );
	fprintf(temp_v,"	if (!rst_n) begin                                                            \n" ,  i );
	fprintf(temp_v,"		buf_%c_ready <= 1 ;                                                      \n" ,  i );
	fprintf(temp_v,"		buf_%c_hasdata <= 0 ;                                                    \n" ,  i );
	fprintf(temp_v,"		buf_%c_wt_ack <= 0 ;                                                     \n" ,  i );
	fprintf(temp_v,"	end                                                                          \n" ,  i );
	fprintf(temp_v,"	else if ( buf_in_ready && buf_in_commit && buf_in_pt == %c ) begin           \n" ,  i );
	fprintf(temp_v,"		buf_%c_ready <= 0 ;                                                      \n" ,  i );
	fprintf(temp_v,"		buf_%c_hasdata <= 1 ;                                                    \n" ,  i );
	fprintf(temp_v,"		buf_%c_eob <= buf_in_eob ;                                               \n" ,  i );
	fprintf(temp_v,"	end                                                                          \n" ,  i );
	fprintf(temp_v,"	else if ( buf_out_hasdata && buf_out_arm && buf_out_pt == %c ) begin         \n" ,  i );
	fprintf(temp_v,"		buf_%c_ready <= 1 ;                                                      \n" ,  i );
	fprintf(temp_v,"		buf_%c_hasdata <= 0 ;                                                    \n" ,  i );
	fprintf(temp_v,"		buf_%c_wt_ack <= 1 ;                                                     \n" ,  i );
	fprintf(temp_v,"	end                                                                          \n" ,  i );
	fprintf(temp_v,"	else if ( buf_out_dp_acked && buf_out_next_dp_ack_pt == %c ) begin           \n" ,  i );
	fprintf(temp_v,"		buf_%c_wt_ack <= 0 ;                                                     \n" ,  i );
	fprintf(temp_v,"	end                                                                          \n" ,  i );
	fprintf(temp_v,"end	                                                                             \n" ,  i );
	
	
}

int main(int argc, char *argv[])
{
	printf("\n* USB 3.0 descriptor export tool\n ");
	
	fail(init_3 = fopen(filename_usb3_init, "w"), "Failed opening USB3.0 descriptor rom init");	
	
	fail(descrip_vh = fopen(filename_descrip_vh, "w"), "Failed opening descriptor include");
	
	fail(UVCDefine_v = fopen(filename_UVCDefine_v, "w"), "Failed opening UVC Define ");
	
	fail(temp_v = fopen(filename_temp_v, "w"), "Failed opening temp_v ");	

	temp('a');
	temp('b');
	temp('c');
	temp('d');
	temp('e');
	temp('f');
	temp('g');
	temp('h');
	temp('i');
	temp('j');
	temp('k');
	temp('l');
	temp('m');
	temp('n');
	temp('o');
	temp('p');
	
	

	printf ("* Generating...\n");
	
	// set your BRAM address bit widths
	DESCR_USB3_ROM_ADD_W = 10 ;

	fprintf(descrip_vh,"parameter	DESCR_USB3_ROM_ADD_W	= 'd%d;\n" , DESCR_USB3_ROM_ADD_W );
	
	// set Width in pixel:  2592
		WIDTH =  640 ;
	// set Height in pixel:  1944
		HIGHT =  480 ;
	// set FPS : 15 
		FPS = 53 ;
	
	
	
	
	
	// set frame interval (1/FPS)*10^7 (in 100ns)
		FRAME_INTERVAL_float = ( 1 / (float)FPS )*10000000 ;
		FRAME_INTERVAL = (u32) FRAME_INTERVAL_float ;		
		
	PKT_NUM_PRE_UFRAME = (u8)ceil ( ( (float)WIDTH * HIGHT * FPS * 2  + 2 * 8000 ) / 8000 / 1024 ) ;
	
	// set burst length  	
		//PKT_NUM = (u8)PKT_NUM_PRE_UFRAME;
		PKT_NUM = 60 ;
		
	
	PIXEL_NUM_NORMAL_PAYLOAD =  ( ( ( 1024 * PKT_NUM - 2 ) -  ( 1024 * PKT_NUM - 2 ) % 4  )  / 4 ) * 2 ;
	
	NORMAL_PAYLOAD_NUM = floor( (float)WIDTH * HIGHT / PIXEL_NUM_NORMAL_PAYLOAD ) ;
	
	PIXEL_NUM_LAST_PAYLOAD = WIDTH * HIGHT - NORMAL_PAYLOAD_NUM * PIXEL_NUM_NORMAL_PAYLOAD ;
	
	// set bit rate 	
		BIT_RATE = 	WIDTH * HIGHT * FPS * 16 ;
	// set bytes to be sent per interval 
		BYTES_PER_INTERVAL = PKT_NUM * 1024 ;
		

	printf(" Width = %d  Hight = %d FPS = %d ;\n" , WIDTH , HIGHT , FPS  );	
	//printf(" Number of pkts per uFrame = %.0f ;\n" , PKT_NUM_PRE_UFRAME  );	
	//printf(" Number of pixels per Normal payload = %d ;\n" , PIXEL_NUM_NORMAL_PAYLOAD  );	
	//printf(" Number of pixels last payload  = %d ;\n" , PIXEL_NUM_LAST_PAYLOAD  );	
	
	if ( PIXEL_NUM_NORMAL_PAYLOAD * 2 + 2 > PKT_NUM * 1024 ) 
		printf(" PIXEL_NUM_NORMAL_PAYLOAD error  ;\n"    );	
	
	if ( PIXEL_NUM_NORMAL_PAYLOAD * NORMAL_PAYLOAD_NUM + PIXEL_NUM_LAST_PAYLOAD != WIDTH * HIGHT )
		printf(" NORMAL_PAYLOAD_NUM error  ;\n"    );	
	else 
		{
			printf(" PAYLOAD_NUM = %d ; PIXEL_NUM_NORMAL_PAYLOAD = %d   PIXEL_NUM_LAST_PAYLOAD = %d ;\n"  , NORMAL_PAYLOAD_NUM + 1, PIXEL_NUM_NORMAL_PAYLOAD , PIXEL_NUM_LAST_PAYLOAD );
			printf(" bandwidth = %f Gbps ;\n"  , ( float ) BIT_RATE / 1000000000  );

		}
		
	
	

	
	
	fprintf(UVCDefine_v,"`define pixel_num	%d \n" , WIDTH * HIGHT );
	fprintf(UVCDefine_v,"`define normal_pixel_num %d \n" , PIXEL_NUM_NORMAL_PAYLOAD );
	fprintf(UVCDefine_v,"`define last_pixel_num %d \n" , PIXEL_NUM_LAST_PAYLOAD );

	UFRAME_NUM_PER_FRAME = (u32) ceil ( (float) 8000 / FPS ) ;
	PIXEL_NUM_PER_UFRAME = (u32) ceil ( (float) WIDTH * HIGHT / UFRAME_NUM_PER_FRAME ) ;
	PIXEL_NUM_PER_UFRAME = PIXEL_NUM_PER_UFRAME + ( PIXEL_NUM_PER_UFRAME % 2 ) ;
	PIXEL_NUM_LAST_UFRAME = ( WIDTH * HIGHT ) % PIXEL_NUM_PER_UFRAME ; 
	
	
	if ( PIXEL_NUM_PER_UFRAME * (UFRAME_NUM_PER_FRAME - 1) + PIXEL_NUM_LAST_UFRAME != WIDTH * HIGHT ) 
		printf(" PIXgen error  ;\n"    );	
	
	fprintf(UVCDefine_v,"`define uframe_num	%d \n" , UFRAME_NUM_PER_FRAME );
	fprintf(UVCDefine_v,"`define width	%d \n" , WIDTH );
	fprintf(UVCDefine_v,"`define hidth	%d \n" , HIGHT );
	fprintf(UVCDefine_v,"`define normal_uframe_pixel_num %d \n" , PIXEL_NUM_PER_UFRAME );
	fprintf(UVCDefine_v,"`define last_uframe_pixel_num %d \n" , PIXEL_NUM_LAST_UFRAME );
	fprintf(UVCDefine_v,"`define frame_interval %d \n" , FRAME_INTERVAL );
	
	MaxVideoFrameSize = WIDTH * HIGHT * 2 ;
	fprintf(UVCDefine_v,"`define MaxVideoFrameSize %d \n" , MaxVideoFrameSize );
	
	MaxPayloadTransferSize = PIXEL_NUM_NORMAL_PAYLOAD * 2 + 2 ;
	fprintf(UVCDefine_v,"`define MaxPayloadTransferSize %d \n" , MaxPayloadTransferSize );
	
	// ====== start of descriptors
	
	/* Standard device descriptor for USB 3.0 */
	fprintf(descrip_vh,"parameter	[%d:0]	DESCR_USB3_DEVICE	= 'd0;\n" , DESCR_USB3_ROM_ADD_W - 1 );
	add_device_descr();	
	fprintf(descrip_vh,"parameter	[%d:0]	DESCR_USB3_DEVICE_LEN = 'd18;\n" , DESCR_USB3_ROM_ADD_W - 1 );
	
	
	/* Standard super speed configuration descriptor */
	fprintf(descrip_vh,"parameter	[%d:0]	DESCR_USB3_CONFIG	= 'd5;\n" , DESCR_USB3_ROM_ADD_W - 1 );	
	add_config_descr();		
	fprintf(descrip_vh,"parameter	[%d:0]	DESCR_USB3_CONFIG_LEN = 'd177;\n" , DESCR_USB3_ROM_ADD_W - 1 );	
	
	/* Binary device object store descriptor */
	fprintf(descrip_vh,"parameter	[%d:0]	DESCR_USB3_BOS	= 'd50;\n" , DESCR_USB3_ROM_ADD_W - 1 );	
	add_bos_descr();		
	fprintf(descrip_vh,"parameter	[%d:0]	DESCR_USB3_BOS_LEN = 'd22;\n" , DESCR_USB3_ROM_ADD_W - 1 );	
	
	/* Standard language ID string descriptor */
	fprintf(descrip_vh,"parameter	[%d:0]	DESCR_USB3_STR0	= 'd56;\n" , DESCR_USB3_ROM_ADD_W - 1 );	
	add_str0_descr (); 	
	fprintf(descrip_vh,"parameter	[%d:0]	DESCR_USB3_STR0_LEN = 'd4;\n" , DESCR_USB3_ROM_ADD_W - 1 );	

	/* Standard manufacturer string descriptor */
	fprintf(descrip_vh,"parameter	[%d:0]	DESCR_USB3_STR1	= 'd57;\n" , DESCR_USB3_ROM_ADD_W - 1 );	
	add_str1_descr (); 	
	fprintf(descrip_vh,"parameter	[%d:0]	DESCR_USB3_STR1_LEN = 'd12;\n", DESCR_USB3_ROM_ADD_W - 1 );	
	
	/*Standard product string descriptor */
	fprintf(descrip_vh,"parameter	[%d:0]	DESCR_USB3_STR2	= 'd60;\n" , DESCR_USB3_ROM_ADD_W - 1 );	
	add_str2_descr (); 	
	fprintf(descrip_vh,"parameter	[%d:0]	DESCR_USB3_STR2_LEN = 'd8;\n", DESCR_USB3_ROM_ADD_W - 1 );		
	
	/* Standard MSFT string descriptor */
	fprintf(descrip_vh,"parameter	[%d:0]	DESCR_USB3_MSFT	= 'd62;\n", DESCR_USB3_ROM_ADD_W - 1 );	
	add_MSFT_descr (); 	
	fprintf(descrip_vh,"parameter	[%d:0]	DESCR_USB3_MSFT_LEN = 'd18;\n", DESCR_USB3_ROM_ADD_W - 1 );

	// ====== end of descriptors 
	
	DESCR_USB3_LEN = pow ( 2 , DESCR_USB3_ROM_ADD_W) ;
	fprintf(descrip_vh,"parameter	DESCR_USB3_LEN = 'd%d ;\n", DESCR_USB3_LEN );	
	
	printf("* Finished\n");				
	fclose(init_3);
	fclose(descrip_vh);					

}