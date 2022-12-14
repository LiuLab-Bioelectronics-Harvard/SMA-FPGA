/*
 * Copyright (C) 2009 - 2018 Xilinx, Inc.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice,
 *    this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution.
 * 3. The name of the author may not be used to endorse or promote products
 *    derived from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR IMPLIED
 * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT
 * SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT
 * OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
 * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY
 * OF SUCH DAMAGE.
 *
 */

#include <stdio.h>
#include "sleep.h"
#include "xparameters.h"

#include "netif/xadapter.h"

#include "platform.h"
#include "platform_config.h"
#if defined (__arm__) || defined(__aarch64__)
#include "xil_printf.h"
#endif

#include "lwip/tcp.h"
#include "xil_cache.h"


#if LWIP_DHCP==1
#include "lwip/dhcp.h"

#endif

/* defined by each RAW mode application */
//void print_app_header();
//int start_application();
//int transfer_data();
void tcp_fasttmr(void);
void tcp_slowtmr(void);

//#include "pl_bram_rd.h"
#include "xbram.h"
//=============================================================================================

#include "xscugic.h"
#include "xgpiops.h"
#include "xil_exception.h"

#define GPIO_DEVICE_ID		XPAR_XGPIOPS_0_DEVICE_ID
#define INTC_DEVICE_ID	    XPAR_SCUGIC_SINGLE_DEVICE_ID
#define KEY_INTR_ID        XPAR_XGPIOPS_0_INTR

int	key_flag=0;/*????????*/

XScuGic INTCInst;
XGpioPs Gpio;	/* The driver instance for GPIO Device. */



//int IntrInitFuntion(XScuGic *InstancePtr, u16 DeviceId, XGpioPs *GpioInstancePtr);
//void GpioHandler(void *CallbackRef);
void GpioHandler(void *CallbackRef)
{
	XGpioPs *GpioInstancePtr = (XGpioPs *)CallbackRef ;
	int Int_val ;

	Int_val = XGpioPs_IntrGetStatusPin(GpioInstancePtr, 55) ;
	/*
	 * Clear interrupt.
	 */
	XGpioPs_IntrClearPin(GpioInstancePtr, 55) ;
	if (Int_val)
		key_flag = 1 ;
}


int IntrInitFuntion(XScuGic *InstancePtr, u16 DeviceId, XGpioPs *GpioInstancePtr)
{
	XScuGic_Config *IntcConfig;
	int Status ;
	/*
	 * Initialize the interrupt controller driver so that it is ready to
	 * use.
	 */
	IntcConfig = XScuGic_LookupConfig(INTC_DEVICE_ID);

	Status = XScuGic_CfgInitialize(InstancePtr, IntcConfig, IntcConfig->CpuBaseAddress) ;
	if (Status != XST_SUCCESS)
		return XST_FAILURE ;

	/*
	 * set priority and trigger type
	 */
	XScuGic_SetPriorityTriggerType(InstancePtr, KEY_INTR_ID,
			0xA0, 0x3);
	/*
	 * Connect the device driver handler that will be called when an
	 * interrupt for the device occurs, the handler defined above performs
	 * the specific interrupt processing for the device.
	 */
	Status = XScuGic_Connect(InstancePtr, KEY_INTR_ID,
			(Xil_ExceptionHandler)GpioHandler,
			(void *)GpioInstancePtr) ;
	if (Status != XST_SUCCESS)
		return XST_FAILURE ;

	/*
	 * Enable the interrupt for the device.
	 */
	XScuGic_Enable(InstancePtr, KEY_INTR_ID) ;

	Xil_ExceptionInit();

	Xil_ExceptionRegisterHandler(XIL_EXCEPTION_ID_INT,
			(Xil_ExceptionHandler)XScuGic_InterruptHandler,
			InstancePtr);
	Xil_ExceptionEnable();

	return XST_SUCCESS ;

}



//=================================================================================================
//#include <stdio.h>
#include <string.h>

