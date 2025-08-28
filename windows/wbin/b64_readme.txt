Readme file for b64.c 

  b64      (Base64 Encode/Decode)    Bob Trower 2001/08/03
           (C) Copr Bob Trower 1986-2015     Version 0.94R
  Usage:   b64 -option [-l<num>] [<FileIn> [<FileOut>]]
  Purpose: This program is a simple utility that implements
           Base64 Content-Transfer-Encoding (RFC1113).
  Options: -e  encode to Base64   -h  This help text.
           -d  decode from Base64 -?  This help text.
           -t  Show test instructions. Under Windows the
               following command line will pipe the help
               text to run a test:
                   b64 -t | cmd
  Note:    -l  use to change line size (from 72 characters)
  Returns: 0 = success.  Non-zero is an error code.
  ErrCode: 1 = Bad Syntax, 2 = File Open, 3 = File I/O
  Example: b64 -e binfile b64file     <- Encode to b64
           b64 -d b64file binfile     <- Decode from b64
           b64 -e -l40 infile outfile <- Line Length of 40
  Note:    Will act as a filter, but this should only be
           used on text files due to translations made by
           operating systems.
  Source:  Source code and latest releases can be found at:
           http://base64.sourceforge.net
  Release: 0.94.00, Thu Oct 29 01:36:00 2015, ANSI-SOURCE C
  
This source code may be used as you wish, subject to
the MIT license.  See the LICENCE section in the code.

Canonical source should be at:
    http://base64.sourceforge.net

This little utility implements the Base64
Content-Transfer-Encoding standard described in
RFC1113 (http://www.faqs.org/rfcs/rfc1113.html).

This is the coding scheme used by MIME to allow
binary data to be transferred by SMTP mail.

More documentation is in the b64.c source file. 

