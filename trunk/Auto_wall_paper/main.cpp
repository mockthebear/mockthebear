#include <iostream>
#if       _WIN32_WINNT < 0x0500
  #undef  _WIN32_WINNT
  #define _WIN32_WINNT   0x0500
#endif
#include <windows.h>
extern "C" {
	#include "lua.h"
	#include "lualib.h"
	#include "lauxlib.h"
}
lua_State* L;
static int setWallPaper(lua_State *Lua)
{
 SystemParametersInfo( SPI_SETDESKWALLPAPER, 0, (PVOID)lua_tostring(Lua, 1), SPIF_SENDCHANGE );
 return 1;
}

#include <jpeglib.h>
#include <stdlib.h>
#include <string.h>
#include <mmsystem.h>  // mciSendString()

unsigned char *raw_image = NULL;

int width;
int height;
int bytes_per_pixel;   /* or 1 for GRACYSCALE images */
int color_space; /* or JCS_GRAYSCALE for grayscale images */

typedef struct {
     long filesize;
     char reserved[2];
     long headersize;
     long infoSize;
     long width;
     long depth;
     short biPlanes;
     short bits;
     long biCompression;
     long biSizeImage;
     long biXPelsPerMeter;
     long biYPelsPerMeter;
     long biClrUsed;
     long biClrImportant;
} BMPHEAD;

int write_bmp_file( char *filename )
{

 BMPHEAD bh;

 memset ((char *)&bh,0,sizeof(BMPHEAD)); /* sets everything to 0 */

 //bh.filesize  =   calculated size of your file (see below)
 //bh.reserved  = two zero bytes
 bh.headersize  = 54L;//  (for 24 bit images)
 bh.infoSize  =  0x28L;//  (for 24 bit images)
 bh.width     = width ;//in pixels of your image
 bh.depth     = height;// in pixels of your image
 bh.biPlanes  =  1 ;//(for 24 bit images)
 bh.bits      = 24 ;//(for 24 bit images)
 bh.biCompression = 0L;;//  (no compression)

 int bytesPerLine;

 bytesPerLine = width * 3;  /* (for 24 bit images) */
 /* round up to a dword boundary */
 if (bytesPerLine & 0x0003) 
    {
    bytesPerLine |= 0x0003;
    ++bytesPerLine;
    }
 bh.filesize=bh.headersize+(long)bytesPerLine*bh.depth;

 FILE * bmpfile;


 bmpfile = fopen("temp.bmp", "wb");
 if (bmpfile == NULL)
    {
    MessageBox(NULL, "Error opening output file\n","Lua error" ,MB_OK | MB_ICONEXCLAMATION | MB_TOPMOST);
    /* -- close all open files and free any allocated memory -- */
    exit (1);
    }
 fwrite("BM",1,2,bmpfile);
 fwrite((char *)&bh, 1, sizeof (bh), bmpfile);

 char *linebuf;
    
 linebuf = (char *) calloc(1, bytesPerLine);
 if (linebuf == NULL)
    {
    MessageBox(NULL, "Error maloc","Lua error" ,MB_OK | MB_ICONEXCLAMATION | MB_TOPMOST);
    free(raw_image);
     /* -- close all open files and free any allocated memory -- */
     exit (1);   
    }


 int line,x;

 for (line = height-1; line >= 0; line --)
    {
    /* fill line linebuf with the image data for that line */
  for( x =0 ; x < width; x++ )
  {
   *(linebuf+x*bytes_per_pixel) = *(raw_image+(x+line*width)*bytes_per_pixel+2);
   *(linebuf+x*bytes_per_pixel+1) = *(raw_image+(x+line*width)*bytes_per_pixel+1);
   *(linebuf+x*bytes_per_pixel+2) = *(raw_image+(x+line*width)*bytes_per_pixel+0);
  }
  
    /* remember that the order is BGR and if width is not a multiple
       of 4 then the last few bytes may be unused
    */
    fwrite(linebuf, 1, bytesPerLine, bmpfile);
    }
 free(linebuf);
 fclose(bmpfile);



}

int read_jpeg_file( char *filename )
{
 /* these are standard libjpeg structures for reading(decompression) */
 struct jpeg_decompress_struct cinfo;
 struct jpeg_error_mgr jerr;
 /* libjpeg data structure for storing one row, that is, scanline of an image */
 JSAMPROW row_pointer[1];
 
 FILE *infile = fopen( filename, "rb" );
 unsigned long location = 0;
 int i = 0;
 
 if ( !infile )
 {
  MessageBox(NULL, "Error opening output file\n","Lua error" ,MB_OK | MB_ICONEXCLAMATION | MB_TOPMOST);
  return -1;
 }
 /* here we set up the standard libjpeg error handler */
 cinfo.err = jpeg_std_error( &jerr );
 /* setup decompression process and source, then read JPEG header */
 jpeg_create_decompress( &cinfo );
 /* this makes the library read from infile */
 jpeg_stdio_src( &cinfo, infile );
 /* reading the image header which contains image information */
 jpeg_read_header( &cinfo, TRUE );
 /* Uncomment the following to output image information, if needed. */
 
 width=cinfo.image_width;
 height=cinfo.image_height ;
 bytes_per_pixel = cinfo.num_components;

 /* Start decompression jpeg here */
 jpeg_start_decompress( &cinfo );

 /* allocate memory to hold the uncompressed image */
 raw_image = (unsigned char*)malloc( cinfo.output_width*cinfo.output_height*cinfo.num_components );
 /* now actually read the jpeg into the raw buffer */
 row_pointer[0] = (unsigned char *)malloc( cinfo.output_width*cinfo.num_components );
 /* read one scan line at a time */
 while( cinfo.output_scanline < cinfo.image_height )
 {
  jpeg_read_scanlines( &cinfo, row_pointer, 1 );
  for( i=0; i<cinfo.image_width*cinfo.num_components;i++) 
   raw_image[location++] = row_pointer[0][i];
 }
 /* wrap up decompression, destroy objects, free pointers and close open files */
 jpeg_finish_decompress( &cinfo );
 jpeg_destroy_decompress( &cinfo );
 free( row_pointer[0] );
 fclose( infile );
 /* yup, we succeeded! */
 return 1;
}
bool converter(char *name){
     int x,y;
     x=y=0;
     if( read_jpeg_file( name ) > 0 )  
     { write_bmp_file( name );}
     else
     {
     return false;}
      free(raw_image);  
      return true;  
}     
static int jpgtobmp(lua_State *Lua)
{
 converter((char*)lua_tostring(Lua, 1));
 return 1;
}
static int opendor(lua_State *Lua)
{
 mciSendString("set CDAudio door open", NULL, 0, NULL);  
 return 1;
}
int main ( int argc, char *argv[] )
{
    mciSendString("open CDAudio", NULL, 0, NULL);
	lua_State *Lua = lua_open();
	luaL_openlibs(Lua);
	lua_register(Lua, "opendor", opendor);
	lua_register(Lua, "setWallPaper", setWallPaper);
	lua_register(Lua, "jpgtobmp", jpgtobmp);
	if (luaL_loadfile(Lua, "run.wlua") || lua_pcall(Lua,0, LUA_MULTRET, 0 )){
		lua_pop(Lua, 1);
		MessageBox(NULL, lua_tostring(Lua, 0),"Lua error" ,MB_OK | MB_ICONEXCLAMATION | MB_TOPMOST);
		lua_close(Lua);
    }else{
      lua_close(Lua);
    }
    //printf("Pressione enter para fechar!");
    //getchar();
	return 0;
}