#include "lwip/err.h"
//#include "lwip/tcp.h"
//#if defined (__arm__) || defined (__aarch64__)
//#include "xil_printf.h"
//#endif





int transfer_data() {
	return 0;
}

void print_app_header()
{
	xil_printf("\n\r\n\r-----lwIP TCP echo server ------\n\r");
	xil_printf("TCP packets sent to port 6001 will be echoed back\n\r");
}

err_t recv_callback(void *arg, struct tcp_pcb *tpcb,
                               struct pbuf *p, err_t err)
{
	/* do not read the packet if we are not in ESTABLISHED state */
	if (!p) {
		tcp_close(tpcb);
		tcp_recv(tpcb, NULL);
		return ERR_OK;
	}
	int i=0,wr_cnt = 0;
	unsigned   char arr[512] ={0};
	unsigned   char arrb[512] ={0};
	int key_input_value=0;
	/* indicate that the packet has been received */
	tcp_recved(tpcb, p->len);

    //strcpy(arrb,p->payload);
    memcpy(arrb,p->payload,512);
    key_input_value=XGpioPs_ReadPin(&Gpio,55);


    //=================??????????????fpga????????????============================
    if (tcp_sndbuf(tpcb) > p->len) {

    	    //??????????BRAM??????1??????
    	    for(i = 0 ; i < 2048 ;i += 4){
    	        XBram_WriteReg(XPAR_BRAM_0_BASEADDR,i,arrb[wr_cnt]) ;
    	        wr_cnt++;
    	    }
    		XGpioPs_WritePin(&Gpio,54, 0x1);//????????
    		xil_printf("%d\n",p->len);
    		xil_printf("%d\n",arrb[0]);
    		xil_printf("%d\n",arrb[1]);
    		xil_printf("%d\n",key_input_value);
    }


   //===================????FPGA??????????????????????============================



	 while(1){
		if(XGpioPs_ReadPin(&Gpio,55)==0x01)//????????????
		    {
			for(i = 0 ; i < 2048 ;i += 4){
			    	   arr[i/4]=XBram_ReadReg(XPAR_BRAM_0_BASEADDR,i) ;

			    	    }
			   err = tcp_write(tpcb, &arr, 6, 1);
			   XGpioPs_WritePin(&Gpio,54, 0x0);//??????????????????
			   xil_printf("%d\n",XGpioPs_ReadPin(&Gpio,55));
			   xil_printf("%d\n",XGpioPs_ReadPin(&Gpio,56));
			   break;
		     }
		//else
		//if(XGpioPs_ReadPin(&Gpio,56)==0x01)//???????? ????????
		//    {
		//	 xil_printf("%d\n",key_input_value);
		//	 break;
		//     }
		else
			xil_printf("%d\n",XGpioPs_ReadPin(&Gpio,55));
		    xil_printf("%d\n",XGpioPs_ReadPin(&Gpio,56));
		// free the received pbuf
			//pbuf_free(p);

	 }




/*

    if(XGpioPs_ReadPin(&Gpio,55)==0x00)//????????????????????????????????????
    	{

        err = tcp_write(tpcb, &arr, 10, 1);
    	XGpioPs_WritePin(&Gpio,54, 0x0);//??????????????????


         }
*/



/*
//  echo back the payload
//in this case, we assume that the payload is < TCP_SND_BUF
   if (tcp_sndbuf(tpcb) > p->len) {
	   err = tcp_write(tpcb, p->payload, p->len, 1);
	} else
		xil_printf("no space in tcp_sndbuf\n\r");

	// free the received pbuf
	pbuf_free(p);
*/

    // free the received pbuf
    	pbuf_free(p);

	return ERR_OK;
}

err_t accept_callback(void *arg, struct tcp_pcb *newpcb, err_t err)
{
	static int connection = 1;

	/* set the receive callback for this connection */
	tcp_recv(newpcb, recv_callback);

	/* just use an integer number indicating the connection id as the
	   callback argument */
	tcp_arg(newpcb, (void*)(UINTPTR)connection);

	/* increment for subsequent accepted connections */
	connection++;

	return ERR_OK;
}


int start_application()
{
	struct tcp_pcb *pcb;
	err_t err;
	unsigned port = 7;

	/* create new TCP PCB structure */
	pcb = tcp_new_ip_type(IPADDR_TYPE_ANY);
	if (!pcb) {
		xil_printf("Error creating PCB. Out of Memory\n\r");
		return -1;
	}

	/* bind to specified @port */
	err = tcp_bind(pcb, IP_ANY_TYPE, port);
	if (err != ERR_OK) {
		xil_printf("Unable to bind to port %d: err = %d\n\r", port, err);
		return -2;
	}

	/* we do not need any arguments to callback functions */
	tcp_arg(pcb, NULL);

	/* listen for connections */
	pcb = tcp_listen(pcb);
	if (!pcb) {
		xil_printf("Out of memory while tcp_listen\n\r");
		return -3;
	}

	/* specify callback to use for incoming connections */
	tcp_accept(pcb, accept_callback);

	xil_printf("TCP echo server started @ port %d\n\r", port);
	XGpioPs_WritePin(&Gpio,7, 0x1);
	return 0;
}

//===========================================================================================================



//------------------------------------------------------------------------------------------
/* missing declaration in lwIP */
void lwip_init();


#if LWIP_DHCP==1
extern volatile int dhcp_timoutcntr;
err_t dhcp_start(struct netif *netif);
#endif


extern volatile int TcpFastTmrFlag;
extern volatile int TcpSlowTmrFlag;
static struct netif server_netif;
struct netif *echo_netif;


void
print_ip(char *msg, ip_addr_t *ip)
{
	print(msg);
	xil_printf("%d.%d.%d.%d\n\r", ip4_addr1(ip), ip4_addr2(ip),
			ip4_addr3(ip), ip4_addr4(ip));
}

void
print_ip_settings(ip_addr_t *ip, ip_addr_t *mask, ip_addr_t *gw)
{

	print_ip("Board IP: ", ip);
	print_ip("Netmask : ", mask);
	print_ip("Gateway : ", gw);
}


#if defined (__arm__) && !defined (ARMR5)
#if XPAR_GIGE_PCS_PMA_SGMII_CORE_PRESENT == 1 || XPAR_GIGE_PCS_PMA_1000BASEX_CORE_PRESENT == 1
int ProgramSi5324(void);
int ProgramSfpPhy(void);
#endif
#endif

#ifdef XPS_BOARD_ZCU102
#ifdef XPAR_XIICPS_0_DEVICE_ID
int IicPhyReset(void);
#endif
#endif

int main()
{



	//==========??????gpio===========

				    //init_platform();
				    XGpioPs_Config *ConfigPtr;
					int Status;
					//key_flag = 0 ;
					//int key_val=0;
					/* Initialize the GPIO driver. */
					ConfigPtr = XGpioPs_LookupConfig(GPIO_DEVICE_ID);
					Status = XGpioPs_CfgInitialize(&Gpio, ConfigPtr,
							ConfigPtr->BaseAddr);
					if (Status != XST_SUCCESS) {
						return XST_FAILURE;
					}

					XGpioPs_SetDirectionPin(&Gpio, 7, 1);//gpio??????????
					XGpioPs_SetOutputEnablePin(&Gpio, 7, 1);
					XGpioPs_WritePin(&Gpio,7, 0x0);

					XGpioPs_SetDirectionPin(&Gpio, 54, 1);//gpio??????????
					XGpioPs_SetOutputEnablePin(&Gpio, 54, 1);
					XGpioPs_WritePin(&Gpio,54, 0x0);

					XGpioPs_SetDirectionPin(&Gpio, 55, 0);
					XGpioPs_SetIntrTypePin(&Gpio, 55, XGPIOPS_IRQ_TYPE_EDGE_RISING) ;
					XGpioPs_IntrEnablePin(&Gpio, 55) ;

					XGpioPs_SetDirectionPin(&Gpio, 56, 0);

					/*
					 * sets up the interrupt system
				     */
					Status = IntrInitFuntion(&INTCInst, GPIO_DEVICE_ID, &Gpio) ;
					if (Status != XST_SUCCESS)
					return XST_FAILURE ;










	ip_addr_t ipaddr, netmask, gw;


	/* the mac address of the board. this should be unique per board */
	unsigned char mac_ethernet_address[] =
	{ 0x00, 0x0a, 0x35, 0x00, 0x01, 0x02 };

	echo_netif = &server_netif;
#if defined (__arm__) && !defined (ARMR5)
#if XPAR_GIGE_PCS_PMA_SGMII_CORE_PRESENT == 1 || XPAR_GIGE_PCS_PMA_1000BASEX_CORE_PRESENT == 1
	ProgramSi5324();
	ProgramSfpPhy();
#endif
#endif

/* Define this board specific macro in order perform PHY reset on ZCU102 */
#ifdef XPS_BOARD_ZCU102
	if(IicPhyReset()) {
		xil_printf("Error performing PHY reset \n\r");
		return -1;
	}
#endif

	init_platform();


#if LWIP_DHCP==1
    ipaddr.addr = 0;
	gw.addr = 0;
	netmask.addr = 0;
#else
	/* initliaze IP addresses to be used */
	IP4_ADDR(&ipaddr,  192, 168,   1, 10);
	IP4_ADDR(&netmask, 255, 255, 255,  0);
	IP4_ADDR(&gw,      192, 168,   1,  1);
#endif

	print_app_header();

	lwip_init();


	/* Add network interface to the netif_list, and set it as default */
	if (!xemac_add(echo_netif, &ipaddr, &netmask,
						&gw, mac_ethernet_address,
						PLATFORM_EMAC_BASEADDR)) {
		xil_printf("Error adding N/W interface\n\r");
		return -1;
	}

	netif_set_default(echo_netif);

	/* now enable interrupts */
	platform_enable_interrupts();

	/* specify that the network if is up */
	netif_set_up(echo_netif);


#if (LWIP_DHCP==1)
	/* Create a new DHCP client for this interface.
	 * Note: you must call dhcp_fine_tmr() and dhcp_coarse_tmr() at
	 * the predefined regular intervals after starting the client.
	 */
	dhcp_start(echo_netif);
	dhcp_timoutcntr = 24;

	while(((echo_netif->ip_addr.addr) == 0) && (dhcp_timoutcntr > 0))
		xemacif_input(echo_netif);

	if (dhcp_timoutcntr <= 0) {
		if ((echo_netif->ip_addr.addr) == 0) {
			xil_printf("DHCP Timeout\r\n");
			xil_printf("Configuring default IP of 192.168.1.10\r\n");
			IP4_ADDR(&(echo_netif->ip_addr),  192, 168,   1, 10);
			IP4_ADDR(&(echo_netif->netmask), 255, 255, 255,  0);
			IP4_ADDR(&(echo_netif->gw),      192, 168,   1,  1);
		}
	}

	ipaddr.addr = echo_netif->ip_addr.addr;
	gw.addr = echo_netif->gw.addr;
	netmask.addr = echo_netif->netmask.addr;
#endif

	print_ip_settings(&ipaddr, &netmask, &gw);


	/* start the application (web server, rxtest, txtest, etc..) */
	start_application();

	/* receive and process packets */
	while (1) {
		if (TcpFastTmrFlag) {
			tcp_fasttmr();
			TcpFastTmrFlag = 0;
		}
		if (TcpSlowTmrFlag) {
			tcp_slowtmr();
			TcpSlowTmrFlag = 0;
		}
		xemacif_input(echo_netif);
		//transfer_data();
	}

	/* never reached */
	cleanup_platform();

	return 0;
}
